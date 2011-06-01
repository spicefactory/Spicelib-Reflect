package org.spicefactory.lib.reflect {
	
import flexunit.framework.TestCase;
import flexunit.framework.TestSuite;
	
public class ReflectionTestBase extends TestCase {
		
	public static function suite () : TestSuite {
        var suite:TestSuite = new TestSuite();
        suite.addTestSuite(ConverterTest);
        suite.addTestSuite(ClassInfoTest);
        suite.addTestSuite(MethodTest);
        suite.addTestSuite(ConstructorTest);
        suite.addTestSuite(PropertyTest);
        suite.addTestSuite(DeclaredByTest);
        suite.addTestSuite(MetadataTest);
        return suite;
    }
		
		
}

}