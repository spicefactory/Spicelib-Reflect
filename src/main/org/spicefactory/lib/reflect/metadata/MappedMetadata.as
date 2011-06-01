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

[Metadata(name="Metadata", types="class")]
/**
 * Represents a metadata tag that marks a class as a mapped metadata class.
 * These classes can be registered with <code>Metadata.registerMetadataClass</code>.
 * For any mapped metadata class metadata tags in AS3 classes will be mapped to instances
 * of that class, automatically mapping metadata attributes to properties of the mapped class
 * including automatic type conversion if necessary.
 * 
 * @author Jens Halm
 */
public class MappedMetadata {
	

	/**
	 * The types for which this Metadata tag should be processed. 
	 * Valid values are <code>class</code>, <code>constructor</code>,
	 * <code>property</code> or <code>method</code>. If not specified
	 * the metadata is processed for all types. For other types the
	 * metadata will be represented by the generic <code>Metadata</code>
	 * class and not be mapped to a custom class.
	 * 
	 * <p>The <code>constructor</code> type is included for future use.
	 * Currently the Flex SDK compiler ignores all metadata tags placed on constructors.</p>
	 */
	public var types:Array;
	
	/**
	 * The name of the metadata tag. If not specified the name is the non-qualifed class name
	 * of the mapped class.
	 */
	public var name:String;
	
	/**
	 * Determines whether the mapped metadata tag is allowed to appear multiple times on the same element.
	 */
	public var multiple:Boolean = false;
	
	/**
	 * Determines whether the mapped metadata tag should cause an Error to be thrown 
	 * when it contains one or more attributes that do not map to a property of the mapped class. 
	 */
	public var strict:Boolean = true;
	
	
}

}
