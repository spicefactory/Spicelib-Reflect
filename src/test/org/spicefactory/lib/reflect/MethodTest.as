package org.spicefactory.lib.reflect {

import org.spicefactory.lib.reflect.model.InterfaceA;
import org.hamcrest.collection.arrayWithSize;
import org.hamcrest.object.equalTo;
import org.flexunit.assertThat;
import org.spicefactory.lib.reflect.model.ClassB;
import org.spicefactory.lib.reflect.model.ClassD;

public class MethodTest {
	
	
	private var classBInfo:ClassInfo;
	
	
	[Before]
	public function setUp () : void {
		classBInfo = ClassInfo.forClass(ClassB);
	}
	
	
	[Test]
	public function methodWithOptionalParam () : void {
		var m:Method = classBInfo.getMethod("methodWithOptionalParam");
		var target:ClassB = new ClassB("foo");
		var returnValue:* = m.invoke(target, ["bar", 27]);
		assertThat(returnValue, equalTo(true));
	}
	
	[Test]
	public function methodWithoutOptionalParam () : void {
		var m:Method = classBInfo.getMethod("methodWithOptionalParam");
		var target:ClassB = new ClassB("foo");
		var returnValue:* = m.invoke(target, ["bar"]);
		assertThat(returnValue, equalTo(false));
	}
	
	[Test]
	public function methodWithVarArgs () : void {
		var ci:ClassInfo = ClassInfo.forClass(ClassD);
		var m:Method = ci.getMethod("withVarArgs");
		assertThat(m.parameters, arrayWithSize(1));
		var returnValue:int = m.invoke(new ClassD(), ["foo", 0, 0, 0]);
		assertThat(returnValue, equalTo(3));
	}
	
	[Test]
	public function methodWithUntypedParam () : void {
		var ci:ClassInfo = ClassInfo.forClass(ClassD);
		var m:Method = ci.getMethod("withUntypedParam");
		var returnValue:* = m.invoke(new ClassD(), ["foo"]);
		assertThat(returnValue, equalTo("foo"));
	}
	
	[Test]
	public function staticMethodInvocation () : void {
		var m:Method = classBInfo.getStaticMethod("staticMethod");
		m.invoke(null, [false]);
		assertThat(ClassB.getStaticMethodCounter(), equalTo(1));
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.MethodInvocationError")]
	public function illegalParameterCount () : void {
		var m:Method = classBInfo.getMethod("methodWithOptionalParam");
		var target:ClassB = new ClassB("foo");
		m.invoke(target, ["bar", 15, 15]);
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.ConversionError")]
	public function illegalParameterType () : void {
		var m:Method = classBInfo.getMethod("methodWithOptionalParam");
		var target:ClassB = new ClassB("foo");
		m.invoke(target, ["bar", "illegal"]);
	}
	
	[Test]
	public function interfaceMethod () : void {
		var ci:ClassInfo = ClassInfo.forClass(InterfaceA);
		var m:Method = ci.getMethod("foo");
		var result:* = m.invoke(new InterfaceAImpl(), []);
		assertThat(result, equalTo("bar"));
	}
	
	[Test]
	public function namespaceMethod () : void {
		var m:Method = classBInfo.getMethod("nsMethod", "http://www.spicefactory.org/spicelib/test");
		var target:ClassB = new ClassB("foo");
		m.invoke(target, []);
		assertThat(target.stringVar, equalTo("nsMethodInvoked"));
	}
	
	
}

}

import org.spicefactory.lib.reflect.model.InterfaceA;

class InterfaceAImpl implements InterfaceA {

	public function foo () : String {
		return "bar";
	}
	
}