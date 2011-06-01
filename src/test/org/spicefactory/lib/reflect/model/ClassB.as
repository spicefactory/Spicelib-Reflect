package org.spicefactory.lib.reflect.model {

import org.spicefactory.lib.reflect.ns.test_namespace;
	
public class ClassB extends ClassA {
	
	
	private var _booleanProperty:Boolean;
	
	test_namespace var nsVar:String;
	
	private static var staticCnt:int = 0;
	
	
	function ClassB (readOnlyProp:String) {
		super(readOnlyProp);
	}
	
	
	public function get booleanProperty () : Boolean {
		return _booleanProperty;
	}
	
	public function set booleanProperty (value:Boolean) : void {
		_booleanProperty = value;
	}
	
	
	public static function staticMethod (aParam:Boolean) : void {
		staticCnt++;
	}
	
	public static function getStaticMethodCounter () : int {
		return staticCnt;
	}

	
	public static function get staticReadOnlyProperty () : XML {
		return null;
	}
	
	test_namespace function nsMethod () : void {
		stringVar = "nsMethodInvoked";
	}
	
	test_namespace function get nsProperty () : Object {
		return 7;
	}
	
	public function methodWithPrivateClassReturnValue () : Foo {
		return null;
	}
	
	
}

}

class Foo {}
