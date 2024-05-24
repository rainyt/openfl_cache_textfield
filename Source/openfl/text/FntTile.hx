package openfl.text;

import openfl.display.Tile;

class FntTile extends Tile {
	/**
	 * 当前字符帧
	 */
	public var curFrame:BaseFrame;

	public function new(frame:BaseFrame):Void {
		super();
		setFrame(frame);
	}

	/**
	 * 设置
	 * @param frame 
	 */
	public function setFrame(frame:BaseFrame):Void {
		curFrame = frame;
		if (frame == null) {
			this.id = -1;
		} else {
			this.id = frame.id;
		}
	}

	/**
	 * 根据Frame获取对应的ID
	 * @return Int
	 */
	override function get_id():Int {
		if (curFrame == null) {
			this.id = -1;
			return -1;
		} else {
			this.id = curFrame.id;
			return curFrame.id;
		}
	}
}
