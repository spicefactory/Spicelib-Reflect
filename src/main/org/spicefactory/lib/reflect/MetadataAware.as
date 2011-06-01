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
import org.spicefactory.lib.reflect.mapping.MemberTagMap;

/**
 * Base class for all types that can have associated metadata tags.
 * 
 * @author Jens Halm
 */
public class MetadataAware {
	
	
	private var tagMap:MemberTagMap;
	private var _info:Object;
	
	
	/**
	 * @private
	 */
	function MetadataAware (info:Object) {
		_info = info;
	}


	/**
	 * @private
	 */
	protected function get info () : Object {
		return _info;
	}

	/**
	 * @private
	 */
	protected function set info (info:Object) : void {
		_info = info;
	}
	
	/**
	 * Indicates whether this element has at least one metadata tag of the specified type.
	 * 
	 * <p>In case you registered a custom metadata class for the specified name,
	 * you must use a parameter of type <code>Class</code> specifying the mapped metadata class. 
	 * Otherwise you use the name of the metadata tag as a String for the type parameter.</p>
	 * 
	 * @param type for mapped metadata the mapped class otherwise the name of the metadata tag as a String.
	 * @return true if this element has at least one metadata tag of the specified type
	 */
	public function hasMetadata (type:Object) : Boolean {
		initMetadata();
		return (tagMap.hasMetadata(type));
	}
	
	/**
	 * Returns all metadata tags for the specified type for this element.
	 * If no tag for the specified type exists an empty Array will be returned.
	 * 
	 * <p>In case you registered a custom metadata class for the specified name,
	 * an Array of instances of that class is returned. You must use a parameter
	 * of type <code>Class</code> specifying the mapped metadata class for the <code>type</code>
	 * parameter then.</p> 
	 * 
	 * <p>Otherwise an Array
	 * of instances of the generic <code>Metadata</code> class is returned.
	 * In this case you use the name of the metadata tag as a String for the type parameter.</p>
	 * 
	 * @param type for mapped metadata the mapped class otherwise the name of the metadata tag as a String.
	 * @param validate whether the returned objects should be validated (applies only for metadata mapped to custom classes)
	 * @return all metadata tags for the specified type for this element
	 */
	public function getMetadata (type:Object, validate:Boolean = true) : Array {
		initMetadata();
		return tagMap.getMetadata(type, validate);
	}
	
	/**
	 * Returns all metadata tags for this type in no particular order.
	 * 
	 * @param validate whether the returned objects should be validated (applies only for metadata mapped to custom classes)
	 * @return all metadata tags for this type
	 */
	public function getAllMetadata (validate:Boolean = true) : Array {
		initMetadata();
		return tagMap.getAllMetadata(validate);
	}
	
	private function initMetadata () : void {
		if (tagMap) return;
		tagMap = (info.metadata) ? new MemberTagMap(info.metadata, this) : MemberTagMap.EMPTY;
	}
	
	
}
}
