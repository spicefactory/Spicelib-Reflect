/*
 * Copyright 2010 the original author or authors.
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

package org.spicefactory.lib.reflect.provider {
import org.spicefactory.lib.errors.IllegalStateError;

import flash.utils.describeType;

/**
 * ClassInfoProvider that uses the old XML-based describeType function for reflection.
 * 
 * @author Jens Halm
 */
public class XmlClassInfoProvider implements ClassInfoProvider {

	
	private var type:Class;
	
	private var _staticInfo:Object;
	private var _instanceInfo:Object;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param type the type to reflect upon
	 */
	function XmlClassInfoProvider (type:Class) {
		this.type = type;
	}

	
	/**
	 * @inheritDoc
	 */
	public function get staticInfo () : Object {
		init();
		return _staticInfo;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get instanceInfo () : Object {
		init();
		return _instanceInfo;
	}
	
	
	private function init () : void {
		if (_staticInfo && _instanceInfo) return;
		
		_staticInfo = {traits:{}};
		_instanceInfo = {traits:{}};
		
		var xml:XML = describeType(type);
		
		var staticChildren:XMLList = xml.children();
		var complete:Boolean = false;
		for each (var staticChild:XML in staticChildren) {
			var name:String = staticChild.localName() as String;
			if (name == "accessor") {
				parseAccessor(staticChild, _staticInfo.traits);
			} else if (name == "constant") {
				parseVariable(staticChild, _staticInfo.traits, "readonly");
			} else if (name == "variable") {
				parseVariable(staticChild, _staticInfo.traits, "readwrite");
			} else if (name == "method") {
				parseMethod(staticChild, _staticInfo.traits);
			} else if (name == "factory") {
				complete = true;
				_instanceInfo.traits.metadata = parseMetadata(staticChild);
				var instanceChildren:XMLList = staticChild.children();
				for each (var instanceChild:XML in instanceChildren) {
					var childName:String = instanceChild.localName() as String;
					if (childName == "constructor") {
						_instanceInfo.traits.constructor = parseParameters(instanceChild);
					} else if (childName == "accessor") {
						parseAccessor(instanceChild, _instanceInfo.traits);
					} else if (childName == "constant") {
						parseVariable(instanceChild, _instanceInfo.traits, "readonly");
					} else if (childName == "variable") {
						parseVariable(instanceChild, _instanceInfo.traits, "readwrite");
					} else if (childName == "method") {
						parseMethod(instanceChild, _instanceInfo.traits);
					} else if (childName == "extendsClass") {
						parseBase(instanceChild, _instanceInfo.traits);
					} else if (childName == "implementsInterface") {
						parseInterface(instanceChild, _instanceInfo.traits);
					}
				}
			}
		}
		if (!complete) {
			throw new IllegalStateError("No factory element in XML for " + this);
		}
	}
	
	
	private function parseBase (xml:XML, traits:Object) : void {
		if (!traits.bases) {
			traits.bases = [];
		}
		traits.bases.push(xml.@type.toString());
	}
	
	private function parseInterface (xml:XML, traits:Object) : void {
		if (!traits.interfaces) {
			traits.interfaces = [];
		}
		traits.interfaces.push(xml.@type.toString());
	}
	
	private function parseMethod (xml:XML, traits:Object) : void {
		var method:Object = {
			name: xml.@name.toString(),
			returnType: xml.@returnType.toString(),
			declaredBy: (xml.@declaredBy) ? xml.@declaredBy.toString() : null,
			uri: (xml.@uri) ? xml.@uri.toString() : null,			
			parameters: parseParameters(xml),
			metadata: parseMetadata(xml)
		};
		if (method.uri == "") method.uri = null;
		if (!traits.methods) {
			traits.methods = [];
		}
		traits.methods.push(method);		
	}
	
	private function parseParameters (xml:XML) : Array {
		var params:Array = new Array();
		for each (var paramXML:XML in xml.parameter) {
			var param:Object = {type : paramXML.@type.toString(), optional : (paramXML.@optional.toString() == "true")};
			params.push(param);
		} 
		return params;
	}
	
	private function parseAccessor (xml:XML, traits:Object) : void {
		var accessor:Object = {
			access: xml.@access.toString(),
			name: xml.@name.toString(),
			type: xml.@type.toString(),
			declaredBy: (xml.@declaredBy) ? xml.@declaredBy.toString() : null,
			uri: (xml.@uri) ? xml.@uri.toString() : null,		
			metadata: parseMetadata(xml)
		};
		if (accessor.uri == "") accessor.uri = null;
		if (!traits.accessors) {
			traits.accessors = [];
		}
		traits.accessors.push(accessor);		
	}
	
	private function parseVariable (xml:XML, traits:Object, access:String) : void {
		var variable:Object = {
			access: access,
			name: xml.@name.toString(),
			type: xml.@type.toString(),
			uri: (xml.@uri) ? xml.@uri.toString() : null,		
			metadata: parseMetadata(xml)
		};
		if (variable.uri == "") variable.uri = null;
		if (!traits.variables) {
			traits.variables = [];
		}
		traits.variables.push(variable);		
	}
	
	private function parseMetadata (xml:XML) : Array {
		var tags:Array = new Array();
		for each (var metadataTag:XML in xml.metadata) {
			var meta:Object = {name : metadataTag.@name.toString(), value : parseAttributes(metadataTag)};
			tags.push(meta);
		}
		return tags;
	}
	
	private function parseAttributes (xml:XML) : Array {
		var args:Array = new Array();
		for each (var argTag:XML in xml.arg) {
			var arg:Object = {key : argTag.@key.toString(), value : argTag.@value.toString()};
			args.push(arg);
		} 
		return args;
	}
	
	
}
}
