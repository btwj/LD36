package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

/**
 * ...
 * @author Bradley Teo
 */
class GameOverState extends FlxState
{

	private var sprBg:FlxSprite;
	
	public function new() 
	{
		super();
	}
	
	override public function create() {
		sprBg = new FlxSprite(160, 120);
		sprBg.loadGraphic(AssetPaths.gameover__png, false);
		sprBg.scale.set(2, 2);
		Reg.scenePlayed = false;
		add(sprBg);
		Reg.level = 0;
		FlxG.save.data.level = null;
		FlxG.save.flush();
	}
	
}