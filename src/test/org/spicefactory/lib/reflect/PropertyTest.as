package org.spicefactory.lib.reflect {
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.spicefactory.lib.reflect.model.ClassB;

public class PropertyTest {


	private var classBInfo:ClassInfo;
	private var classBInstance:ClassB;
	
	
	[Before]
	public function setUp () : void {
		classBInfo = ClassInfo.forClass(ClassB);
		classBInstance = new ClassB("foo");
	}

	
	[Test]
	public function readBooleanProperty () : void {
		var p:Property = classBInfo.getProperty("booleanVar");
		assertThat(p.getValue(classBInstance), equalTo(false));
	}
	
	[Test]
	public function readStringProperty () : void {
		var p:Property = classBInfo.getProperty("readOnlyProperty");
		assertThat(p.getValue(classBInstance), equalTo("foo"));
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.PropertyError")]
	public function writeReadOnlyProperty () : void {
		var p:Property = classBInfo.getProperty("readOnlyProperty");
		p.setValue(classBInstance, "someValue");
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.ConversionError")]
	public function writeIllegalPropertyType () : void {
		var p:Property = classBInfo.getProperty("booleanProperty");
		p.setValue(classBInstance, new Date());
	}
	
	[Test]
	public function namespaceMethod () : void {
		var p:Property = classBInfo.getProperty("nsProperty", "http://www.spicefactory.org/spicelib/test");
		var target:ClassB = new ClassB("foo");
		assertThat(p.getValue(target), equalTo(7));
	}
	

}

}