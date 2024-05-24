package openfl.text;

import openfl.text.TextFieldAtlas;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.geom.Matrix;
import openfl.text.MaxRectsBinPack;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.BitmapData;

/**
 * 文本渲染缓存纹理，一般在渲染位图为TextField
 */
class TextFieldCacheBitmapData {
	/**
	 * 纹理
	 */
	public var bitmapData:BitmapData;

	/**
	 * 打包器
	 */
	public var rects:MaxRectsBinPack;

	/**
	 * 缓存版本号
	 */
	public var version:Int = 0;

	/**
	 * 图集
	 */
	private var __atlas:TextFieldAtlas;

	private var __textFormat:TextFormat;

	/**
	 * 文本渲染器
	 */
	private var __textField:TextField;

	private var __offestX:Int = 0;

	private var __offestY:Int = 0;

	private var __redrawing:Bool = false;

	public function new(size:Int = 36, textureWidth:Int = 2048, textureHeight:Int = 2048, offestX:Int = 0, offestY:Int = 0) {
		this.__offestX = offestX;
		this.__offestY = offestY;
		bitmapData = new BitmapData(textureWidth, textureHeight, true, 0x0);
		rects = new MaxRectsBinPack(textureWidth, textureHeight, false);
		bitmapData.disposeImage();
		__textFormat = new TextFormat(null, size, 0xffffff);
		__textFormat.leading = Std.int(size / 2);
		__textField = new TextField();
		__atlas = new TextFieldAtlas(bitmapData);
		__atlas.fontSize = size + offestY / 2;
	}

	/**
	 * 渲染文本
	 * @param text 
	 */
	public function drawText(text:String):Void {
		// 过滤重复的文本
		var caches:Array<String> = [];
		var chars = text.split("");
		for (char in chars) {
			if (char == " " || char == "\n" || char == "\r")
				continue;
			if (__atlas.getTileFrame(char.charCodeAt(0)) == null)
				if (!caches.contains(char)) {
					caches.push(char);
				}
		}
		if (caches.length == 0)
			return;
		text = caches.join(" ");
		__textField.wordWrap = true;
		__textField.text = text;
		__textField.width = 2048;
		__textField.setTextFormat(__textFormat);
		var pakWidth = Std.int(__textField.textWidth + __offestX * 3);
		var pakHeight = Std.int(__textField.textHeight + __offestY * 3);
		__textField.height = pakHeight;
		var pakRect = rects.insert(pakWidth, pakHeight, FreeRectangleChoiceHeuristic.BestShortSideFit);
		if (pakRect == null || pakRect.width == 0 || pakRect.height == 0) {
			// 当缓冲区满了之后，应该清空所有文字，重新渲染
			// trace("溢出了", pakRect, pakWidth, pakHeight, text);
			if (__redrawing) {
				trace("TextFieldContextBitmapData: 缓冲区满了，停止渲染");
				return;
			}
			__redrawing = true;
			this.redraw();
			__redrawing = false;
			return;
		}

		var m = new Matrix();
		m.translate(pakRect.x, pakRect.y);
		bitmapData.draw(__textField, m);
		for (i in 0...__textField.text.length) {
			var char = __textField.text.charAt(i);
			if (char == " ")
				continue;
			var rect = __textField.getCharBoundaries(i);
			rect.x += pakRect.x;
			rect.y += pakRect.y;
			rect.x -= __offestX;
			rect.width += __offestX * 2;
			rect.y -= __offestY;
			rect.height += __offestY * 2;
			this.__atlas.pushChar(char, rect, Std.int(rect.width - __offestX * 2));

			// 测试
			#if text_debug
			var spr = new Sprite();
			spr.graphics.beginFill(0xff0000, 0.5);
			spr.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			spr.graphics.endFill();
			bitmapData.draw(spr);
			#end
		}
	}

	/**
	 * 清空文字纹理渲染
	 */
	public function clear():Void {
		version++;
		__textField = new TextField();
		bitmapData.fillRect(bitmapData.rect, 0x0);
		__atlas.clear();
		rects = new MaxRectsBinPack(bitmapData.width, bitmapData.height, false);
	}

	/**
	 * 对当前显示对象进行重绘
	 */
	public function redraw():Void {
		this.clear();
		__redrawAll(Lib.current.stage, (display) -> {
			if (display is Label) {
				var label:Label = cast display;
				var oldText = label.text;
				label.text = "";
				label.text = oldText;
			}
			return true;
		});
	}

	/**
	 * 遍历容器里的所有对象
	 * @param display 
	 * @param cb 当返回`false`时，则会中断循环
	 */
	private function __redrawAll(display:DisplayObjectContainer, cb:DisplayObject->Bool):Bool {
		for (i in 0...display.numChildren) {
			var d = display.getChildAt(i);
			var b = cb(d);
			if (!b)
				return false;
			if (d is DisplayObjectContainer) {
				var b = __redrawAll(cast d, cb);
				if (!b)
					break;
			}
		}
		return true;
	}

	/**
	 * 获得纹理
	 * @return Atlas
	 */
	public function getAtlas():TextFieldAtlas {
		return __atlas;
	}
}
