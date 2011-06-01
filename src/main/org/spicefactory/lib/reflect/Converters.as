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
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.reflect.Converter;
import org.spicefactory.lib.reflect.converter.BooleanConverter;
import org.spicefactory.lib.reflect.converter.ClassConverter;
import org.spicefactory.lib.reflect.converter.ClassInfoConverter;
import org.spicefactory.lib.reflect.converter.DateConverter;
import org.spicefactory.lib.reflect.converter.IntConverter;
import org.spicefactory.lib.reflect.converter.NoOpConverter;
import org.spicefactory.lib.reflect.converter.NumberConverter;
import org.spicefactory.lib.reflect.converter.StringConverter;
import org.spicefactory.lib.reflect.converter.UintConverter;
import org.spicefactory.lib.reflect.errors.ConversionError;
import org.spicefactory.lib.reflect.types.Any;

import flash.system.ApplicationDomain;
import flash.utils.getQualifiedClassName;

/**
 * Facility for registering custom Converter implementations. Also contains a utility method
 * that converts a value using one of the registered Converters.
 * 
 * @author Jens Halm
 */
public class Converters {


	/**
	 * The ApplicationDomain to be used by converters that need to use reflection.
	 * This hook allows to temporarily overwrite the default, which is using the domain
	 * the owner class of the property or method that triggers conversion belongs to.
	 * Sometimes the default is not sufficient, for example when a framework class has
	 * a property of type <code>Class</code> that may hold values pointing to classes
	 * loaded into child ApplicationDomains.
	 * 
	 * <p>It is recommended to set this value in a try/finally clause and set it back 
	 * to the previous value in the finally clause.</p>
	 */
	public static function get processingDomain () : ApplicationDomain {
		return _processingDomain;
	}
	
	private static var _processingDomain:ApplicationDomain;
	
	public static function set processingDomain (domain:ApplicationDomain) : void {
		LogContext.getLogger(Converters).info("Setting processing domain: " + domain);
		_processingDomain = domain;
	}

	/**
	 * Converts the given value to the specified target type.
	 * If no conversion is necessary the value will be returned unchanged.
	 * Otherwise this method will look for a matching <code>Converter</code>
	 * instance and try to convert the value.
	 * 
	 * @param value the value to convert
	 * @param targetType the type to convert the value to
	 * @throws ConversionError if the conversion fails or if there is no Converter registered for the 
	 * specified type.
	 */
	public static function convert (value:*, targetType:Class, domain:ApplicationDomain = null) : * {
		if (!(value is targetType) && value != null && targetType != null) {
			var conv:Converter = getConverter(targetType);
			if (conv == null) {
				throw new ConversionError("No converter registered for converting class " 
						+ getQualifiedClassName(value) + " to class " 
						+ getQualifiedClassName(targetType));
			}
			domain = (processingDomain) ? processingDomain : domain;
			value = conv.convert(value, domain);
		}
		return value;
	}
	
	
	private static var converters:Object;
	
	/**
	 * Registers a Converter for the specified class.
	 * Converters will be used for automatic type conversion when setting property values
	 * with Spicelib Property instances or invoking methods with Spicelib Method instances.
	 * 
	 * @param type the class for which to register the Converter
	 * @param converter the Converter instance to be used for the specified type
	 */
	public static function addConverter (type:Class, converter:Converter) : void {
		if (converters == null) {
			initConverters();
		}
		converters[getQualifiedClassName(type)] = converter;
	}
	
	/**
	 * Returns the Converter registered for the specified class.
	 * 
	 * @param type the class for which to return the registered Converter 
	 * @return the Converter registered for the specified class or null if no Converter has been
	 * registered for that class
	 */
	public static function getConverter (type:Class) : Converter {
		if (converters == null) {
			initConverters();
		}
		return converters[getQualifiedClassName(type)] as Converter;
	}
	
	private static function initConverters () : void {
		converters = new Object();
		addConverter(Any, NoOpConverter.INSTANCE);
		addConverter(String, StringConverter.INSTANCE);
		addConverter(Boolean, BooleanConverter.INSTANCE);
		addConverter(Number, NumberConverter.INSTANCE);
		addConverter(int, IntConverter.INSTANCE);
		addConverter(uint, UintConverter.INSTANCE);
		addConverter(Date, DateConverter.INSTANCE);
		addConverter(Class, ClassConverter.INSTANCE);
		addConverter(ClassInfo, new ClassInfoConverter());
	}
	

}

}