package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import WireGridElement;
import flixel.FlxG;
import flixel.math.FlxPoint;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Bradley Teo
 */
class WireGrid extends FlxSpriteGroup
{
	var sprBackground:FlxSprite;
	var gridElements:Array<Array<WireGridElement>>;
	var sprGridOverlay:FlxSprite;
	
	static var gridRows = 20;
	static var gridColumns = 30;
	static var gridElementSize = 16;
	static var padding = 16;
	static var gridHeight = gridRows * gridElementSize;
	static var gridWidth = gridColumns * gridElementSize;
	
	private var activeTilePos:Array<Int>;
	private var activeDir:Int = 0; /* 1 = ltr, 2 = utd */
	private var activeDestPos:Array<Int>;
	private var ps:PlayState;
	
	private var simulating:Bool = false;
	private var cycle:Int = 0;
	private var cycleTimer:Float = 0;
	private var cycleLength:Float = 0.0;
	private var paused:Bool = false;
	
	private var testing:Bool = false;
	public var testMessage:String = "";
	private var curTest:Array<Array<Int>>;
	private var curOutput:Array<Int>;
	private var curTestNo:Int = 0;
	private var inputPos:Array<Array<Int>>;
	private var outputPos:Array<Array<Int>>;
	public var testsPassed:Bool = false;

	public function new(_ps:PlayState) 
	{
		super();
		ps = _ps;
		sprBackground = new FlxSprite();
		var grpHeight = gridHeight + padding * 2;
		var grpWidth = gridWidth + padding * 2;
		sprBackground.height = grpHeight;
		sprBackground.width = grpWidth;
		sprBackground.makeGraphic(grpWidth, grpHeight, 0xff292929);
		var bgStroke = 3;
		sprBackground.drawRect(padding - bgStroke, padding - bgStroke, gridWidth + bgStroke * 2, gridHeight + bgStroke * 2, 0xff222222);
		
		//add(sprBackground);
		
		sprGridOverlay = new FlxSprite();
		sprGridOverlay.x = padding;
		sprGridOverlay.y = padding;
		sprGridOverlay.height = gridHeight;
		sprGridOverlay.width = gridWidth;
		sprGridOverlay.makeGraphic(gridWidth, gridHeight, 0x00ffffff);
		sprGridOverlay.alpha = 0.5;
		
		gridElements = new Array<Array<WireGridElement>>();
		gridElements = [for (i in 0...gridRows) [for (j in 0...gridColumns) null]];
		for (i in 0...gridRows) {
			for (j in 0...gridColumns) {
				var curElement = gridElements[i][j] = new WireGridElement(padding + j * gridElementSize, padding + i * gridElementSize, (i+j)%2);
				curElement.height = curElement.width = gridElementSize;
				add(curElement);
				curElement.setConnectionState(0);
			}
		}
		
		add(sprGridOverlay);
	}
	
	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.RIGHT) {
			simulating = !simulating;
			for (i in 0...gridRows) {
				for (j in 0...gridColumns) {
					gridElements[i][j].deactivate();
					gridElements[i][j].activationLevel = 0;
				}
			}
		}
		var mx = FlxG.mouse.x;
		var my = FlxG.mouse.y;
		
		if (!simulating && mx > padding && mx < gridWidth + padding && my > padding && my < gridHeight + padding) {
			var mpos = mouseToTile(mx, my);
			var curRow = mpos[1];
			var curCol = mpos[0];
			var gridEl = gridElements[curRow][curCol];
			if (FlxG.mouse.pressedRight) {
				if (curRow >= 0 && curRow < gridRows && curCol >= 0 && curCol < gridColumns) {
					gridEl.setType(0);
					gridEl.setConnectionState(0);
				}
			}
			if (ps.componentSelector.activeTool == 0) {
				if (FlxG.mouse.justPressed) {
					activeTilePos = mpos;
					activeDir = 0;
				}
				
				var aRow:Int = 0, aCol:Int = 0;
				if (activeTilePos != null) {
					aRow = activeTilePos[1]; aCol = activeTilePos[0];
				}
				
				if (FlxG.mouse.pressed && activeTilePos != null) {
					if ((aCol != curCol || aRow != curRow) && activeDir == 0) {
						if (aRow != curRow) {
							activeDir = 2;
						} else {
							activeDir = 1;
						}
						sprGridOverlay.fill(0x00ffffff);
					}
					sprGridOverlay.fill(0x00ffffff);
					if (activeDir == 1) {
						if (aCol < curCol) {
							sprGridOverlay.drawRect(aCol * gridElementSize, aRow * gridElementSize, (curCol - aCol + 1) * gridElementSize, gridElementSize, 0xffffffff);
						} else {
							sprGridOverlay.drawRect(curCol * gridElementSize, aRow * gridElementSize, (aCol - curCol + 1) * gridElementSize, gridElementSize, 0xffffffff);
						}
					}
					if (activeDir == 2) {
						if (aRow < curRow) {
							sprGridOverlay.drawRect(aCol * gridElementSize, aRow * gridElementSize, gridElementSize, (curRow - aRow + 1) * gridElementSize, 0xffffffff);
						} else {
							sprGridOverlay.drawRect(aCol * gridElementSize, curRow * gridElementSize, gridElementSize, (aRow - curRow + 1) * gridElementSize, 0xffffffff);
						}
					}
					
				}
				
				if (FlxG.mouse.justReleased) {
					if (activeDir == 1) {
						var sCol:Int, eCol:Int;
						if (aCol <= curCol) {
							sCol = aCol; eCol = curCol;
						} else {
							sCol = curCol; eCol = aCol;
						}
						gridElements[aRow][sCol].addConnectionState(2);
						if (sCol == 0) gridElements[aRow][0].addConnectionState(8);
						for (i in sCol+1...eCol) {
							if (i < gridColumns) {
								gridElements[aRow][i].addConnectionState(2);
								gridElements[aRow][i].addConnectionState(8);
							}
						}
						if (eCol < gridColumns) gridElements[aRow][eCol].addConnectionState(8);
						if (eCol == gridColumns - 1) gridElements[aRow][eCol].addConnectionState(2);
					} else if (activeDir == 2) {
						var sRow:Int, eRow:Int;
						if (aRow <= curRow) {
							sRow = aRow; eRow = curRow;
						} else {
							sRow = curRow; eRow = aRow;
						}
						gridElements[sRow][aCol].addConnectionState(4);
						if (sRow == 0) gridElements[0][aCol].addConnectionState(1);
						for (i in sRow+1...eRow) {
							if (i < gridRows) {
								gridElements[i][aCol].addConnectionState(1);
								gridElements[i][aCol].addConnectionState(4);
							}
						}
						if (eRow < gridRows) gridElements[eRow][aCol].addConnectionState(1);
						if (eRow == gridRows-1) gridElements[eRow][aCol].addConnectionState(4);
					}
					activeTilePos = null;
					activeDir = 0;
					sprGridOverlay.fill(0x00ffffff);
				}
				
				if (!FlxG.mouse.pressed) {
				}
				
				
			} else {
				if (FlxG.mouse.justPressed) {
					if (ps.componentSelector.activeTool == 1) {
						gridEl.setType(1);
					} else if (ps.componentSelector.activeTool == 2) {
						gridEl.setType(2);
					} else if (ps.componentSelector.activeTool == 3) {
						gridEl.setType(3);
					} else if (ps.componentSelector.activeTool == 4) {
						gridEl.setType(4);
					} else if (ps.componentSelector.activeTool == 5) {
						gridEl.setType(5);
					} else if (ps.componentSelector.activeTool == 6) {
						if (gridEl.elementType != 6) {
							gridEl.inputNum = 1;
							gridEl.setType(6);
						} else {
							gridEl.inputNum++;
							gridEl.inputNum = (gridEl.inputNum - 1) % ps.curLevel.levelInputs + 1;
							gridEl.redraw();
						}
					} else if (ps.componentSelector.activeTool == 7) {
						if (gridEl.elementType != 7) {
							gridEl.outputNum = 1;
							gridEl.setType(7);
						} else {
							gridEl.outputNum++;
							gridEl.outputNum = (gridEl.outputNum - 1) % ps.curLevel.levelOutputs + 1;
							gridEl.redraw();
						}
					}
				}
				
			}
			
		}
		
		if (simulating) {
			
			if (!paused) {
				cycleTimer += elapsed;
				if (cycleTimer > cycleLength) {
					cycleTimer = 0;
					cycle++;
					
					var voltageSources = new Array<Array<Int>>();
					var groundSources = new Array<Array<Int>>();
					
					for (i in 0...gridRows) {
						for (j in 0...gridColumns) {
							if (gridElements[i][j].elementType == 4) voltageSources.push([i, j]);
							if (gridElements[i][j].elementType == 5) groundSources.push([i, j]);
						}
					}
					
					var dirs = [[ -1, 0], [1, 0], [0, 1], [0, -1]];
					
					var toVisit = new Array<Array<Int>>();
					var visited = [for (i in 0...gridRows) [for (j in 0...gridColumns) false]];
					for (voltageSource in voltageSources) toVisit.push(voltageSource);
					if (testing) {
						for (i in 0...ps.curLevel.levelInputs) {
							if (curTest[0][i] == 1) toVisit.push(inputPos[i]);
						}
					}
					while (toVisit.length > 0) {
						var cr = toVisit[0][0];
						var cc = toVisit[0][1];
						toVisit.shift();
						if (visited[cr][cc]) continue;
						visited[cr][cc] = true;
						var gridEl = gridElements[cr][cc];
						var gridElType = gridEl.elementType;
						var cs = gridEl.connectionState;
						if (gridElType == 0) {
							gridElements[cr][cc].activate();
						}
						if (gridElType == 2) {
							if (gridEl.activationLevel <= 5) gridElements[cr][cc].activationLevel++;
							if (gridElements[cr][cc].activationLevel > 5) gridElements[cr][cc].activate();
						}
						if (gridElType == 7) {
							if (gridEl.outputNum-1 < ps.curLevel.levelOutputs) curOutput[gridEl.outputNum-1] = 1;
						}
						for (i in 0...4) {
							var nr = cr + dirs[i][0];
							var nc = cc + dirs[i][1];
							if (!isValidTile(nr, nc)) continue;
							var nt = gridElements[nr][nc];
							if (gridElType == 0) {
								if ((i == 0 && cs & 1 == 0) || (i == 1 && cs & 4 == 0) || (i == 2 && cs & 2 == 0) || (i == 3 && cs & 8 == 0)) {
									continue;
								}
								if (nt.elementType == 0 && isValidWire(i, nt.connectionState)) {
									toVisit.push([nr, nc]);
								} else if (nt.elementType == 1) {
								} else if (nt.elementType == 2) {
									toVisit.push([nr, nc]);
								} else if (nt.elementType == 3) {
									toVisit.push([nr, nc]);
								} else if (nt.elementType == 7) {
									toVisit.push([nr, nc]);
								}
							} else if (gridElType == 1) {
							} else if (gridElType == 2) {
								if (isValidWire(i, nt.connectionState)) toVisit.push([nr, nc]);
							} else if (gridElType == 3) {
								if (isValidWire(i, nt.connectionState)) toVisit.push([nr, nc]);
							} else if (gridElType == 4) {
								if (isValidWire(i, nt.connectionState)) toVisit.push([nr, nc]);
							} else if (gridElType == 5) {
								
							} else if (gridElType == 6) {
								if (isValidWire(i, nt.connectionState)) toVisit.push([nr, nc]);
							}
						}	
					}
					
					var visited = [for (i in 0...gridRows) [for (j in 0...gridColumns) false]];
					for (groundSource in groundSources) toVisit.push(groundSource);
					while (toVisit.length > 0) {
						var cr = toVisit[0][0];
						var cc = toVisit[0][1];
						toVisit.shift();
						if (visited[cr][cc]) continue;
						visited[cr][cc] = true;
						var gridEl = gridElements[cr][cc];
						var gridElType = gridEl.elementType;
						var cs = gridEl.connectionState;
						if (gridElType == 0) {
							gridElements[cr][cc].deactivate();
						}
						if (gridElType == 7) {
							if (gridEl.outputNum-1 < ps.curLevel.levelOutputs) curOutput[gridEl.outputNum-1] = 0;
						}
						for (i in 0...4) {
							var nr = cr + dirs[i][0];
							var nc = cc + dirs[i][1];
							if (!isValidTile(nr, nc)) continue;
							var nt = gridElements[nr][nc];
							if (gridElType == 0) {
								if ((i == 0 && cs & 1 == 0) || (i == 1 && cs & 4 == 0) || (i == 2 && cs & 2 == 0) || (i == 3 && cs & 8 == 0)) {
									continue;
								}
								if (nt.elementType == 0 && isValidWire(i, nt.connectionState)) {
									toVisit.push([nr, nc]);
								} else if (nt.elementType == 1) {
									toVisit.push([nr, nc]);
								} else if (nt.elementType == 2) {
									nt.deactivate();
									nt.activationLevel = 0;
								} else if (nt.elementType == 3) {
									toVisit.push([nr, nc]);
								} else if (nt.elementType == 7) {
									toVisit.push([nr, nc]);
								}
							} else if (gridElType == 1) {
								if (nt.elementType == 2 && nt.activated) toVisit.push([nr, nc]);
								if (isValidWire(i, nt.connectionState)) toVisit.push([nr, nc]);
							} else if (gridElType == 2) {
								if (nt.elementType == 2 && nt.activated) {
									toVisit.push([nr, nc]);
								}
								if (nt.elementType == 3) {
									toVisit.push([nr, nc]);
								}
							} else if (gridElType == 3) {
								if (isValidWire(i, nt.connectionState)) toVisit.push([nr, nc]);
							} else if (gridElType == 4) {

							} else if (gridElType == 5) {
								if (isValidWire(i, nt.connectionState)) toVisit.push([nr, nc]);
							} else if (gridElType == 6) {
								if (isValidWire(i, nt.connectionState)) toVisit.push([nr, nc]);
							}
						}	
					}
				}
			}
		}
		
		if (testing) {
			
			if (cycle > 30) {
				for (i in 0...ps.curLevel.levelOutputs) {
					if (curOutput[i] != curTest[1][i]) {
						testMessage = "Test #" + (curTestNo + 1) + " failed. Input: " + Std.string(curTest[0]) + "; Expected Output: " + Std.string(curTest[1]) + "; Got: " + Std.string(curOutput);
						stopTests();
					}
				}
				curTestNo++;
				if (curTestNo == ps.curLevel.levelTests.length) {
					testsPassed = true;
					stopTests();
				}
				
				resetSimulation();
				curTest = ps.curLevel.levelTests[curTestNo];
				
			}
		}
	}
	
	private function isValidTile(row:Int, col:Int):Bool {
		return (row >= 0 && row < gridRows && col >= 0 && col < gridColumns);
	}
	
	private function mouseToTile(mx:Float, my:Float):Array<Int> {
		var tileColumn:Int = Std.int((mx - padding) / gridElementSize);
		var tileRow:Int = Std.int((my - padding) / gridElementSize);
		return [tileColumn, tileRow];
	}
	
	private function isValidWire(i:Int, connectionState:Int) {
		return (i == 0 && connectionState & 4 == 4) ||
		(i == 1 && connectionState & 1 == 1) ||
		(i == 2 && connectionState & 8 == 8) ||
		(i == 3 && connectionState & 2 == 2);
	}
	
	private function resetSimulation() {
		for (i in 0...gridRows) {
			for (j in 0...gridColumns) {
				gridElements[i][j].deactivate();
				gridElements[i][j].activationLevel = 0;
			}
		}
		curOutput = null;
		curOutput = [for (i in 0...ps.curLevel.levelOutputs) 0];
		trace(curOutput);
		cycle = 0;
		cycleTimer = 0;
	}
	
	private function getInputs():Array<Array<Int>> {
		var positions = [for (i in 0...ps.curLevel.levelInputs) [ -1, -1]];
		for (i in 0...gridRows) {
			for (j in 0...gridColumns) {
				var gridEl = gridElements[i][j];
				if (gridEl.elementType == 6) {
					if (gridEl.inputNum - 1 < ps.curLevel.levelInputs) {
						positions[gridEl.inputNum-1][0] = i;
						positions[gridEl.inputNum-1][1] = j;
					}
				}
			}
		}
		return positions;
	}
	
	private function getOutputs():Array<Array<Int>> {
		var positions = [for (i in 0...ps.curLevel.levelOutputs) [ -1, -1]];
		for (i in 0...gridRows) {
			for (j in 0...gridColumns) {
				var gridEl = gridElements[i][j];
				if (gridEl.elementType == 7) {
					if (gridEl.outputNum - 1 < ps.curLevel.levelOutputs) {
						positions[gridEl.outputNum-1][0] = i;
						positions[gridEl.outputNum - 1][1] = j;
					}
				}
			}
		}
		return positions;
	}
	
	public function runTests() {
		inputPos = getInputs();
		testsPassed = false;
		for (i in inputPos) if (i[0] == -1) {
			testMessage = "Not all inputs are present.";
			stopTests();
			return;
		}
		
		outputPos = getOutputs();
		for (i in outputPos) if (i[0] == -1) {
			testMessage = "Not all outputs are present.";
			stopTests();
			return;
		}
		
		curTestNo = 0;
		curTest = ps.curLevel.levelTests[0];
		resetSimulation();
		testing = true;
		simulating = true;
	}
	
	private function stopTests() {
		testing = false;
		simulating = false;
		ps.desk.showResult();
	}
}