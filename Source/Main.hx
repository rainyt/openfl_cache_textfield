package;

import openfl.events.Event;
import openfl.display.Bitmap;
import openfl.text.Label;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();
		stage.color = 0x666666;

		// DEBUG
		// var bitmap = new Bitmap(Label.textFieldCacheBitmapData.bitmapData);
		// this.addChild(bitmap);

		var labels:Array<Label> = [];

		for (i in 0...200) {
			// Labels
			var label = new Label();
			this.addChild(label);
			label.text = "";
			label.mode = CACHE;
			label.x = Std.random(Std.int(stage.stageWidth));
			label.y = Std.random(Std.int(stage.stageHeight));
			labels.push(label);
		}

		var chars = "QWERTYUIOPLKJHGFDSAZXCVBNM".split("");

		this.addEventListener(Event.ENTER_FRAME, (e) -> {
			for (label in labels) {
				label.text = chars[Std.random(chars.length)] + Std.random(100);
			}
		});
	}
}
