package;

/**
 * ...
 * @author Bradley Teo
 */
class Levels
{
	public static var levels:Array<Level> = [
		new Level(1, "Relay", "Connect an input to an output with a wire.", [[[0], [0]], [[1],[1]]]),
		new Level(2, "OR Gate", "Build a simple gate that takes in two inputs, and outputs a positive voltage if any of the inputs have a positive voltage. You only need wires for this.", [[[1, 1], [1]], [[0, 1], [1]], [[1, 0], [1]], [[0, 0], [0]]]),
		new Level(3, "Signal Splitter", "Build something that takes in an input and puts out that input twice.", [[[0], [0, 0]], [[1], [1, 1]]]),
		new Level(4, "NAND Gate", "Build a NAND gate that always outputs a positive voltage unless both inputs are on. You'll need to use the vacuum tube features for this.", [[[1, 1], [0]], [[1, 0], [1]], [[0, 1], [1]], [[0, 0], [1]]]),
		new Level(5, "Inverter", "Build a NOT gate that when no input is given outputs a positive voltage, and vice versa.", [[[0], [1]], [[1], [0]]]),
		new Level(6, "NOR Gate", "Build a NOR gate that only outputs a positive voltage when both inputs are 0.", [[[0, 0], [1]], [[1, 0], [0]], [[0, 1], [0]], [[1, 1], [0]]]),
		new Level(7, "AND Gate", "Build an AND gate that only outputs a positive voltage when both inputs are 1.", [[[1, 1], [1]], [[1, 0], [0]], [[0, 1], [0]], [[0, 0], [0]]])
	];
	
}