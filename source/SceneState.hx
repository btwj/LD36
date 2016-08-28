package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;

/**
 * ...
 * @author Bradley Teo
 */
class SceneState extends FlxState
{
	var curImageNo:Int = 0;
	private var images:Array<String>;
	private var cb:Void->Void;
	private var sprBg:FlxSprite;

	public function new(_images:Array<String>, _cb:Void->Void) 
	{
		super();
		images = _images;
		cb = _cb;
	}
	
	override public function create() 
	{
		sprBg = new FlxSprite(160, 120);
		sprBg.loadGraphic(images[0], false);
		sprBg.scale.set(2, 2);
		Reg.scenePlayed = false;
		add(sprBg);
	}
	
	override public function update(elapsed:Float) {
		Reg.scenePlayed = true;
		if (FlxG.mouse.justPressed) {
			curImageNo++;
			if (curImageNo >= images.length) {
				cb();
			} else {
				sprBg.loadGraphic(images[curImageNo], false, 640, 480);
			}
		}
	}
	
}