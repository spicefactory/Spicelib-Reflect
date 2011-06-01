package {
import org.spicefactory.lib.reflect.MetadataTest;
import org.spicefactory.lib.reflect.DeclaredByTest;
import org.spicefactory.lib.reflect.PropertyTest;
import org.spicefactory.lib.reflect.MethodTest;
import org.spicefactory.lib.reflect.ConstructorTest;
import org.spicefactory.lib.reflect.ClassInfoTest;
import org.spicefactory.lib.reflect.ConverterTest;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class ReflectionSuite {

	public var converters:ConverterTest;
	public var classInfo:ClassInfoTest;
	public var constructors:ConstructorTest;
	public var methods:MethodTest;
	public var properties:PropertyTest;
	public var declaredBy:DeclaredByTest;
	public var metadata:MetadataTest;
	
}
}
