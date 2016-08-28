package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxSave;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		if (FlxG.save.data.level != null) {
			Reg.level = FlxG.save.data.level;
			FlxG.switchState(new PlayState());
		}
		
		FlxG.switchState(new SceneState([
			"assets/images/slide0.png",
			"assets/images/slide2.png",
			"assets/images/slide3.png",
			"assets/images/slide4.png"
		], function ()
		{
			FlxG.switchState(new PlayState());
		}));
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}	
}