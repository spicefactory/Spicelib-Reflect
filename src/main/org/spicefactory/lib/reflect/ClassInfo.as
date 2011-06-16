/*
 * Copyright 2007 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.spicefactory.lib.reflect {

import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.cache.DefaultReflectionCache;
import org.spicefactory.lib.reflect.cache.ReflectionCache;
import org.spicefactory.lib.reflect.provider.ClassInfoProvider;
import org.spicefactory.lib.reflect.provider.ClassInfoProviderFactory;
import org.spicefactory.lib.reflect.types.Any;
import org.spicefactory.lib.reflect.types.Private;
import org.spicefactory.lib.reflect.types.Void;

import flash.system.ApplicationDomain;
import flash.utils.Proxy;
import flash.utils.getQualifiedClassName;

/**
 * Represents a class or interface and allows reflection on its name, properties and methods.
 * Instances of this class can be obtained with one of the three static methods (<code>forName</code>,
 * <code>forClass</code> or <code>forInstance</code>). ClassInfo instances are cached and rely on
 * the XML returned by <code>flash.utils.describeType</code> internally.
 * 
 * @author Jens Halm
 */
public class ClassInfo extends MetadataAware {


	private static var _cache:ReflectionCache = new DefaultReflectionCache();
	private static const providerFactory:ClassInfoProviderFactory = new ClassInfoProviderFactory();
	
	
	/**
	 * The ApplicationDomain to be used when no domain was explicitly specified.
	 * Points to ApplicationDomain.currentDomain but makes sure that always the
	 * same instance will be used. Since ApplicationDomain.currentDomain always
	 * returns a different instance it would be difficult to use domains as keys 
	 * in Dictionaries otherwise.
	 */
	public static const currentDomain:ApplicationDomain = ApplicationDomain.currentDomain;
	
	
	/**
	 * The reflection cache which keeps references to all ClassInfo instances created by the
	 * three static methods of this class.
	 */
	public static function get cache () : ReflectionCache {
		return _cache; 
	}
	
	public static function set cache (value:ReflectionCache) : void {
		_cache = value;
	}
	
	
	/**
	 * Returns an instance representing the class or interface with the specified name.
	 * If the optional <code>domain</code> parameter is omitted <code>ApplicationDomain.currentDomain</code>
	 * will be used.
	 * 
	 * @param name the fully qualified name of the class or interface
	 * @param domain the ApplicationDomain to load the class from
	 * @return an instance representing the class or interface with the specified name
	 * @throws ReferenceError if the class with the specified name does not exist
	 */
	public static function forName (name:String, domain:ApplicationDomain = null) : ClassInfo {
		if (name == null) throw new IllegalArgumentError("Name must not be null");
		domain = getDomain(domain);
		var C:Class = getClassDefinitionByName(name, domain);
		return getClassInfo(C, domain, name);
	}

	/**
	 * Returns an instance representing the specified class or interface.
	 * If the optional <code>domain</code> parameter is omitted <code>ApplicationDomain.currentDomain</code>
	 * will be used.
	 * 
	 * @param clazz the class or interface to reflect on
	 * @param domain the ApplicationDomain the specified class was loaded from
	 * @return an instance representing the specified class or interface
	 */	
	public static function forClass (clazz:Class, domain:ApplicationDomain = null) : ClassInfo {
		if (clazz == null) throw new IllegalArgumentError("Class must not be null");
		return getClassInfo(clazz, getDomain(domain));
	}

	/**
	 * Returns an instance representing the class of the specified instance.
	 * If the optional <code>domain</code> parameter is omitted <code>ApplicationDomain.currentDomain</code>
	 * will be used.
	 * 
	 * @param instance the instance to return the ClassInfo for
	 * @return an instance representing the class of the specified instance
	 */		
	public static function forInstance (instance:Object, domain:ApplicationDomain = null) : ClassInfo {
		if (instance == null) throw new IllegalArgumentError("Instance must not be null");
		if (instance is Proxy || instance is Number) {
			// Cannot rely on Proxy subclasses to support the constructor property
			// For Number instance constructor property always returns Number (never int)
			return forName(getQualifiedClassName(instance), domain);
		}
		var C:Class = instance.constructor as Class;
		if (C == null) {
			return forName(getQualifiedClassName(instance), domain);
		}
		return getClassInfo(C, getDomain(domain));
	}
	
	private static function getDomain (domain:ApplicationDomain) : ApplicationDomain {
		return (domain == null) ? currentDomain : domain;
	}
	
	internal static function resolve (name:String, domain:ApplicationDomain) : ClassInfo {
		try {
			return forName(name, domain);
		}
		catch (e:ReferenceError) {
			/* fall through */
		}
		return ClassInfo.forClass(Private);
	}
	
	private static function getClassDefinitionByName (name:String, domain:ApplicationDomain, refType:Class = null) : Class {
		if (name == "*") {
			return Any;
		} else if (name == "void") {
			return Void;
		} else if (name.indexOf(".as$") != -1) {
			return Private;
		} else {
			var type:Class;
			try {
				type = domain.getDefinition(name) as Class;
			}
			catch (e:ReferenceError) {
				/* fall through */
			}
			if (type == null || (refType != null && refType !== type)) {
				throw new ReferenceError("Specified ApplicationDomain does not contain the class " + name);
			}
			return type;
		}
	}
	
	
	private static function getClassInfo (clazz:Class, domain:ApplicationDomain, name:String = null) : ClassInfo {
		if (name == null) {
			name = getQualifiedClassName(clazz);
			getClassDefinitionByName(name, domain, clazz); // just for eager validation of the domain
		}
		var cacheEntry:ClassInfo = cache.getClass(clazz, domain);
		if (cacheEntry != null) {
			return cacheEntry;
		}
		var ci:ClassInfo = new ClassInfo(name, clazz, domain, providerFactory.newProvider(clazz));
		cache.addClass(ci, domain);
		return ci;		
	}
	
	
	[Deprecated(replacement="cache.purgeDomain")]
	public static function purgeCache (domain:ApplicationDomain = null) : void {
		if (domain == null) {
			cache.purgeAll();
		}
		else {
			cache.purgeDomain(domain);
		}
	} 
	
	
	private var _name:String;
	private var _simpleName:String;
	
	private var type:Class;
	private var _applicationDomain:ApplicationDomain;
	private var provider:ClassInfoProvider;
	
	private var superClasses:Array;
	private var interfaces:Array;

	private var _constructor:Constructor;

	private var methods:Map;
	private var staticMethods:Map;
	private var properties:Map;
	private var staticProperties:Map;
	 
	/**
	 * @private
	 */
	function ClassInfo (name:String, type:Class, domain:ApplicationDomain, provider:ClassInfoProvider) {
		super(null); // Defer creation of metadata until init gets executed
		this._name = name;
		this.type = type;
		this._applicationDomain = domain;
		this.provider = provider;
	}
	
	private function getDefinition (name:String) : Class {
		try {
			return getClassDefinitionByName(name, _applicationDomain);
		}
		catch (e:ReferenceError) {
			/* fall through */
		}
		return Private;
	}

	/**
	 * The fully qualified class name for this instance.
	 */
	public function get name () : String {
		return _name;
	}
	
	/**
	 * The non qualified class name for this instance.
	 */
	public function get simpleName () : String {
		if (_simpleName == null) {
			var name:String = _name.replace("::", ".");
			_simpleName = name.substring(name.lastIndexOf(".") + 1);
		}
		return _simpleName;
	}
	
	
	/**
	 * Creates a new instance of the class represented by this ClassInfo instance.
	 * This is just a shortcut for <code>ClassInfo.getConstructor().newInstance()</code>.
	 * 
	 * @param constructorArgs the argumenst to pass to the constructor
	 * @return a new instance of the class represented by this ClassInfo instance
	 */
	public function newInstance (constructorArgs:Array) : Object {
		if (isInterface()) {
			throw new IllegalStateError("Cannot instantiate an interface: " + name);
		}
		return getConstructor().newInstance(constructorArgs);
	}
	
	/**
	 * Returns the class this instance represents.
	 * 
	 * @return the class this instance represents
	 */
	public function getClass () : Class {
		return type;
	}
	
	/**
	 * The ApplicationDomain this class belongs to. It will be used to load
	 * all dependent classes referenced by properties or methods of this class.
	 */
	public function get applicationDomain () : ApplicationDomain {
		return _applicationDomain;
	}

	/**
	 * Indicates whether this type is an interface.
	 * 
	 * @return true if this type is an interface
	 */
	public function isInterface () : Boolean {
		initBases();
		return superClasses.length == 0 && type != Object;
	}

	/**
	 * Returns the constructor for this class.
	 * This method will return null for interfaces.
	 * 
	 * @return the constructor for this class
	 */
	public function getConstructor () : Constructor {
		if (isInterface()) return null;
		initConstructor();
		return _constructor;
	}
	
	private function initConstructor () : void {
		if (_constructor) return;
		if (provider.instanceInfo.traits.constructor is Array) {
			_constructor = new Constructor(provider.instanceInfo.traits.constructor, this);
		}
		else {
			// empty default constructor
			_constructor = new Constructor([], this);
		}
	}

	/**
	 * Returns the Property instance for the specified property name.
	 * The property may be declared in this class or in one of its superclasses or superinterfaces.
	 * The property must be public and non-static 
	 * and may have been declared with var, const or implicit getter/setter functions.
	 * 
	 * @param name the name of the property
	 * @param namespaceURI the namespace uri of the property
	 * @return the Property instance for the specified property name or null if no such property exists
	 */
	public function getProperty (name:String, namespaceURI:String = null) : Property {
		initProperties();
		name = (namespaceURI) ? namespaceURI + "::" + name : name;
		return properties.get(name) as Property;
	}
	
	/**
	 * Returns Property instances for all public, non-static properties of this class.
	 * Included are all properties declared in this class 
	 * or in one of its superclasses or superinterfaces with var, const or implicit getter/setter
	 * functions.
	 * 
	 * @return Property instances for all public, non-static properties of this class
	 */
	public function getProperties () : Array {
		initProperties();
		return properties.values.toArray();
	}
	
	private function initProperties () : void {
		if (properties) return;
		properties = createPropertyMap(provider.instanceInfo.traits, false);
	}
	
	private function createPropertyMap (traits:Object, isStatic:Boolean) : Map {
		var map:Map = new Map();
		var p:Property;
		for each (var accessor:Object in traits.accessors) {
			p = new Property(accessor, isStatic, this);
			map.put(getMapKey(p), p);
 		}
 		for each (var variable:Object in traits.variables) {
			p = new Property(variable, isStatic, this);
			map.put(getMapKey(p), new Property(variable, isStatic, this));
 		}
		return map;
	}
	
	private function getMapKey (member:Member) : String {
		return (member.namespaceURI) ? member.namespaceURI + "::" + member.name : member.name;
	}

	/**
	 * Returns the Property instance for the specified property name.
	 * The property must be public and static and may have been declared 
	 * with var, const or implicit getter/setter functions.
	 * Static properties of superclasses or superinterfaces are not included.
	 * 
	 * @param name the name of the static property
	 * @param namespaceURI the namespace uri of the property
	 * @return the Property instance for the specified property name or null if no such property exists
	 */	
	public function getStaticProperty (name:String, namespaceURI:String = null) : Property {
		initStaticProperties();
		name = (namespaceURI) ? namespaceURI + "::" + name : name;
		return staticProperties.get(name) as Property;
	}

	/**
	 * Returns Property instances for all public, static properties of this class.
	 * Included are all static properties declared in this class
	 * with var, const or implicit getter/setter
	 * functions.
	 * 
	 * @return Property instances for all public, static properties of this class
	 */	
	public function getStaticProperties () : Array {
		initStaticProperties();
		return staticProperties.values.toArray();
	}
	
	private function initStaticProperties () : void {
		if (staticProperties) return;
		staticProperties = createPropertyMap(provider.staticInfo.traits, true);
	}
	
	/**
	 * Returns the Method instance for the specified method name.
	 * The method must be public, non-static and
	 * may be declared in this class or in one of its superclasses or superinterfaces.
	 * 
	 * @param name the name of the method
	 * @param namespaceURI the namespace uri of the property
	 * @return the Method instance for the specified method name or null if no such method exists
	 */
	public function getMethod (name:String, namespaceURI:String = null) : Method {
		initMethods();
		name = (namespaceURI) ? namespaceURI + "::" + name : name;
		return methods.get(name) as Method;
	}
	
	/**
	 * Returns Method instances for all public, non-static methods of this class.
	 * Included are all methods declared in this class 
	 * or in one of its superclasses or superinterfaces.
	 * 
	 * @return Method instances for all public, non-static methods of this class
	 */
	public function getMethods () : Array {
		initMethods();
		return methods.values.toArray();
	}
	
	private function initMethods () : void {
		if (methods) return;
		methods = createMethodMap(provider.instanceInfo.traits, false);
	}
	
	private function createMethodMap (traits:Object, isStatic:Boolean) : Map {
		var map:Map = new Map();
		for each (var method:Object in traits.methods) {
			var m:Method = new Method(method, isStatic, this);
			map.put(getMapKey(m), m);
 		}
		return map;
	}
	
	/**
	 * Returns the Method instance for the specified method name.
	 * The method must be public, static and
	 * must be declared in this class.
	 * 
	 * @param name the name of the static method
	 * @param namespaceURI the namespace uri of the property
	 * @return the Method instance for the specified method name or null if no such method exists
	 */
	public function getStaticMethod (name:String, namespaceURI:String = null) : Method {
		initStaticMethods();
		name = (namespaceURI) ? namespaceURI + "::" + name : name;
		return staticMethods.get(name) as Method;
	}

	/**
	 * Returns Method instances for all public, static methods of this class.
	 * Included are all static methods declared in this class.
	 * 
	 * Method instances for all public, static methods of this class
	 */	
	public function getStaticMethods () : Array {
		initStaticMethods();
		return staticMethods.values.toArray();
	}
	
	private function initStaticMethods () : void {
		if (staticMethods) return;
		staticMethods = createMethodMap(provider.staticInfo.traits, true);
	}
	
	/**
	 * Returns the superclass of the class represented by this ClassInfo instance.
	 * 
	 * @return the superclass of the class represented by this ClassInfo instance
	 */
	public function getSuperClass () : Class {
		initBases();
		return superClasses[0] as Class;
	}
	
	/**
	 * Returns all superclasses or superinterfaces of the class or interface
	 * represented by this ClassInfo instance. The first element in the Array
	 * is always the immediate superclass.
	 * 
	 * @return all superclasses or superinterfaces of the class or interface
	 * represented by this ClassInfo instance
	 */
	public function getSuperClasses () : Array {
		initBases();
		return superClasses.concat();
	}
	
	private function initBases () : void {
		if (superClasses) return;
		superClasses = new Array();
		for each (var base:String in provider.instanceInfo.traits.bases) {
			superClasses.push(getDefinition(base));
		}
	}
	
	private function initInterfaces () : void {
		if (interfaces) return;
		interfaces = new Array();
		for each (var inf:String in provider.instanceInfo.traits.interfaces) {
			interfaces.push(getDefinition(inf));
		}
	}

	/**
	 * Returns all interfaces implemented by the class
	 * represented by this ClassInfo instance.
	 * 
	 * @return all interfaces implemented by the class
	 * represented by this ClassInfo instance
	 */	
	public function getInterfaces () : Array {
		initInterfaces();
		return interfaces.concat();
	}
	
	/**
	 * Checks whether the class or interface represented by this ClassInfo instance
	 * is a subclass or subinterface of the specified class.
	 * 
	 * @return true if the class or interface represented by this ClassInfo instance
	 * is a subclass or subinterface of the specified class
	 */
	public function isType (c:Class) : Boolean {
		initBases();
		initInterfaces();
		if (type == c || Object == c) return true;
		for each (var sc:Class in superClasses) {
			if (sc == c) return true;
		}
		for each (var inf:Class in interfaces) {
			if  (inf == c) return true;
		}
		return false;
	}
	
	
	/**
	 * @private
	 */
	public override function hasMetadata (type:Object) : Boolean {
		initTraits();
		return super.hasMetadata(type);
	}
	
	/**
	 * @private
	 */
	public override function getMetadata (type:Object, validate:Boolean = true) : Array {
		initTraits();
		return super.getMetadata(type, validate);
	}
	
	/**
	 * @private
	 */
	public override function getAllMetadata (validate:Boolean = true) : Array {
		initTraits();
		return super.getAllMetadata(validate);
	}
	
	private function initTraits () : void {
		if (info) return;
		info = provider.instanceInfo.traits;
	}

	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[ClassInfo for class " + name + "]";
	} 
	

}

}