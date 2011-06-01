package org.spicefactory.lib.reflect {
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.notNullValue;
import org.spicefactory.lib.reflect.model.ClassC;
import org.spicefactory.lib.reflect.model.TestMetadata1;
import org.spicefactory.lib.reflect.model.TestMetadata2;

public class ConstructorTest {
	
	
	private static var classCInfo:ClassInfo;
	
	
	[BeforeClass]
	public static function setUp () : void {
		new ClassC(""); // needed to avoid Flash Player bug that does report '*' as type for
		                // all constructor parameters if the class was not instantiated at least once.
		Metadata.registerMetadataClass(TestMetadata1);
		Metadata.registerMetadataClass(TestMetadata2);
		classCInfo = ClassInfo.forClass(ClassC);
	}
	
	
	[Test]
	public function constructorWithOptionalParam () : void {
		var c:Constructor = classCInfo.getConstructor();
		var i:ClassC = ClassC(c.newInstance(["bar", 27]));
		assertThat(i, notNullValue());
		assertThat(i.requiredProperty, equalTo("bar"));
		assertThat(i.optionalProperty, equalTo(27));
	}
	
	[Test]
	public function constructorWithoutOptionalParam () : void {
		var c:Constructor = classCInfo.getConstructor();
		var i:ClassC = ClassC(c.newInstance(["bar"]));
		assertThat(i, notNullValue());
		assertThat(i.requiredProperty, equalTo("bar"));
		assertThat(i.optionalProperty, equalTo(0));
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.MethodInvocationError")]
	public function illegalParameterCount () : void {
		classCInfo.getConstructor().newInstance(["bar", 15, 15]);
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.ConversionError")]
	public function illegalParameterType () : void {
		classCInfo.getConstructor().newInstance(["bar", "foo"]);
	}
	
	
}

}