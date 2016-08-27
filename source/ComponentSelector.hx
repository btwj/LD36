package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUITooltipManager;
/**
 * ...
 * @author Bradley Teo
 */
class ComponentSelector extends FlxSpriteGroup
{
	
	private var ps:PlayState;
	private var wireButton:FlxButton;
	private var cathodeButton:FlxButton;
	private var screenButton:FlxButton;
	private var anodeButton:FlxButton;
	private var voltageButton:FlxButton;
	private var groundButton:FlxButton;
	private var inputButton:FlxButton;
	private var outputButton:FlxButton;
	
	private var offsetX:Int = 0;
	private var offsetY:Int = 0;
	
	public var activeTool:Int = 0;

	public function new(_ps:PlayState, _ox:Int, _oy:Int) 
	{
		super();
		ps = _ps;
		offsetX = _ox;
		offsetY = _oy;
		
		var bg = new FlxSprite(offsetX, offsetY);
		bg.makeGraphic(128, PlayState.gridHeight + PlayState.padding * 2, 0xff222222);
		//add(bg);
		/*
		var title = new FlxText(offsetX, offsetY + 16, 0, "Components", 16);
		title.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xff292929, 2, 1);
		add(title);
		*/
		wireButton = new FlxButton(offsetX, 48, setWireActive);
		wireButton.loadGraphic(AssetPaths.wire_icon__png);
		add(wireButton);
		cathodeButton = new FlxButton(offsetX + 32, 48, setCathodeActive);
		cathodeButton.loadGraphic(AssetPaths.cathode__png);
		add(cathodeButton);
		screenButton = new FlxButton(offsetX + 64, 48, setScreenActive);
		screenButton.loadGraphic(AssetPaths.screen__png);
		add(screenButton);
		anodeButton = new FlxButton(offsetX + 96, 48, setAnodeActive);
		anodeButton.loadGraphic(AssetPaths.anode__png);
		add(anodeButton);
		voltageButton = new FlxButton(offsetX, 80, setVoltageActive);
		voltageButton.loadGraphic(AssetPaths.voltage__png);
		add(voltageButton);
		groundButton = new FlxButton(offsetX + 32, 80, setGroundActive);
		groundButton.loadGraphic(AssetPaths.ground__png);
		add(groundButton);
		inputButton = new FlxButton(offsetX + 64, 80, setInputActive);
		inputButton.loadGraphic(AssetPaths.input_button__png);
		add(inputButton);
		outputButton = new FlxButton(offsetX + 96, 80, setOutputActive);
		outputButton.loadGraphic(AssetPaths.output_button__png);
		add(outputButton);
	}
	
	private function setWireActive() {
		activeTool = 0;
	}
	
	private function setCathodeActive() {
		activeTool = 1;
	}
	
	private function setScreenActive() {
		activeTool = 2;
	}
	
	private function setAnodeActive() {
		activeTool = 3;
	}
	
	private function setVoltageActive() {
		activeTool = 4;
	}
	
	private function setGroundActive() {
		activeTool = 5;
	}
	
	private function setInputActive() {
		activeTool = 6;
	}
	
	private function setOutputActive() {
		activeTool = 7;
	}
	
}