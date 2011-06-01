/*
 * Copyright 2009 the original author or authors.
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

package org.spicefactory.lib.reflect.mapping {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.lib.reflect.metadata.AssignableTo;
import org.spicefactory.lib.reflect.metadata.DefaultProperty;
import org.spicefactory.lib.reflect.metadata.MappedMetadata;
import org.spicefactory.lib.reflect.metadata.Required;
import org.spicefactory.lib.reflect.metadata.Types;

/**
 * @private
 * 
 * @author Jens Halm
 */
internal class MetadataMapping {

	
	private var _type:ClassInfo;
	private var name:String;
	private var members:Array;
	private var _allowMultiple:Boolean;
	private var strict:Boolean = true;

	private var _defaultProperty:String;
	private var _properties:Array;
	
	
	/**
	 * @private
	 */
	function MetadataMapping (type:ClassInfo) {
		this._type = type;
	}
	
	/**
	 * @private
	 */
	internal function init () : void {
		if (!type.hasMetadata(MappedMetadata)) {
			throw new IllegalArgumentError("Expected exactly one [Metadata] tag on Class " + type.name);
		}
		var mappedMetadata:MappedMetadata = MappedMetadata(type.getMetadata(MappedMetadata)[0]);
		this.name = (mappedMetadata.name == null) ? type.simpleName : mappedMetadata.name;
		this._allowMultiple = mappedMetadata.multiple;
		this.strict = mappedMetadata.strict;
		
		this.members = (mappedMetadata.types == null || mappedMetadata.types.length == 0)
				? [Types.CLASS, Types.CONSTRUCTOR, Types.PROPERTY, Types.METHOD] : mappedMetadata.types;
		_properties = new Array();
		for each (var p:Property in type.getProperties()) {
			if (!p.writable) continue;
			
			var defaultMeta:Array = p.getMetadata(DefaultProperty);
			if (defaultMeta.length == 1) {
				if (_defaultProperty != null) {
					throw new IllegalArgumentError("Expected no more than one property annotated " +
							"with [DefaultProperty] on Class " + type.name);
				}
				_defaultProperty = p.name;
			}
			
			var assignableMeta:Array = p.getMetadata(AssignableTo);
			var assignableTo:ClassInfo = (assignableMeta.length == 1) 
					? ClassInfo.forClass(AssignableTo(assignableMeta[0]).type, type.applicationDomain) : null;
			if (assignableTo != null && p.type.getClass() != Class && p.type.getClass() != ClassInfo) {
				throw new Error("Illegal placement of AssignableTo tag on " + p 
						+ " - tag is only allowed on properties of type Class or ClassInfo");
			}	
			
			_properties.push(new MappedProperty(p, p.hasMetadata(Required), assignableTo));
		}
	}
	
	/**
	 * @private
	 */
	internal function initInternalMapping (name:String, members:Array, properties:Array) : void {
		this.name = name;
		this.members = members;
		this._properties = properties;	
	}

	
	/**
	 * @private
	 */
	internal function get type () : ClassInfo {
		return _type;	
	}
	
	/**
	 * @private
	 */
	internal function get defaultProperty () : String {
		return _defaultProperty;
	}
	
	/**
	 * @private
	 */
	internal function get allowMultiple () : Boolean {
		return _allowMultiple;
	}
	
	/**
	 * @private
	 */
	internal function get registrationKeys () : Array {
		var keys:Array = new Array();
		for each (var type:String in members) {
			keys.push(name + " " + type);
		}
		return keys;
	}
	
	/**
	 * @private
	 */
	internal function newInstance (values:Object, validate:Boolean) : Object {
		var instance:Object = _type.newInstance([]);
		for each (var prop:MappedProperty in _properties) {
			prop.mapValue(instance, values, validate);
		}
		if (validate && strict) {
			var unmapped:Array = new Array();
			for (var key:String in values) {
				unmapped.push(key);
			}
			if (unmapped.length > 0) {
				throw new ValidationError("Unmappable attributes for mapped class " 
						+ _type.name + ": " + unmapped.join(","));
			}
		}
		return instance;		
	}
	
	
}
}
