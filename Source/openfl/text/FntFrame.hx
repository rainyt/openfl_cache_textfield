package openfl.text;

/**
 * 位图精灵帧
 */
 class FntFrame extends BaseFrame {
	public var xadvance:Int = 0;

	public var xoffset(get, set):Float;

	private function set_xoffset(f:Float):Float {
		x = f;
		return f;
	}

	private function get_xoffset():Float {
		return x;
	}

	public var yoffset(get, set):Float;

	private function set_yoffset(f:Float):Float {
		y = f;
		return f;
	}

	private function get_yoffset():Float {
		return y;
	}

	public function new() {}
}
