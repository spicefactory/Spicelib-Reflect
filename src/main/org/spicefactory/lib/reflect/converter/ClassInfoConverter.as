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
import flash.system.ApplicationDomain;

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Converter;
import org.spicefactory.lib.reflect.errors.ConversionError;	

/**
 * Converts ClassInfo values. May optionally check for a required type.
 * 
 * @author Jens Halm
 */
public class ClassInfoConverter implements Converter {
	
	
	private var requiredType:ClassInfo;
	
	
	/**
	 * Creates a new Converter instance.
	 * 
	 * @param requiredType converted ClassInfo instances must represent this type or a subtype
	 */
	function ClassInfoConverter (requiredType:ClassInfo = null) {
		this.requiredType = requiredType;
	}
	
	/**
	 * @inheritDoc
	 */
	public function convert (value:*, domain:ApplicationDomain = null) : * {
		if (domain == null) domain = ClassInfo.currentDomain;
		if (value is ClassInfo) {
			return value;
		}
		if (value == null) {
			throw new ConversionError("Cannot convert null value to ClassInfo"); 
		}
		var str:String = value.toString();
		var ci:ClassInfo;
		try {
			ci = ClassInfo.forName(str, domain);
		} catch (e:Error) {
			throw new ConversionError("Unknown class: " + str, e);
		}
		if (requiredType != null && !ci.isType(requiredType.getClass())) {
			throw new ConversionError("Specified class " + ci.name 
				+ " is not of required type " + requiredType.name);
		}
		return ci;
	}
	
	
}

}