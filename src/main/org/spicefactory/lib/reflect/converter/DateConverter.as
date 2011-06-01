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
 * Converts to Date instances. Valid source types are Number (using it as a time value
 * passed to the Date constructor) or Strings in the format <code>YYYY-MM-DD HH:MM:SS</code>
 * with the time part being optional.
 * 
 * @author Jens Halm
 */
public class DateConverter implements Converter {

	
	public static const INSTANCE:DateConverter = new DateConverter();
	
	
	/**
	 * Creates a new Converter instance.
	 */
	public function DateConverter () {
		
	}
	
	/**
	 * @inheritDoc
	 */
	public function convert (value:*, domain:ApplicationDomain = null) : * {
		if (value is Date) {
			return value;
		}
		if (value == null) {
			throw new ConversionError("Cannot convert null value to Date"); 
		}
		if (value is Number) {
			return new Date(value);
		}
		var str:String = value.toString();
		var parts:Array = str.split(" ");
		if (parts.length > 2) {
			throw new ConversionError("Illegal date format: " + str);
		}			
		var dateParts:Array = parseParts(parts[0].split("-"));
		if (dateParts == null
			|| dateParts[0] < 0 
			|| dateParts[1] < 1 || dateParts[1] > 12
			|| dateParts[2] < 1 || dateParts[2] > 31) {
			throw new ConversionError("Illegal date format: " + str);
		}
		
		if (parts.length == 1) return new Date(dateParts[0], dateParts[1] - 1, dateParts[2]);
		
		var timeParts:Array = parseParts(parts[1].split(":"));
		if (timeParts == null
			|| timeParts[0] < 0 || timeParts[0] > 23
			|| timeParts[1] < 0 || timeParts[1] > 59
			|| timeParts[2] < 0 || timeParts[2] > 59) {
			throw new ConversionError("Illegal date format: " + str);
		}	
		return new Date(dateParts[0], (dateParts[1] - 1), dateParts[2], timeParts[0], timeParts[1], timeParts[2]);
	}
	
	private function parseParts (parts:Array) : Array {
		if (parts.length != 3) {
			return null;
		}
		var nums:Array = new Array();
		for (var i:uint = 0; i < 3; i++) {
			var num:uint = uint(parts[i]);
			if (isNaN(num) || parseInt(num.toString()) != num) {
				return null;
			}
			nums[i] = parts[i];
		}
		return nums;
	}
	
	
}

}