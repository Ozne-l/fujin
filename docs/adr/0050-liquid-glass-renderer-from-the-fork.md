# 50. liquid_glass_renderer from the owner's fork

Date: 2026-11-21

## Status

Accepted. Supersedes [0048](0048-patched-liquid-glass-renderer.md): the patched copy in `third_party` is gone. Amends [0041](0041-liquid-glass-renderer-1.0.md) again.

## Context

[0048](0048-patched-liquid-glass-renderer.md) fixed the band left under a glass shape that shrinks on Impeller Vulkan by copying release `1.0.0-dev.2` of the package into the repository with a one-line patch. It rejected a git fork because the patch would live outside the repository.

The fix is now also offered upstream, from the owner's fork `Ozne-l/flutter_liquid_glass` (branch `fix/vulkan-matte-clear`, based on upstream `main`). The upstream version drops the `dontCare` render target from the renderer and adds a test, `a reused texture keeps nothing of the larger matte it held`, which fails on `main` under `flutter test` (Impeller Vulkan by default) and passes with the fix. On the owner's Pixel 8 under Vulkan, a repro app shows the band without the fix and not with it; under OpenGL ES the fix changes no pixel.

The vendored copy cost 220 files (4.5 MB) of third-party code in Fūjin, an analyzer exclusion, a manual update path, and a permanent finding of the pre-commit overlap check on its vendored LICENSE. Fūjin already takes three packages from git (`ekklo_client`, `myfitnesspal_client`, `progressive_blur`), and [0041](0041-liquid-glass-renderer-1.0.md) took this one from the same fork before `1.0.0-dev.2`.

## Decision

- `pubspec.yaml` takes `liquid_glass_renderer` from `https://github.com/Ozne-l/flutter_liquid_glass.git`, `path: packages/liquid_glass_renderer`, pinned to commit `c74c7c27f41ebb1592609fa87c873afea9eb81b6`.
- That commit is the tip of the fork's branch `fujin/1.0.0-dev.2-matte-clear`: the tag `liquid_glass_renderer-v1.0.0-dev.2` plus the upstream fix. It leaves out the later upstream commits (from #255 on), which Fūjin has not run. Its code differs from the vendored copy only by the removed `dontCare` target and comments, so the benchmark recorded in [0048](0048-patched-liquid-glass-renderer.md) still applies.
- `third_party/`, its analyzer exclusion and its `.gitignore` line are removed.
- Considered and rejected:
  - Keeping the vendored copy: see the costs above.
  - Pinning the commit of the upstream pull request: it brings upstream `main` after `1.0.0-dev.2`, untested in Fūjin, and its branch may be deleted once merged.

## Consequences

- The branch `fujin/1.0.0-dev.2-matte-clear` and the fork must stay until Fūjin moves off it; deleting either can make the pinned commit unreachable for `flutter pub get`.
- Drop the fork when a pub.dev release carries the fix: pin that release, then send a long message in an Ekklo conversation on a Vulkan device and check that no band stays under the composer.
- A change to the package for Fūjin goes on the fork's branch first, then the pin moves to the new commit.
