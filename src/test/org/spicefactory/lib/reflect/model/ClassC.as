package org.spicefactory.lib.reflect.model {
	
	
/**
 * Documentation.
 */
[Event(name="start", type="flash.events.MouseEvent")]

/**
 * Documentation.
 */
[Event(name="start2")]

/**
 * Documentation.
 */
[Event("start3")]


/**
 * Documentation.
 * 
 * @author Jens Halm
 */ 
[TestMetadata2("a,b")]
public class ClassC {
	
	
	private var _requiredProperty:String;
	
	[TestMetadata]
	public var optionalProperty:int;
	
	[TestMetadata]
	public const aConst:int = 5;
	
	[TestMetadata1("defaultValue")]
	public var testDefaultValue:Boolean;
	
	
	function ClassC (requiredParam:String, optionalParam:int = 0) {
		super();
		_requiredProperty = requiredParam;
		optionalProperty = optionalParam;
	}

	[TestMetadata1(stringProp="A", intProp=5)]
	public function get requiredProperty () : String {
		return _requiredProperty;
	}
	
	[TestMetadata(foo="bar")]
	public function set requiredProperty (value:String) : void {
		_requiredProperty = value;
	}
	
	[TestMetadata("someValue")]
	[TestMetadata("someOtherValue")]
	public function methodWithMetadata (aParam:Boolean) : void {
		
	}
	
	[TestMetadata1(stringProp="A", intProp=1)]
	[TestMetadata1(stringProp="B", intProp=2)]
	public function methodWithMappedMetadata (aParam:Boolean) : void {
		
	}
	
	[TestMetadata2("a,b")]
	public function methodWithRestrictedMetadata () : void {
		
	}
	
	
}

}