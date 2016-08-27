package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUITypedButton;
import flash.geom.Rectangle;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

/**
 * ...
 * @author Bradley Teo
 */
class Desk extends FlxSpriteGroup
{
	
	private var ps:PlayState;
	public var levelTitle:FlxText;
	public var levelDescription:FlxText;
	private var offsetX:Int;
	private var offsetY:Int;
	private var testButton:FlxUIButton;
	private var results:FlxSprite;
	private var nextLevelButton:FlxUIButton;
	private var testMessage:FlxText;
	public function new(_ps: PlayState, _ox:Int, _oy:Int) 
	{
		super();
		ps = _ps;
		offsetX = _ox;
		offsetY = _oy;
		levelTitle = new FlxText(offsetX + PlayState.padding, offsetY, 0, "", 16);
		levelTitle.setFormat(AssetPaths.GoetheBold__ttf, 32, 0xff111111);
		levelDescription = new FlxText(offsetX + PlayState.padding, offsetY + 32, PlayState.gridWidth, "", 12);
		levelDescription.setFormat(AssetPaths.Munro__ttf, 16, 0xff111111);
		add(levelTitle);
		add(levelDescription);
		
		testMessage = new FlxText(offsetX + PlayState.padding, offsetY + 96, PlayState.gridWidth, "", 12);
		testMessage.setFormat(AssetPaths.Munro__ttf, 16, 0xffaa1111);
		add(testMessage);
		
		testButton = new FlxUIButton(offsetX + PlayState.padding * 2 + PlayState.gridWidth, offsetY, "Run Tests", runTests);
		testButton.resize(128 - 8 * 2, 20);
		add(testButton);
		
		results = new FlxSprite(offsetX + PlayState.padding * 2 + 24 + PlayState.gridWidth, offsetY + 32);
		results.loadGraphic(AssetPaths.ok_stamp__png);
		results.visible = false;
		add(results);
		
		nextLevelButton = new FlxUIButton(offsetX + PlayState.padding * 2 + PlayState.gridWidth, offsetY + 76, "Next Level", nextLevel);
		nextLevelButton.resize(128 - 8 * 2, 20);
		nextLevelButton.kill();
		add(nextLevelButton);
	}
	
	private function tweenResults() {
		results.scale = new FlxPoint(4, 4);
		results.alpha = 0;
		results.visible = true;
		FlxTween.tween(results, { x: offsetX + PlayState.padding * 2 + 24 + PlayState.gridWidth, y: offsetY + 32, alpha: 1}, 0.2, {ease: FlxEase.quadIn });
		FlxTween.angle(results, 5, -10, 0.2, {ease: FlxEase.quadIn });
		FlxTween.tween(results.scale, { x: 2, y: 2 }, 0.2, {ease: FlxEase.quadIn } );
	}
	
	private function runTests() {
		testMessage.text = "";
		ps.wireGrid.runTests();
	}
	
	public function showResult() {
		if (ps.wireGrid.testsPassed) {
			results.loadGraphic(AssetPaths.ok_stamp__png);
			nextLevelButton.revive();
		}
		else {
			results.loadGraphic(AssetPaths.fail_stamp__png);
			testMessage.text = ps.wireGrid.testMessage;
		}
		tweenResults();
	}
	
	private function nextLevel() {
		ps.changeLevel(ps.levelNo + 1);
		results.visible = false;
		nextLevelButton.kill();
		testMessage.text = "";
	}
	
}