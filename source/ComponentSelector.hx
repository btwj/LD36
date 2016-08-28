package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUITooltipManager;
import flixel.FlxG;
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
	private var junctionButton:FlxButton;
	private var ghostCursor:FlxSprite;
	private var buttons:Array<FlxButton>;
	
	private var componentName:FlxText;
	private var componentDescription:FlxText;
	
	private var offsetX:Int = 0;
	private var offsetY:Int = 0;
	
	public var activeTool:Int = 0;
	public function revealTools(levelNo:Int) {
		if (true) {
			wireButton.revive();
			inputButton.revive();
			outputButton.revive();
		}
		
		if (levelNo >= 3) {
			cathodeButton.revive();
			screenButton.revive();
			anodeButton.revive();
			voltageButton.revive();
			groundButton.revive();
		}
		
		if (levelNo >= 9) {
			junctionButton.revive();
		}
	}

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
		ghostCursor = new FlxSprite();
		ghostCursor.alpha = 0.5;
		ghostCursor.makeGraphic(16, 16, 0);
		add(ghostCursor);
		
		wireButton = new FlxButton(offsetX, 32, setWireActive);
		wireButton.loadGraphic(AssetPaths.wire_button__png);
		add(wireButton);
		cathodeButton = new FlxButton(offsetX + 32, 32, setCathodeActive);
		cathodeButton.loadGraphic(AssetPaths.cathode_button__png);
		add(cathodeButton);
		screenButton = new FlxButton(offsetX + 64, 32, setScreenActive);
		screenButton.loadGraphic(AssetPaths.screen_button__png);
		add(screenButton);
		anodeButton = new FlxButton(offsetX + 96, 32, setAnodeActive);
		anodeButton.loadGraphic(AssetPaths.anode_button__png);
		add(anodeButton);
		voltageButton = new FlxButton(offsetX, 64, setVoltageActive);
		voltageButton.loadGraphic(AssetPaths.voltage_button__png);
		add(voltageButton);
		groundButton = new FlxButton(offsetX + 32, 64, setGroundActive);
		groundButton.loadGraphic(AssetPaths.ground_button__png);
		add(groundButton);
		inputButton = new FlxButton(offsetX + 64, 64, setInputActive);
		inputButton.loadGraphic(AssetPaths.in_button__png);
		add(inputButton);
		outputButton = new FlxButton(offsetX + 96, 64, setOutputActive);
		outputButton.loadGraphic(AssetPaths.out_button__png);
		add(outputButton);
		junctionButton = new FlxButton(offsetX, 96, setJunctionActive);
		junctionButton.loadGraphic(AssetPaths.junction_button__png);
		add(junctionButton);
		
		buttons = [wireButton, cathodeButton, screenButton, anodeButton, voltageButton, groundButton, inputButton, outputButton, junctionButton];
		for (button in buttons) button.kill();
		
		componentName = new FlxText(offsetX, 128, 0, "");
		componentName.setFormat(AssetPaths.PixelOperator__ttf, 16, 0xff292929);
		add(componentName);
		
		componentDescription = new FlxText(offsetX, 148, 120, "", 16);
		componentDescription.setFormat(AssetPaths.PixelOperator__ttf, 16, 0xff292929);
		add(componentDescription);
		
		setWireActive();
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.justPressed.W) setWireActive();
		if (FlxG.keys.justPressed.C) setCathodeActive();
		if (FlxG.keys.justPressed.S) setScreenActive();
		if (FlxG.keys.justPressed.A) setAnodeActive();
		if (FlxG.keys.justPressed.V) setVoltageActive();
		if (FlxG.keys.justPressed.G) setGroundActive();
		if (FlxG.keys.justPressed.I) setInputActive();
		if (FlxG.keys.justPressed.O) setOutputActive();
		if (FlxG.keys.justPressed.J) setJunctionActive();
		
		ghostCursor.x = FlxG.mouse.x + 30;
		ghostCursor.y = FlxG.mouse.y + 10;
	}
	
	private function setWireActive() {
		activeTool = 0;
		ghostCursor.makeGraphic(16, 16, 0x00000000, false);
		componentName.text = "Wire";
		componentDescription.text = "Wire is used to connect components together.";
	}
	
	private function setCathodeActive() {
		activeTool = 1;
		ghostCursor.loadGraphic(AssetPaths.cathode__png, false, 16, 16, true);
		componentName.text = "Cathode";
		componentDescription.text = "The cathode provides the voltage (grounded or positive) the anode adopts if all control grids in between are activated.";
	}
	
	private function setScreenActive() {
		activeTool = 2;
		ghostCursor.loadGraphic(AssetPaths.screen__png, false, 16, 16, true);
		componentName.text = "Screen";
		componentDescription.text = "Can be activated by a wire. Connects anode and cathode.";
	}
	
	private function setAnodeActive() {
		activeTool = 3;
		ghostCursor.loadGraphic(AssetPaths.anode__png, false, 16, 16, true);
		componentName.text = "Anode";
		componentDescription.text = "Adopts voltage of cathode if all control grids are activated.";
	}
	
	private function setVoltageActive() {
		activeTool = 4;
		ghostCursor.loadGraphic(AssetPaths.voltage__png, false, 16, 16, true);
		componentName.text = "Voltage Source";
		componentDescription.text = "Source of positive potential.";
	}
	
	private function setGroundActive() {
		activeTool = 5;
		ghostCursor.loadGraphic(AssetPaths.ground__png, false, 16, 16, true);
		componentName.text = "Ground";
		componentDescription.text = "Connects to ground.";
	}
	
	private function setInputActive() {
		activeTool = 6;
		ghostCursor.loadGraphic(AssetPaths.input__png, false, 16, 16, true);
		componentName.text = "Input";
		componentDescription.text = "Changes potential when tests are run. Change number by clicking again with this tool selected.";
	}
	
	private function setOutputActive() {
		activeTool = 7;
		ghostCursor.loadGraphic(AssetPaths.output__png, false, 16, 16, true);
		componentName.text = "Output";
		componentDescription.text = "Set to the output potential to pass tests. Change number by clicking again with this tool selected.";
	}
	
	private function setJunctionActive() {
		activeTool = 8;
		ghostCursor.loadGraphic(AssetPaths.junction__png, false, 16, 16, true);
		componentName.text = "Junction";
		componentDescription.text = "Connects to other junctions with the same number. Change number by clicking again with this tool selected.";
	}
	
}