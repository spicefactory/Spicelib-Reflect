package org.spicefactory.lib.reflect {
import org.flexunit.assertThat;
import org.flexunit.asserts.fail;
import org.flexunit.async.Async;
import org.hamcrest.collection.arrayWithSize;
import org.hamcrest.core.isA;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.notNullValue;
import org.hamcrest.object.sameInstance;
import org.spicefactory.lib.reflect.model.ClassB;
import org.spicefactory.lib.reflect.model.InterfaceA;
import org.spicefactory.lib.reflect.model.InternalSubclass;
import org.spicefactory.lib.reflect.model.TestProxy;
import org.spicefactory.lib.reflect.types.Any;
import org.spicefactory.lib.reflect.types.Private;
import org.spicefactory.lib.reflect.types.Void;

import mx.collections.ArrayCollection;

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.utils.Proxy;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

public class ClassInfoTest {
	
	
	[Test]
	public function basicModel () : void {
		var ci:ClassInfo = ClassInfo.forClass(ClassB);
		trace(describeType(ClassB));
		// TODO - check inconsistencies with ::
		assertThat(ci.name, equalTo("org.spicefactory.lib.reflect.model::ClassB"));
		assertThat(ci.getClass(), sameInstance(ClassB));
		assertThat(ci.isInterface(), equalTo(false));
		assertThat(ci.getProperties(), arrayWithSize(10));
		assertThat(ci.getStaticProperties(), arrayWithSize(2));
		assertThat(ci.getMethods(), arrayWithSize(4));
		assertThat(ci.getStaticMethods(), arrayWithSize(2));
		var uri:String = "http://www.spicefactory.org/spicelib/test";
		checkProperty(ci, "stringVar", String, false, true, true);
		checkProperty(ci, "booleanVar", Boolean, false, true, true);
		checkProperty(ci, "uintVar", uint, false, true, false );
		checkProperty(ci, "untyped", Any, false, true, true);
		checkProperty(ci, "anything", Any, false, true, true);
		checkProperty(ci, "readOnlyProperty", String, false, true, false);
		checkProperty(ci, "readWriteProperty", String, false, true, true);
		checkProperty(ci, "booleanProperty", Boolean, false, true, true);
		checkProperty(ci, "nsProperty", Object, false, true, false, uri);
		checkProperty(ci, "nsVar", String, false, true, true, uri);
		checkProperty(ci, "staticReadOnlyProperty", XML, true, true, false);
		checkMethod(ci, "methodNoParams", Void, [], false);
		checkMethod(ci, "nsMethod", Void, [], false, uri);
		checkMethod(ci, "methodWithOptionalParam", Boolean, 
				[new Parameter(ClassInfo.forClass(String), true), 
				new Parameter(ClassInfo.forClass(uint), false)], false);
		checkMethod(ci, "methodWithPrivateClassReturnValue", Private, [], false);
		checkMethod(ci, "staticMethod", Void, [new Parameter(ClassInfo.forClass(Boolean), true)], true);
	}
	
	[Test]
	public function checkInterface () : void {
		var ci:ClassInfo = ClassInfo.forClass(InterfaceA);
		assertThat(ci.getClass(), sameInstance(InterfaceA));
		assertThat(ci.isInterface(), equalTo(true));
		assertThat(ci.getProperties(), arrayWithSize(0));
		assertThat(ci.getStaticProperties(), arrayWithSize(1));
		assertThat(ci.getMethods(), arrayWithSize(1));
		assertThat(ci.getStaticMethods(), arrayWithSize(0));
		checkMethod(ci, "foo", String, [], false);
	}
	
	[Test]
	public function internalSuperclass () : void {
		var ci:ClassInfo = ClassInfo.forClass(InternalSubclass);
		var type:Class = ci.getSuperClass();
		assertThat(ci.getSuperClass(), sameInstance(Private));
		assertThat(ci.getSuperClasses()[1], sameInstance(Object));
	}
	
	
	private function checkProperty (ci:ClassInfo, name:String, type:Class,
			isStatic:Boolean, readable:Boolean, writable:Boolean, namespaceURI:String = null) : void {
		var p:Property = (!isStatic) ? ci.getProperty(name, namespaceURI) : ci.getStaticProperty(name, namespaceURI);
		assertThat(p, notNullValue());
		assertThat(p.name, equalTo(name));
		assertThat(p.type.getClass(), sameInstance(type));
		assertThat(p.isStatic, equalTo(isStatic));
		assertThat(p.readable, equalTo(readable));
		assertThat(p.writable, equalTo(writable));
		assertThat(p.namespaceURI, equalTo(namespaceURI));
	}
	
	private function checkMethod (ci:ClassInfo, name:String,
			returnType:Class, params:Array, isStatic:Boolean, namespaceURI:String = null) : void {
		var m:Method = (!isStatic) ? ci.getMethod(name, namespaceURI) : ci.getStaticMethod(name, namespaceURI);		
		assertThat(m, notNullValue());
		assertThat(m.name, equalTo(name));
		assertThat(m.returnType.getClass(), sameInstance(returnType));
		assertThat(m.isStatic, equalTo(isStatic));
		var actualParams:Array = m.parameters;
		assertThat(m.parameters, arrayWithSize(params.length));
		var i:uint = 0;
		for each (var expectedParam:Parameter in params) {
			var actualParam:Parameter = actualParams[i++] as Parameter;
			assertThat(actualParam.type.getClass(), sameInstance(expectedParam.type.getClass()));
			assertThat(actualParam.required, equalTo(expectedParam.required));
		}			
		assertThat(m.namespaceURI, equalTo(namespaceURI));
	}
	
	
	[Test]
	public function cache () : void {
		var ci1:ClassInfo = ClassInfo.forClass(ClassB);
		var ci2:ClassInfo = ClassInfo.forClass(ClassB);
		assertThat(ci2, sameInstance(ci1));
	}
	
	[Test]
	public function cacheWithName () : void {
		var name:String = getQualifiedClassName(ClassB);
		var ci1:ClassInfo = ClassInfo.forName(name);
		var ci2:ClassInfo = ClassInfo.forName(name);
		assertThat(ci2, sameInstance(ci1));
	}
	
	[Test]
	public function newInstance () : void {
		var ci:ClassInfo = ClassInfo.forClass(ClassB);
		var classB:ClassB = ci.newInstance(["test"]) as ClassB;
		assertThat(classB.readOnlyProperty, equalTo("test"));
	}
	
	[Test(expects="org.spicefactory.lib.errors.IllegalStateError")]
	public function newInstanceForInterface () : void {
		var ci:ClassInfo = ClassInfo.forClass(InterfaceA);
		ci.newInstance([]);
	}
	
	[Test(async)]
	public function applicationDomain () : void {
		assertThat(ApplicationDomain.currentDomain.hasDefinition("org.spicefactory.lib.reflect.domain.ClassInChildDomain"), 
				equalTo(false));
		var loader:Loader = new Loader();
		loader.load(new URLRequest("domain.swf"));
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, Async.asyncHandler(this, onTestApplicationDomain, 3000));
	}
	
	private function onTestApplicationDomain (event:Event, data:Object = null) : void {
		var loaderInfo:LoaderInfo = LoaderInfo(event.target);
		var className:String = "org.spicefactory.lib.reflect.domain.ClassInChildDomain";
		try {
			ClassInfo.forName(className);
		}
		catch (e:Error) {
			assertThat(e, isA(ReferenceError));
			// Now try with the child domain
			var ci:ClassInfo = ClassInfo.forName(className, loaderInfo.applicationDomain);
			assertThat(ci.getSuperClass(), sameInstance(Sprite));
			return;
		}
		fail("Expected error in attempt to load class from parent domain");
	}
	
	[Test]
	public function proxy () : void {
		var o:Object = new TestProxy();
		var ci:ClassInfo = ClassInfo.forInstance(o);
		assertThat(ci.simpleName, equalTo("TestProxy"));
		assertThat(ci.getSuperClass(), sameInstance(Proxy));
	}
	
	[Test]
	public function arrayCollection () : void {
		var o:Object = new ArrayCollection();
		var ci:ClassInfo = ClassInfo.forInstance(o);
		assertThat(ci.simpleName, equalTo("ArrayCollection"));
	}
	
	[Test]
	public function numbers () : void {
		var n1:Number = 3.45;
		var n2:int = -4;
		var n3:uint = 4;
		
		assertThat(ClassInfo.forInstance(n1).name, equalTo("Number"));
		assertThat(ClassInfo.forInstance(n2).name, equalTo("int"));
		assertThat(ClassInfo.forInstance(n3).name, equalTo("int"));
	}
	
	
}
}
