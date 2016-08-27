package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Bradley Teo
 */
class WireGridElement extends FlxSpriteGroup
{
	public var tileSprite:FlxSprite;
	public var connectionState:Int = 0;
	/* 0 = no connection, 1 = left to right, 2 = up to down, 3 = left right up & down */
	public var elementType:Int = 0;
	/* 0 = wire, 1 = cathode, 2 = screen, 3 = anode, 4 = voltage source, 5 = ground */
	/* 6 = input, 7 = output */
	public var activated:Bool = false;
	public var activationLevel:Int = 0;
	public var inputNum:Int = 0;
	public var outputNum:Int = 0;
	public var tileText:FlxText;
	public var parity:Int = 0;

	public function new(x:Int, y:Int, _parity:Int) 
	{
		super();
		
		parity = _parity;
		
		tileSprite = new FlxSprite(x, y);
		tileSprite.makeGraphic(16, 16, 0x00ffffff, true);
		tileSprite.drawRect(0, 0, 16, 16, 0xffaaaaaa);
		add(tileSprite);
		
		tileText = new FlxText(x, y+2, 16, "");
		tileText.setFormat(8, 0xff292929, FlxTextAlign.CENTER);
		add(tileText);
	}
	
	public function setConnectionState(_connectionState:Int) {
		if (elementType == 0) {
			connectionState = _connectionState;
		}
		redraw();
	}
	
	public function addConnectionState(_connectionState:Int) {
		if (elementType == 0) {
			connectionState = _connectionState | connectionState;
		}
		redraw();
	}
	
	public function redraw() {
		if (elementType == 0) {
			var wireColor:Int = 0xff333333;
			if (activated) wireColor = 0xffeeee00;
			if (parity == 0) tileSprite.drawRect(0, 0, 16, 16, 0xffaaaaaa);
			else tileSprite.drawRect(0, 0, 16, 16, 0xffbbbbbb);
			if (connectionState & 1 == 1) {
				tileSprite.drawRect(7, 0, 2, 9, wireColor);
			}
			if (connectionState & 2 == 2) {
				tileSprite.drawRect(7, 7, 9, 2, wireColor);
			}
			if (connectionState & 4 == 4) {
				tileSprite.drawRect(7, 7, 2, 9, wireColor);
			}
			if (connectionState & 8 == 8) {
				tileSprite.drawRect(0, 7, 9, 2, wireColor);
			}
		} else if (elementType == 3) {
			tileSprite.loadGraphic(AssetPaths.anode__png, false, 16, 16, true);
		} else if (elementType == 2) {
			if (!activated) tileSprite.loadGraphic(AssetPaths.screen__png, false, 16, 16, true);
			else tileSprite.loadGraphic(AssetPaths.screen_activated__png, false, 16, 16, true);
		} else if (elementType == 1) {
			tileSprite.loadGraphic(AssetPaths.cathode__png, false, 16, 16, true);
		} else if (elementType == 4) {
			tileSprite.loadGraphic(AssetPaths.voltage__png, false, 16, 16, true);
		} else if (elementType == 5) {
			tileSprite.loadGraphic(AssetPaths.ground__png, false, 16, 16, true);
		} else if (elementType == 6) {
			tileSprite.loadGraphic(AssetPaths.input__png, false, 16, 16, true);
			tileText.setFormat(8, 0xff292929, FlxTextAlign.CENTER);
			if (inputNum != 0) tileText.text = Std.string(inputNum);
			else tileText.text = "";
		} else if (elementType == 7) {
			tileSprite.loadGraphic(AssetPaths.output__png, false, 16, 16, true);
			tileText.setFormat(8, 0xffffffff, FlxTextAlign.CENTER);
			if (outputNum != 0) tileText.text = Std.string(outputNum);
			else tileText.text = "";
		}
	}
	
	public function setType(type:Int) {
		elementType = type;
		connectionState = 0;
		tileText.text = "";
		redraw();
	}
	
	public function activate() {
		activated = true;
		redraw();
	}
	
	public function deactivate() {
		activated = false;
		redraw();
	}
}