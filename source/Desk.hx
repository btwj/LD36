package;

import flixel.addons.ui.FlxUIText;
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
import flixel.FlxG;

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
		levelTitle.setFormat(AssetPaths.PixelOperatorBold__ttf, 32, 0xff111111);
		levelDescription = new FlxText(offsetX + PlayState.padding, offsetY + 36, PlayState.gridWidth, "", 12);
		levelDescription.setFormat(AssetPaths.PixelOperator__ttf, 16, 0xff111111);
		add(levelTitle);
		add(levelDescription);
		
		testMessage = new FlxText(offsetX + PlayState.padding, offsetY + 96, PlayState.gridWidth, "", 12);
		testMessage.setFormat(AssetPaths.PixelOperator__ttf, 16, 0xffaa1111);
		add(testMessage);
		
		testButton = new FlxUIButton(offsetX + PlayState.padding * 2 + PlayState.gridWidth, offsetY, "Run Tests", runTests);
		testButton.resize(128 - 8 * 2, 20);
		var buttonLabel = new FlxUIText(0, 0, 112, "Run Tests", 16);
		buttonLabel.setFormat(AssetPaths.PixelOperator__ttf, 16, 0xff000000, FlxTextAlign.CENTER);
		testButton.setLabel(buttonLabel);
		testButton.label.offset.y += 4;
		add(testButton);
		
		results = new FlxSprite(offsetX + PlayState.padding * 2 + 24 + PlayState.gridWidth, offsetY + 32);
		results.loadGraphic(AssetPaths.ok_stamp__png);
		results.visible = false;
		
		nextLevelButton = new FlxUIButton(offsetX + PlayState.padding * 2 + PlayState.gridWidth, offsetY + 76, "Next Level", nextLevel);
		nextLevelButton.resize(128 - 8 * 2, 20);
		buttonLabel = new FlxUIText(0, 0, 112, "Next Level", 16);
		buttonLabel.setFormat(AssetPaths.PixelOperator__ttf, 16, 0xff000000, FlxTextAlign.CENTER);
		nextLevelButton.setLabel(buttonLabel);
		nextLevelButton.label.offset.y += 4;
		nextLevelButton.kill();
		add(nextLevelButton);
		
		add(results);
	}
	
	private function tweenResults() {
		results.scale = new FlxPoint(4, 4);
		results.alpha = 0;
		results.visible = true;
		FlxTween.tween(results, { x: offsetX + PlayState.padding * 2 + 24 + PlayState.gridWidth, y: offsetY + 32, alpha: 1}, 0.2, {ease: FlxEase.quadIn });
		FlxTween.angle(results, 5, -15, 0.2, {ease: FlxEase.quadIn });
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
		FlxG.sound.play(AssetPaths.stamp_sound__wav);
		tweenResults();
	}
	
	private function nextLevel() {
		ps.changeLevel(ps.levelNo + 1);
		results.visible = false;
		nextLevelButton.kill();
		testMessage.text = "";
	}
	
}