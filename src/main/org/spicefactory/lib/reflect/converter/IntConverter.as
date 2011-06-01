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
import org.spicefactory.lib.reflect.Converter;
import org.spicefactory.lib.reflect.errors.ConversionError;

import flash.system.ApplicationDomain;

/**
 * Converts int values. 
 * 
 * @author Jens Halm
 */
public class IntConverter implements Converter {
	
	
	public static var INSTANCE:IntConverter = new IntConverter();
	
	
	/**
	 * Creates a new Converter instance.
	 */
	function IntConverter () {
		
	}
	
	/**
	 * @inheritDoc
	 */
	public function convert (value:*, domain:ApplicationDomain = null) : * {
		if (value is int) {
			return value;
		}
		if (value == null) {
			throw new ConversionError("Cannot convert null value to int"); 
		}
		if (isNaN(Number(value))) {
			throw new ConversionError("Unable to convert value to int: " + value);
		}
		var num:int = int(value);
		return num;
	}
	
	
}

}