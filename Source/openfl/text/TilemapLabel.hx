package openfl.text;

import openfl.display.Tilemap;
import openfl.display.TileContainer;

class TilemapLabel extends Tilemap {
	/**
	 * 文本设置
	 */
	public var text(default, set):String;

	private var __node:TileContainer = new TileContainer();

	/**
	 * 字体大小
	 */
	public var size(default, set):Int = 0;

	/**
	 * 是否自动换行
	 */
	public var wordWrap(default, set):Bool = false;

	private function set_wordWrap(v:Bool):Bool {
		this.wordWrap = v;
		return v;
	}

	private function set_size(v:Int):Int {
		this.size = v;
		return v;
	}

	/**
	 * 文本宽度
	 */
	public var textWidth(default, null):Float;

	/**
	 * 文本高度
	 */
	public var textHeight(default, null):Float;

	/**
	 * 纹理图片
	 */
	public var atlas:TextFieldAtlas;

	public function new(atlas:TextFieldAtlas) {
		this.atlas = atlas;
		super(100, 100, atlas.getTileset());
		this.addTile(__node);
	}

	private function set_text(v:String):String {
		if (this.text == v)
			return v;
		this.text = v;
		__updateText();
		return v;
	}

	private function __updateText():Void {
		__node.removeTiles();
		textWidth = 0;
		var _lineHeight = atlas.getFontHeight();
		textHeight = atlas.maxHeight;
		var offestX:Float = 0;
		var offestY:Float = 0;
		var scaleFloat:Float = this.size > 0 ? (this.size / _lineHeight) : 1;
		var lastWidth:Float = 0;
		var _texts = this.text.split("");
		for (char in _texts) {
			var id:Int = char.charCodeAt(0);
			var frame:FntFrame = atlas.getTileFrame(id);
			if (frame != null) {
				if (wordWrap && (offestX + frame.width) * scaleFloat > this.width) {
					offestX = 0;
					offestY += atlas.maxHeight;
					textHeight += atlas.maxHeight;
				}
				var tile:FntTile = new FntTile(frame);
				__node.addTile(tile);
				tile.x = offestX + frame.xoffset;
				tile.y = offestY + frame.yoffset;
				offestX += Std.int(frame.xadvance);
				lastWidth = frame.width;
				if (offestX > textWidth) {
					textWidth = offestX;
				}
			} else if (char == " ") {
				offestX += (size != 0 ? size : lastWidth) * 0.8;
				if (offestX > textWidth) {
					textWidth = offestX;
				}
			} else if (char == "\n") {
				offestX = 0;
				offestY += atlas.maxHeight;
				textHeight += atlas.maxHeight;
			}
		}
		__node.scaleX = __node.scaleY = scaleFloat;
	}

	override private function get_width():Float {
		if (__width == 0)
			return this.textWidth;
		return Math.abs(__width * scaleX);
	}

	override private function set_width(w:Float):Float {
		if (this.width == w)
			return w;
		super.set_width(w);
		__updateText();
		return w;
	}

	override private function get_height():Float {
		return __height;
	}

	override private function set_height(h:Float):Float {
		if (this.height == h)
			return h;
		super.set_height(h);
		__updateText();
		return h;
	}
}
