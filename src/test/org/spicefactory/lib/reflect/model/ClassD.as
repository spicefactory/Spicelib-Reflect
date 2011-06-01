package org.spicefactory.lib.reflect.model {

/**
 * @author Jens Halm
 */
public class ClassD {
	
	
	public function withVarArgs (param:String, ...rest) : int {
		return rest.length;
	}
	
	public function withUntypedParam (foo:*) : * {
		return foo;
	}
	
	
}
}
