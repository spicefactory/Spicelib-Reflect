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
 
package org.spicefactory.lib.reflect.converter {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Converter;
import org.spicefactory.lib.reflect.errors.ConversionError;

import flash.system.ApplicationDomain;

/**
 * Converts to Enumeration instances. Since AS3 does not have builtin enum types
 * this corresponds to a "faked enum" pattern. The target class should only contain
 * public const declarations which hold instances of that class. If a String value
 * is the source value of type conversion it is interpreted as the name of one
 * of the constants of the enumeration type.
 * 
 * @author Jens Halm
 */
public class EnumerationConverter implements Converter {


	private var type:ClassInfo;
	
	
	/**
	 * Creates a new Converter instance.
	 */
	function EnumerationConverter (type:ClassInfo) {
		this.type = type;
	}
	
	/**
	 * @inheritDoc
	 */
	public function convert (value:*, domain:ApplicationDomain = null) : * {
		if (value is type.getClass()) {
			return value;
		}
		if (value == null) {
			throw new ConversionError("Cannot convert null value to Enumeration"); 
		}
		var str:String = value.toString();
		if (str.length == 0) {
			throw new ConversionError("Cannot convert empty string to Enumeration"); 
		}
		str = convertCamelCase(str);
		var result:* = type.getClass()[str];
		if (!(result is type.getClass())) {
			throw new ConversionError(str + " is not a valid value for Enumeration class " + type.name);
		}
		return result;		
	}
	
	private function convertCamelCase (orig:String) : String {
		var result:String = "";
		for (var i:int = 0; i < orig.length; i++) {
			var c:String = orig.charAt(i);
			if (c >= "a" && c <= "z") {
				result += c.toUpperCase();
			}
			else if (i == 0) {
				return orig;
			}
			else {
				result += "_" + c;
			}
		}
		return result;
	}
	

}

}