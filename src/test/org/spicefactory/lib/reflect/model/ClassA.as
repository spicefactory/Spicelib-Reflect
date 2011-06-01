package org.spicefactory.lib.reflect.model {
	
public class ClassA {
	
	
	public static const classVar:Class = Date;
	
	public var stringVar:String;
	public var booleanVar:Boolean;
	public const uintVar:uint = 23;
	public var untyped; // This is untyped on purpose for Reflection UnitTests
	public var anything:*;
	
	private var _readOnly:String;
	private var _readWrite:String;
	
	
	function ClassA (readOnlyProp:String) {
		_readOnly = readOnlyProp;
	}
	
	
	public function get readOnlyProperty () : String {
		return _readOnly;
	}
	
	public function get readWriteProperty () : String {
		return _readWrite;
	}
	
	public function set readWriteProperty (value:String) : void {
		_readWrite = value;
	}
		
	
	public function methodNoParams () : void {
		
	}
	
	public function methodWithOptionalParam (aParam:String, anInt:uint = 5) : Boolean {
		return (anInt != 5);
	}
	
	
	
}

}