package avmplus {

[ExcludeClass]
/**
 * @private 
 * 
 * @author Jens Halm
 */
public class DescribeTypeJSONAccessor {
	
	
	public static function get instanceFlags () : int { 
		return INCLUDE_BASES 
			| INCLUDE_INTERFACES 
			| INCLUDE_VARIABLES 
			| INCLUDE_ACCESSORS 
			| INCLUDE_METHODS 
			| INCLUDE_METADATA 
			| INCLUDE_CONSTRUCTOR 
			| INCLUDE_TRAITS 
			| HIDE_OBJECT
			| USE_ITRAITS;
	}
   			
   	public static function get staticFlags () : int { 
		return INCLUDE_INTERFACES 
			| INCLUDE_VARIABLES 
			| INCLUDE_ACCESSORS 
			| INCLUDE_METHODS 
			| INCLUDE_METADATA 
			| HIDE_OBJECT
			| INCLUDE_TRAITS; 
   	}
	
	public static function get functionRef () : Function {
		try {
			return describeTypeJSON;
		}
		catch (e:Error) {
		}
		return null;
	}
	
	
}
}
