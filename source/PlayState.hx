package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	public static var gridRows = 20;
	public static var gridColumns = 30;
	public static var gridElementSize = 16;
	public static var padding = 16;
	public static var gridHeight = gridRows * gridElementSize;
	public static var gridWidth = gridColumns * gridElementSize;
	
	public var wireGrid:WireGrid;
	public var componentSelector:ComponentSelector;
	public var desk:Desk;
	public var levelNo:Int = 0;
	public var curLevel:Level = null;
	
	override public function create():Void
	{
		super.create();
		
		var bg = new FlxSprite(160, 120);
		//bg.makeGraphic(640, 480, 0xffd6a249);
		bg.loadGraphic(AssetPaths.bg__png, false);
		bg.scale.set(2, 2);
		add(bg);
		
		wireGrid = new WireGrid(this);
		add(wireGrid);
		componentSelector = new ComponentSelector(this, gridWidth + padding * 2, 0);
		add(componentSelector);
		desk = new Desk(this, 0, gridHeight + padding * 2);
		add(desk);
		
		changeLevel(Reg.level);
		Reg.scenePlayed = false;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.RIGHT) {
			changeLevel(Reg.level + 1);
		}
	}
	
	public function changeLevel(_levelNo:Int):Void
	{
		Reg.level = levelNo = _levelNo;
		FlxG.save.data.level = Reg.level;
		FlxG.save.flush();
		if (!Reg.scenePlayed) {
			if (levelNo == 3) {
				FlxG.switchState(new SceneState(["assets/images/slide1.png", "assets/images/slide5.png", "assets/images/slide6.png"], function ()
				{
					FlxG.switchState(new PlayState());
				}));
			}
			if (levelNo == 9) {
				FlxG.switchState(new SceneState(["assets/images/slide7.png"], function ()
				{
					FlxG.switchState(new PlayState());
				}));
			}
		}
		if (levelNo == Levels.levels.length) {
			FlxG.switchState(new GameOverState());
		} else {
			componentSelector.revealTools(levelNo);
			curLevel = Levels.levels[_levelNo];
			desk.levelTitle.text = Std.string(Reg.level + 1) + ". " + curLevel.levelName;
			desk.levelDescription.text = curLevel.levelDescription;
		}
	}
	
	
}