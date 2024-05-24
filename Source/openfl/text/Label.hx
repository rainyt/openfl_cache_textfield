package openfl.text;

import openfl.geom.ColorTransform;
import openfl.display.Sprite;

/**
 * 文本工具
 */
class Label extends Sprite {
	/**
	 * 缓存的位图纹理配置，字符大小为36px，如果需要让字符看得更清晰，可以修改它的字符大小
	 */
	public static var textFieldCacheBitmapData:TextFieldCacheBitmapData = new TextFieldCacheBitmapData(36, 2048, 2048, 4, 6);

	/**
	 * 文本渲染器
	 */
	private var __textField:TextField;

	/**
	 * Tilemap渲染器
	 */
	private var __tilemap:TilemapLabel;

	/**
	 * 是否发生变更
	 */
	private var __dirt:Bool = false;

	/**
	 * 渲染模式，CACHE则使用缓存纹理渲染、TEXTFIELD则使用原生渲染
	 */
	public var mode(default, set):TextFieldRenderMode = CACHE;

	private var __width:Float = 100;

	override function set_width(width:Float):Float {
		__width = width;
		this.invalidate();
		return width;
	}

	override function get_width():Float {
		return __width;
	}

	private var __height:Float = 100;

	override function set_height(height:Float):Float {
		__height = height;
		this.invalidate();
		return width;
	}

	override function get_height():Float {
		return __height;
	}

	private function set_mode(v:TextFieldRenderMode):TextFieldRenderMode {
		if (this.mode == v)
			return v;
		this.mode = v;
		this.__tilemap.parent?.removeChild(this.__tilemap);
		this.__textField.parent?.removeChild(this.__textField);
		this.invalidate();
		return v;
	}

	/**
	 * 字体格式
	 */
	public var textFormat(default, set):TextFormat = new TextFormat(null, 18, 0x0);

	private function set_textFormat(t:TextFormat):TextFormat {
		this.textFormat = t;
		this.invalidate();
		return t;
	}

	public function new() {
		super();
		__textField = new TextField();
		__textField.wordWrap = true;
		__textField.selectable = false;
		__tilemap = new TilemapLabel(textFieldCacheBitmapData.getAtlas());
		__tilemap.wordWrap = true;
	}

	/**
	 * 文本赋值
	 */
	public var text(default, set):String;

	private function set_text(value:String):String {
		if (this.text == value)
			return value;
		this.text = value;
		this.invalidate();
		return value;
	}

	override function invalidate() {
		super.invalidate();
		this.__dirt = true;
	}

	override function __enterFrame(deltaTime:Int):Void {
		super.__enterFrame(deltaTime);
		if (this.__dirt) {
			switch mode {
				case CACHE:
					__renderTilemap();
				case TEXTFIELD:
					__renderTextField();
			}
			this.__dirt = false;
		}
	}

	private function __renderTilemap():Void {
		__tilemap.width = __width;
		__tilemap.height = __height;
		textFieldCacheBitmapData.drawText(this.text);
		__tilemap.size = textFormat.size;
		__tilemap.text = this.text;
		var r = (textFormat.color >> 16) & 0xFF;
		var g = (textFormat.color >> 8) & 0xFF;
		var b = textFormat.color & 0xFF;
		__tilemap.transform.colorTransform = new ColorTransform(r, g, b);
		if (__tilemap.parent == null)
			this.addChild(__tilemap);
	}

	private function __renderTextField():Void {
		__textField.width = __width;
		__textField.height = __height;
		__textField.text = this.text;
		__textField.setTextFormat(textFormat);
		var textHeight = __textField.textHeight;
		if (textHeight > __textField.height) {
			__textField.height = textHeight;
		}
		if (__textField.parent == null)
			this.addChild(__textField);
	}
}
