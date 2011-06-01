package org.spicefactory.lib.reflect.model {

/**
 * @author Jens Halm
 */
public class DeclaredBySub extends DeclaredBySuper {
	
	
	public override function get someProp () : String {
		return "";
	}
	
	public override function someMethod (value:Object) : Object {
		return value;
	}
	
	
}
}
