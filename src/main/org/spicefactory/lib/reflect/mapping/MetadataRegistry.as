/*
 * Copyright 2010 the original author or authors.
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
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.metadata.AssignableTo;
import org.spicefactory.lib.reflect.metadata.DefaultProperty;
import org.spicefactory.lib.reflect.metadata.EventInfo;
import org.spicefactory.lib.reflect.metadata.MappedMetadata;
import org.spicefactory.lib.reflect.metadata.Required;
import org.spicefactory.lib.reflect.metadata.Types;

import flash.system.ApplicationDomain;

/**
 * The internal registry of all mapped metadata tags.
 * Not intended to be used in application code.
 * 
 * @author Jens Halm
 */
public class MetadataRegistry {
	
	
	private static var _instance:MetadataRegistry;
	
	/**
	 * The singleton instance of the registry.
	 */
	public static function get instance () : MetadataRegistry {
		if (!_instance) {
			_instance = new MetadataRegistry();
		}
		return _instance;
	}
	
	
	private var metadataClasses:Object = new Object();
	private var initialized:Boolean = false;
	private var _modificationCount:int = 1;
	
	
	/**
	 * Registers the specified mapped metadata class.
	 * 
	 * @param metadataClass the mapped class
	 * @param appDomain the ApplicationDomain to use for reflection
	 */
	public function registerClass (metadataClass:Class, appDomain:ApplicationDomain = null) : void {
		if (!initialized) initialize();
		var mapping:MetadataMapping = new MetadataMapping(ClassInfo.forClass(metadataClass, appDomain));
		mapping.init();
		registerMapping(mapping);
		_modificationCount++;
	}
	
	private function registerMapping (mapping:MetadataMapping) : void {
		for each (var key:String in mapping.registrationKeys) {
			metadataClasses[key] = mapping;
		} 
	}

	
	/**
	 * @private
	 */
	internal  function getMapping (name:String, type:String) : MetadataMapping {
		return metadataClasses[name + " " + type] as MetadataMapping;
	}
	
	/**
	 * @private
	 */
	internal function get modificationCount () : int {
		return _modificationCount;
	}

	private function initialize () : void {
		initialized = true;
		createInternalMapping();
		registerClass(DefaultProperty);
		registerClass(Required);
		registerClass(AssignableTo);
		registerClass(EventInfo);
	}
	
	private function createInternalMapping () : void {
		/* The internal [Metadata] tag cannot be created through Reflection
		   as this would lead to a chicken-and-egg problem. */
	    var ci:ClassInfo = ClassInfo.forClass(MappedMetadata);
	    var props:Array = [
    		new MappedProperty(ci.getProperty("name")), 
    		new MappedProperty(ci.getProperty("types")), 
    		new MappedProperty(ci.getProperty("multiple")),
    		new MappedProperty(ci.getProperty("strict"))
	    ];
		var mapping:MetadataMapping = new MetadataMapping(ci);
		mapping.initInternalMapping("Metadata", [Types.CLASS], props);
		registerMapping(mapping);
	}
	
	
}
}
