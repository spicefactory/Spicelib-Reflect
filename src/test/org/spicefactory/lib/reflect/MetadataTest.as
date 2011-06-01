package org.spicefactory.lib.reflect {
import org.flexunit.assertThat;
import org.hamcrest.collection.arrayWithSize;
import org.hamcrest.core.isA;
import org.hamcrest.object.equalTo;
import org.spicefactory.lib.reflect.metadata.EventInfo;
import org.spicefactory.lib.reflect.model.ClassC;
import org.spicefactory.lib.reflect.model.ClassE;
import org.spicefactory.lib.reflect.model.ClassF;
import org.spicefactory.lib.reflect.model.InterfaceB;
import org.spicefactory.lib.reflect.model.TestMetadata1;
import org.spicefactory.lib.reflect.model.TestMetadata2;
import org.spicefactory.lib.reflect.model.TestMetadata3;

import flash.display.Sprite;

public class MetadataTest {
	
	
	private static var classCInfo:ClassInfo;
	
	
	[BeforeClass]
	public static function setUp () : void {
		new ClassC(""); // needed to avoid Flash Player bug that does report '*' as type for
		                // all constructor parameters if the class was not instantiated at least once.
		Metadata.registerMetadataClass(TestMetadata1);
		Metadata.registerMetadataClass(TestMetadata2);
		Metadata.registerMetadataClass(TestMetadata3);
		classCInfo = ClassInfo.forClass(ClassC);
	}
	
	
	[Test]
	public function classMetadata () : void {
		var meta:Array = classCInfo.getMetadata(EventInfo);
		assertThat(meta, arrayWithSize(3));
		meta.sortOn("name");
		checkEventInfo(meta[0], "start", "flash.events.MouseEvent");
		checkEventInfo(meta[1], "start2", "");
		checkEventInfo(meta[2], "start3", "");
	}
	
	private function checkEventInfo (meta:*, expectedName:String, expectedType:String) : void {
		assertThat(meta, isA(EventInfo));
		var ei:EventInfo = EventInfo(meta);
		assertThat(ei.name, equalTo(expectedName));
		assertThat(ei.type, equalTo(expectedType));
	}
	
	[Test]
	public function eventWithUnknownAttribute () : void {
		var ci:ClassInfo = ClassInfo.forClass(ClassF);
		var meta:Array = ci.getMetadata(EventInfo);
		assertThat(meta, arrayWithSize(1));
		checkEventInfo(meta[0], "someName", "");
	}
	
	[Test]
	public function varMetadata () : void {
		var p:Property = classCInfo.getProperty("optionalProperty");
		var meta:Array = p.getMetadata("TestMetadata");
		assertThat(meta, arrayWithSize(1));
		assertThat(meta[0], isA(Metadata));
	}
	
	[Test]
	public function constMetadata () : void {
		var p:Property = classCInfo.getProperty("aConst");
		var meta:Array = p.getMetadata("TestMetadata");
		assertThat(meta, arrayWithSize(1));
		assertThat(meta[0], isA(Metadata));
	}
	
	[Test]
	public function mappedPropertyMetadata () : void {
		var p:Property = classCInfo.getProperty("requiredProperty");
		var meta:Array = p.getMetadata(TestMetadata1);
		assertThat(meta, arrayWithSize(1));
		assertThat(meta[0], isA(TestMetadata1));
		var mapped:TestMetadata1 = TestMetadata1(meta[0]);
		assertThat(mapped.stringProp, equalTo("A"));
		assertThat(mapped.intProp, equalTo(5));
	}
	
	[Test]
	public function mappedInterfaceMethodMetadata () : void {
		var interfaceInfo:ClassInfo = ClassInfo.forClass(InterfaceB);
		var m:Method = interfaceInfo.getMethod("method");
		var meta:Array = m.getMetadata(TestMetadata1);
		assertThat(meta, arrayWithSize(1));
		assertThat(meta[0], isA(TestMetadata1));
		var mapped:TestMetadata1 = TestMetadata1(meta[0]);
		assertThat(mapped.stringProp, equalTo("A"));
		assertThat(mapped.intProp, equalTo(1));
	}
	
	[Test]
	public function mappedInterfaceTypeMetadata () : void {
		var interfaceInfo:ClassInfo = ClassInfo.forClass(InterfaceB);
		var meta:Array = interfaceInfo.getMetadata(TestMetadata1);
		assertThat(meta, arrayWithSize(1));
		assertThat(meta[0], isA(TestMetadata1));
		var mapped:TestMetadata1 = TestMetadata1(meta[0]);
		assertThat(mapped.stringProp, equalTo("A"));
		assertThat(mapped.intProp, equalTo(1));
	}

	[Test]
	public function mappedDefaultProperty () : void {
		var p:Property = classCInfo.getProperty("testDefaultValue");
		var meta:Array = p.getMetadata(TestMetadata1);
		assertThat(meta, arrayWithSize(1));
		assertThat(meta[0], isA(TestMetadata1));
		var mapped:TestMetadata1 = TestMetadata1(meta[0]);
		assertThat(mapped.stringProp, equalTo("defaultValue"));
		assertThat(mapped.intProp, equalTo(0));
	}

	[Test]
	public function methodMetadata () : void {
		var method:Method = classCInfo.getMethod("methodWithMetadata");
		var meta:Array = method.getMetadata("TestMetadata");
		assertThat(meta, arrayWithSize(2));
		assertThat(meta[0], isA(Metadata));
		assertThat(meta[1], isA(Metadata));
		meta.sort(function (item1:Metadata, item2:Metadata) : int { 
			return (item1.getDefaultArgument() > item2.getDefaultArgument()) ? -1 : 1;
		});
		var m:Metadata = Metadata(meta[0]);
		assertThat(m.getArgument(""), equalTo("someValue"));
		assertThat(m.getDefaultArgument(), equalTo("someValue"));
		m = Metadata(meta[1]);
		assertThat(m.getArgument(""), equalTo("someOtherValue"));
		assertThat(m.getDefaultArgument(), equalTo("someOtherValue"));
	}
	
	[Test]
	public function duplicateMappedMetadata () : void {
		var method:Method = classCInfo.getMethod("methodWithMappedMetadata");
		var meta:Array = method.getMetadata(TestMetadata1);
		assertThat(meta, arrayWithSize(2));
		assertThat(meta[0], isA(TestMetadata1));
		assertThat(meta[1], isA(TestMetadata1));
		meta.sortOn("stringProp");
		var mapped:TestMetadata1 = TestMetadata1(meta[0]);
		assertThat(mapped.stringProp, equalTo("A"));
		assertThat(mapped.intProp, equalTo(1));
		mapped = TestMetadata1(meta[1]);
		assertThat(mapped.stringProp, equalTo("B"));
		assertThat(mapped.intProp, equalTo(2));
	}
	
	[Test]
	public function hasMetadataMethod () : void {
		var method:Method = classCInfo.getMethod("methodWithMappedMetadata");
		assertThat(method.hasMetadata(TestMetadata1), equalTo(true));
	}
	
	[Test]
	public function metadataWithRestrictedMetadata () : void {
		// Metadata only mapped for properties and methods
		var method:Method = classCInfo.getMethod("methodWithRestrictedMetadata");
		var meta:Array = method.getMetadata(TestMetadata2);
		assertThat(meta, arrayWithSize(1));
		assertThat(meta[0], isA(TestMetadata2));
		var mapped:TestMetadata2 = TestMetadata2(meta[0]);
		assertThat(mapped.arrayProp, isA(Array));
		var a:Array = mapped.arrayProp as Array;
		assertThat(a, arrayWithSize(2));
		assertThat(a[0], equalTo("a"));
		assertThat(a[1], equalTo("b"));
		
		meta = classCInfo.getMetadata(TestMetadata2);
		assertThat(meta, arrayWithSize(0));
		meta = classCInfo.getMetadata("TestMetadata2");
		assertThat(meta, arrayWithSize(1));
		assertThat(meta[0], isA(Metadata));
		var metadata:Metadata = Metadata(meta[0]);
		// Without mapping no Array conversion should occur
		assertThat(metadata.getDefaultArgument(), equalTo("a,b"));
	}
	
	[Test]
	public function assignableToAndRequired () : void {
		var meta:TestMetadata3 = getMetadata3Tag("valid");
		assertThat(meta.type, equalTo(Sprite));
		assertThat(meta.count, equalTo(5));
	}
	
	[Test(expects="org.spicefactory.lib.reflect.mapping.ValidationError")]
	public function missingRequiredValue () : void {
		getMetadata3Tag("invalid1");
	}
		
	[Test(expects="org.spicefactory.lib.reflect.mapping.ValidationError")]
	public function illegalClassValue () : void {
		getMetadata3Tag("invalid2");
	}
	
	[Test(expects="org.spicefactory.lib.reflect.mapping.ValidationError")]
	public function illegalMultipleOccurrences () : void {
		getMetadata3Tag("invalid3");
	}
	
	[Test]
	public function validationTurnedOff () : void {
		var meta:TestMetadata3 = getMetadata3Tag("invalid1", false);
		assertThat(meta.type, equalTo(Sprite));
		assertThat(meta.count, equalTo(0));
	}

	
	private function getMetadata3Tag (propName:String, validate:Boolean = true) : TestMetadata3 {
		var meta:Array = ClassInfo.forClass(ClassE).getProperty(propName).getMetadata(TestMetadata3, validate);
		assertThat(meta, arrayWithSize(1));
		return meta[0] as TestMetadata3;
	}
	
	
}

}