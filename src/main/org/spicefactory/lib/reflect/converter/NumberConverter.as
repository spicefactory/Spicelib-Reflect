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
 * Converts Number values.
 * 
 * @author Jens Halm
 */	
public class NumberConverter implements Converter {
	
	
	public static var INSTANCE:NumberConverter = new NumberConverter();
	
	
	/**
	 * Creates a new Converter instance.
	 */
	public function NumberConverter () {
		
	}
	
	/**
	 * @inheritDoc
	 */
	public function convert (value:*, domain:ApplicationDomain = null) : * {
		if (value is Number) {
			return value;
		}
		if (value == null) {
			throw new ConversionError("Cannot convert null value to Number"); 
		}
		var num:Number = Number(value);
		if (isNaN(num)) {
			throw new ConversionError("Unable to convert value to Number: " + value);
		}
		return num;
	}

	
}

}