# Patched liquid_glass_renderer

This is the pub.dev release `1.0.0-dev.2` of the package, copied unchanged except for the one line below. See [ADR 0048](../../docs/adr/0048-patched-liquid-glass-renderer.md).

```diff
--- pub.dev/lib/src/internal/flutter_gpu_geometry_renderer_native.dart
+++ third_party/liquid_glass_renderer/lib/src/internal/flutter_gpu_geometry_renderer_native.dart
@@ -454,5 +454,5 @@ class FlutterGpuGeometryRenderer {
       final geometryPass =
           geometryCommandBuffer.createRenderPass(
-              drawRect == null ? _renderTarget! : _clearingRenderTarget!,
+              _clearingRenderTarget!,
             )
             ..bindPipeline(_pipeline)
```

## Why

The geometry matte is drawn into textures that are reused from frame to frame. When the shapes fill most of the matte, upstream draws the whole of it through `renderTarget` (`LoadAction.dontCare`). Otherwise it draws only near the shapes, through `clearingRenderTarget` (`LoadAction.clear`), and relies on the clear for the rest of the texture.

Impeller on Vulkan caches one `VkRenderPass` per texture. The cache is keyed by sample count, mip level and slice, not by load action (`TextureSourceVK::GetCachedFrameData`, used in `render_pass_vk.cc`), so every later pass on that texture reuses the load action of its first pass. A texture first drawn with `dontCare` is never cleared afterwards. When a glass shape shrinks, the smaller matte goes into a texture that last held the taller one. Its old inside texels stay outside the scissor and render as glass.

In Fūjin this showed in the chat composer: after a long message was sent, the field shrank and left a lighter L-shaped band under it and along its right side. It appears only on Vulkan, which is what the Pixel 8 uses. OpenGLES has no such cache.

With the patch, every matte pass clears through the same render target, so the cached render pass always clears. The cost is clearing the whole low-resolution texture on passes that drew all of it anyway.

## When to drop it

Drop the patch when either of these is published:

- a `liquid_glass_renderer` release that no longer relies on a second load action for a reused texture;
- a Flutter release whose Vulkan render pass cache takes the load action into account.

To drop it, delete this directory and pin the release on pub.dev in `pubspec.yaml`. Then send a long message in an Ekklo conversation on a Vulkan device and check that no band stays under the composer.
