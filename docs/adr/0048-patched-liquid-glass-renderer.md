# 48. Patched liquid_glass_renderer in third_party

Date: 2026-11-19

## Status

Superseded by [0050](0050-liquid-glass-renderer-from-the-fork.md): the package comes from the owner's fork, no longer from `third_party`. Amended [0041](0041-liquid-glass-renderer-1.0.md): the package is no longer pinned on pub.dev.

## Context

On the owner's Pixel 8 (Impeller on Vulkan), sending a long message in the Ekklo chat ([0047](0047-chat-screens.md)) left a lighter, L-shaped band under the composer field and up its right side. The band did not go away.

The cause lies in the package (release `1.0.0-dev.2`) and Impeller, not in Fūjin:

- The package draws each glass layer's low-resolution geometry matte into textures that it reuses, and that only grow.
- When the shapes fill most of the matte, the package draws all of it through a render target with `LoadAction.dontCare`. Otherwise it draws only near the shapes, through a second render target with `LoadAction.clear`, and relies on the clear for the rest.
- Impeller on Vulkan caches one render pass per texture, whatever the load action, so a texture first drawn with `dontCare` is never cleared afterwards.
- When the composer field shrinks after a send, its matte goes into the texture that held the taller field. The stale texels outside the new shape render as glass.

On the emulator forced to Vulkan, a log of the matte passes showed one texture first drawn whole at 896×320 and then reused for the 896×192 field, with a scissor of 219×41 in a 225×49 pass. The band covered exactly the missing rows and columns. On OpenGLES the band does not appear.

`1.0.0-dev.2` is the latest release on pub.dev. Upstream `main` (`8e1e7d6`) still has the code, and no upstream issue or pull request covers it.

## Decision

- The package is vendored at `third_party/liquid_glass_renderer/`: the `1.0.0-dev.2` sources unchanged, with their LICENSE, except for one line. Every matte pass now goes through the clearing render target, so whatever render pass the texture caches, it clears.
- `pubspec.yaml` depends on it with `path: third_party/liquid_glass_renderer` in place of the version.
- `third_party/liquid_glass_renderer/PATCH.md` gives the diff, the reason and when to drop it.
- The analyzer excludes `third_party/**`. `dart format` already covers only Fūjin's own directories.
- Considered and rejected:
  - Remounting the composer's glass whenever the field shrinks, to get fresh textures. It works around the package's internals from Fūjin's code, and any other glass that shrinks would show the same band.
  - A git fork, as [0041](0041-liquid-glass-renderer-1.0.md) once used. It would keep the patch outside the repository.

## Consequences

- Each matte pass clears its whole low-resolution texture, including passes that draw all of it anyway. On the Pixel 8 (2026-11-20, two profile runs of each build), the glass benchmark shows no difference beyond run-to-run noise between the patched copy and the pub.dev release: average raster time 12.1 to 12.7 ms on both for the tab switch, 8.5 to 11.0 ms with the patch against 9.0 to 9.1 ms without for the chat thread, and the other scenarios overlap the same way.
- Updating `liquid_glass_renderer` means replacing the directory and checking whether the patch is still needed. Drop the patch when a release stops relying on a second load action for a reused texture, or when Flutter's Vulkan render pass cache takes the load action into account. Then pin the release on pub.dev again.
- No automated test covers the band. Widget tests run on `FakeGlass`, which has no Flutter GPU matte. The band shows only on a Vulkan device, so the check is manual: send a long message in a conversation.
