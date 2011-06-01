package org.spicefactory.lib.reflect.model {

/**
 * @author Jens Halm
 */
public class ClassE {
	
	
	[TestMetadata3(type="flash.display.Sprite", count="5")]
	public var valid:String;
	
	[TestMetadata3(type="flash.display.Sprite")]
	public var invalid1:String;
	
	[TestMetadata3(type="Array", count="5")]
	public var invalid2:String;
	
	[TestMetadata3(type="flash.display.Sprite", count="5")]
	[TestMetadata3(type="flash.display.Sprite", count="5")]
	public var invalid3:String;
	
	
}
}
