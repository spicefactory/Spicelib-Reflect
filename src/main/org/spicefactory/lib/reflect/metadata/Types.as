/*
 * Copyright 2008 the original author or authors.
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
 
package org.spicefactory.lib.reflect.metadata {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Constructor;
import org.spicefactory.lib.reflect.MetadataAware;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Property;

import flash.utils.getQualifiedClassName;

/**
 * Constants representing the types that metadata tags can be placed on. 
 * 
 * @author Jens Halm
 */
public class Types {


	/**
	 * Constant for classes.
	 */
	public static const CLASS:String = "class";
	
	/**
	 * Constant for constructors.
	 * 
	 * <p>This type is included for future use.
	 * Currently the Flex SDK compiler ignores all metadata tags placed on constructors.</p>
	 */
	public static const CONSTRUCTOR:String = "constructor";
	
	/**
	 * Constant for properties. This includes properties declared with public getter and/or setter
	 * methods as well as properties declared with <code>var</code> or <code>const</code>.
	 */
	public static const PROPERTY:String = "property";
	
	/**
	 * Constant for methods.
	 */
	public static const METHOD:String = "method";
	
	
	/**
	 * Returns the constant matching the specified metadata owner.
	 * 
	 * @param owner the type the metadata is placed upon
	 * @return the constant matching the specified metadata owner
	 */
	public static function forOwner (owner:MetadataAware) : String {
		if (owner is Property) {
			return PROPERTY;
		}
		else if (owner is Method) {
			return METHOD;
		}
		else if (owner is ClassInfo) {
			return CLASS;
		}
		else if (owner is Constructor) {
			return CONSTRUCTOR;
		}
		else {
			throw IllegalArgumentError("Unknown metadata owner class: " + getQualifiedClassName(owner));
		}
	}
	
	
}

}
