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
import org.spicefactory.lib.reflect.Converters;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

/**
 * Represents a single property that can be mapped to an attribute of a metadata tag or an XML tag.
 * 
 * @author Jens Halm
 */
public class MappedProperty {
	
	
	private var targetProperty:Property;
	private var assignableTo:ClassInfo;
	private var required:Boolean;
	
	
	/**
	 * @private
	 */
	function MappedProperty (targetProperty:Property, required:Boolean = false, assignableTo:ClassInfo = null) {
		this.targetProperty = targetProperty;
		this.required = required;
		this.assignableTo = assignableTo;
	}
	

	/**
	 * @private
	 */
	internal function mapValue (target:Object, values:Object, validate:Boolean) : void {
		if (values[targetProperty.name] != undefined) {
			var stringValue:String = values[targetProperty.name];
			try {
				var value:* = (targetProperty.type.isType(Array)) ? splitAndTrim(stringValue) : stringValue;
				if (assignableTo != null) {
					value = Converters.convert(value, targetProperty.type.getClass(), targetProperty.type.applicationDomain);
					var validatable:ClassInfo = (value is Class) ? ClassInfo.forClass(value as Class) : value as ClassInfo;
					if (!validatable.isType(assignableTo.getClass())) {
						var message:String = "Expected a type assignable to " + assignableTo.name 
								+ "as the mapped value for " + targetProperty;
						if (validate) {
							throw new ValidationError(message);
						}
						else {
							trace(message);
						}
					}
				}
				targetProperty.setValue(target, value);
			}
			catch (e:Error) {
				var message2:String = "Unable to set mapped value for " + targetProperty;
				if (validate) {
					throw new ValidationError(message2, e);
				}
				else {
					trace(message2, e);
				}
			}
			
			delete values[targetProperty.name];
		}
		else if (validate && required) {
			throw new ValidationError("Missing required attribute for property " + targetProperty);
		}
	}
	
	/**
	 * TODO - move this utility method somewhere else
	 * @private
	 */
	public static function splitAndTrim (value:String) : Array {
		value = value.replace(/^\s+|\s+$/g, '');
		value = value.replace(/\s+,\s+/g, ',');
		value = value.replace(/,\s+|\s+,/g, ',');
		return value.split(",");
	}

	
}

}
