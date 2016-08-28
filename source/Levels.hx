package;

/**
 * ...
 * @author Bradley Teo
 */
class Levels
{
	public static var levels:Array<Level> = [
	/* Intro Levels*/
		new Level("Relay", "Connect an input to an output with a wire.", [[[0], [0]], [[1],[1]]]),
		new Level("OR Gate", "Build a simple gate that takes in two inputs, and outputs a positive voltage if any of the inputs have a positive voltage. You only need wires for this.", [[[1, 1], [1]], [[0, 1], [1]], [[1, 0], [1]], [[0, 0], [0]]]),
		new Level("Signal Splitter", "Build something that takes in an input and puts out that input twice.", [[[0], [0, 0]], [[1], [1, 1]]]),
	/* Medium Levels */
		new Level("Inverter", "Build a NOT gate that when no input is given outputs a positive voltage, and vice versa.", [[[0], [1]], [[1], [0]]]),
		new Level("AND Gate", "Build an AND gate that only outputs a positive voltage when both inputs are 1.", [[[1, 1], [1]], [[1, 0], [0]], [[0, 1], [0]], [[0, 0], [0]]]),
		new Level("NAND Gate", "Build a NAND gate that always outputs a positive voltage unless both inputs are on. You'll need to use the vacuum tube features for this.", [[[1, 1], [0]], [[1, 0], [1]], [[0, 1], [1]], [[0, 0], [1]]]),
		new Level("NOR Gate", "Build a NOR gate that only outputs a positive voltage when both inputs are 0.", [[[0, 0], [1]], [[1, 0], [0]], [[0, 1], [0]], [[1, 1], [0]]]),
		new Level("XOR Gate", "Build a XOR gate that only outputs a positive voltage when only one input is on.", [[[0, 0], [0]], [[1, 0], [1]], [[0, 1], [1]], [[1, 1], [0]]]),
		new Level("Half Adder", "Build a half adder that takes in two inputs, adds them in binary and returns the sum as outputs. Output 1 is the most significant bit.", [[[0, 0], [0, 0]], [[0, 1], [0, 1]], [[1, 0], [0, 1]], [[1, 1], [1, 0]]]),
	/* Junctions */
		new Level("Multiple Calculations", "Given two inputs, output the result of the operations AND, OR, XOR. Try using the junctions.", [[[0, 0], [0, 0, 0]], [[0, 1], [0, 1, 1]], [[1, 0], [0, 1, 1]], [[1, 1], [1, 1, 0]]]),
		new Level("Full Adder", "Build a 1-bit full adder, that takes in 3 inputs, and returns their sum (output 2) and carry bit (output 1).", [[[0, 0, 0], [0, 0]], [[0, 0, 1], [0, 1]], [[0, 1, 0], [0, 1]], [[0, 1, 1], [1, 0]], [[1, 0, 0], [0, 1]], [[1, 0, 1], [1, 0]], [[1, 1, 0], [1, 0]], [[1, 1, 1], [1, 1]]])
	];
	
}