# openfl_cache_textfield
#### English
1. Use BitmapData to cache the rendered text for rendering the next time the text is used.
2. The cache canvas is limited to 2048 * 2048 pixels. If it exceeds the canvas range, the canvas will be cleared and cached again.
3. If you do not want to use cache mode, you can change it to TextField rendering by setting the 'mode' to 'TXTFIELD'.
4. If you want the best performance, you can also consider merging these two PRs:
- BitmapData.draw improvement: https://github.com/openfl/openfl/pull/2707

#### 中文
1. 使用BitmapData对已渲染的文本进行缓存，以便下次文本使用时，进行渲染。
2. 缓存画布限制为2048*2048像素，如果超出画布范围时，则会清空画布，重新缓存。
3. 如果不希望使用缓存模式，可以通过`mode`设置为`TEXTFIELD`更改为`TextField`渲染。
4. 如果你想得到最佳的性能，还可以考虑合并这两个PR：
- BitmapData.draw改进：https://github.com/openfl/openfl/pull/2707
- Tilemap改进：(未创建PR)
