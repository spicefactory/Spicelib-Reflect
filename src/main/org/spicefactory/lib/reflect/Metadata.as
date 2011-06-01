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

package org.spicefactory.lib.reflect {
import org.spicefactory.lib.reflect.mapping.MetadataRegistry;

import flash.system.ApplicationDomain;

/**
 * Represents a single metadata tag associated with a class, property or method declaration.
 * 
 * @author Jens Halm
 */
public class Metadata {
	
	
	private var _name:String;
	private var _arguments:Object;
	
	
	/**
	 * @private
	 */
	function Metadata (name:String, args:Object) {
		_name = name;
		_arguments = args;
	}
	
	/**
	 * Registers a custom Class for representing metadata tags.
	 * If no custom Class is registered for a particular tag an instance of this generic <code>Metadata</code>
	 * class will be used to represent the tag and its arguments. For type-safe access to such
	 * tags a custom Class can be registered. In this case the arguments of the metadata tag
	 * will be mapped to the corresponding properties with the same name. Type conversion occurs 
	 * automatically if necessary. If the builtin basic Converters are not sufficient for a particular
	 * type you can register custom <code>Converter</code> instances with the <code>Converters</code>
	 * class. Arguments on the metadata tag without a matching property will be silently ignored. 
	 * 
	 * <p>The specified metadata class should be annotated itself with a <code>[Metadata]</code> tag.
	 * See the documentation for the <code>MappedMetadata</code> class for details.</p>
	 * 
	 * @param metadataClass the custom Class to use for representing that tag
	 * @param appDomain the ApplicationDomain to use for loading classes when reflecting on the specified 
	 * Metadata class
	 */
	public static function registerMetadataClass (metadataClass:Class, 
			appDomain:ApplicationDomain = null) : void {
		MetadataRegistry.instance.registerClass(metadataClass, appDomain);
	}
	
	/**
	 * The name of the metadata tag.
	 */
	public function get name () : String {
		return _name;
	}
	
	/**
	 * Returns the argument for the specified key as a String or null if no such argument exists.
	 * 
	 * @return the argument for the specified key as a String or null if no such argument exists
	 */
	public function getArgument (key:String) : String {
		return _arguments[key];
	} 
	

	/**
	 * Returns the default argument as a String or null if no such argument exists.
	 * The default argument is the value that was specified without an excplicit key (e.g.
	 * <code>[Meta("someValue")]</code> compared to <code>[Meta(key="someValue")]</code>).
	 * 
	 * @return the default argument as a String or null if no such argument exists
	 */
	public function getDefaultArgument () : String {
		return _arguments[""];
	} 
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[Metadata name=" + name + "]";
	}
	
	
}
}

