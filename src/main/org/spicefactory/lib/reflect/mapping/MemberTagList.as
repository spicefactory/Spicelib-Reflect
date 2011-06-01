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

package org.spicefactory.lib.reflect.mapping {
import org.spicefactory.lib.reflect.Metadata;
import org.spicefactory.lib.reflect.mapping.MetadataMapping;
import org.spicefactory.lib.reflect.mapping.MetadataRegistry;
import org.spicefactory.lib.reflect.mapping.ValidationError;
/**
 * @private
 * 
 * @author Jens Halm
 */
internal class MemberTagList {
	
	private var name:String;
	private var type:String;

	private var mapping:MetadataMapping;
	private var values:Array = new Array();
	
	
	function MemberTagList (name:String, type:String) {
		this.name = name;
		this.type = type;
	}
	
	internal function resolve () : void {
		mapping = MetadataRegistry.instance.getMapping(name, type);
	}
	
	internal function get key () : Object {
		return (mapping) ? mapping.type.getClass() : name;
	}

	internal function addValue (value:Array) : void {
		values.push(value);
	}

	internal function getValues (validate:Boolean) : Array {
		if (validate && mapping && !mapping.allowMultiple && values.length > 1) {
			throw new ValidationError("Multiple occurrences of the tag mapped to " 
					+ mapping.type.name + " on the same element are not allowed");
		}
		var resolved:Array = new Array();
		for each (var value:Array in values) {
			resolved.push(resolveValue(value, validate));
		}
		return resolved;
	}
	
	private function resolveValue (value:Array, validate:Boolean) : Object {
		var resolved:Object = new Object();
		for each (var arg:Object in value) {
			var key:String = arg.key;
			if (mapping && mapping.defaultProperty && key === "") {
				key = mapping.defaultProperty;
			}
			resolved[key] = arg.value;
		}
		return (mapping) 
			? mapping.newInstance(resolved, validate) 
			: new Metadata(name, resolved);
	}
	
	
}
}
