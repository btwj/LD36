package;

/**
 * ...
 * @author Bradley Teo
 */
class Level
{
	public var levelNo = 0;
	public var levelName = "";
	public var levelDescription = "";
	public var levelInputs = 0;
	public var levelOutputs = 0;
	public var levelTests:Array<Array<Array<Int>>>;

	public function new(_levelNo:Int, _levelName:String, _levelDescription:String, _levelTests:Array<Array<Array<Int>>>) 
	{
		levelNo = _levelNo;
		levelName = _levelName;
		levelDescription = _levelDescription;
		levelInputs = _levelTests[0][0].length;
		levelOutputs = _levelTests[0][1].length;
		levelTests = _levelTests;
	}
	
}