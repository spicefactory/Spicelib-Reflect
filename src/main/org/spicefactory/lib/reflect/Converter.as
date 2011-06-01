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
import flash.system.ApplicationDomain;

/**
 * Interface to be implemented by objects responsible for any necessary type conversion.
 * Instances implementing this interface will be registered with <code>Type.addConverter</code>
 * and will be used in <code>Parameter</code> and <code>Property</code> instances 
 * to convert method parameters or property values if they do not match the required 
 * target type. Spicelib contains several builtin Converters for some of the
 * top level types like Boolean, String, Number or Date. Applications can register
 * additional Converters as required. Usually a single implementation is responsible
 * for converting to one specific target type like Date.
 * 
 * @author Jens Halm
 */ 
public interface Converter {
	
	/**
	 * Converts the specified value to the target type this Converter is implemented for.
	 * Implementations should return the value unchanged if it is already of the target type.
	 * 
	 * @param value the value to be converted
	 * @param domain the domain to use for reflection (only used by some converter implementations)
	 * @return the converted value
	 * @throws org.spicefactory.lib.reflect.errors.ConversionError if conversion failed
	 */
	function convert (value:*, domain:ApplicationDomain = null) : * ;
	
		
}

}