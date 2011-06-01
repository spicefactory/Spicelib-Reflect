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
import org.spicefactory.lib.reflect.metadata.Types;
import org.spicefactory.lib.reflect.MetadataAware;
import flash.utils.Dictionary;

/**
 * Represents the metadata tags placed upon a single member of a class.
 * 
 * @author Jens Halm
 */
public class MemberTagMap {
	
	
	private var tagMap:Dictionary;
	private var lastRegistryModCount:int;
	
	public static const EMPTY:MemberTagMap = new MemberTagMap();
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param unresolved the unresolved metadata tags (formatted as returned by describeTypeJSON)
	 * @param owner the member the tags are placed upon
	 */
	function MemberTagMap (unresolved:Array = null, owner:MetadataAware = null) {
		if (unresolved) init(unresolved, owner);
	}
	
	private function init (unresolved:Array, owner:MetadataAware) : void {
		tagMap = new Dictionary();
		for each (var meta:Object in unresolved) {
			var name:String = meta.name;
			var tagList:MemberTagList = tagMap[name];
			if (!tagList) {
				tagList = new MemberTagList(name, Types.forOwner(owner));
				tagMap[name] = tagList;
			}
			tagList.addValue(meta.value);
		}
	}
		
	private function resolve () : void {
		if (MetadataRegistry.instance.modificationCount != lastRegistryModCount) {
			lastRegistryModCount = MetadataRegistry.instance.modificationCount;
			var oldMap:Dictionary = tagMap;
			tagMap = new Dictionary();
			for each (var list:MemberTagList in oldMap) {
				list.resolve();
				tagMap[list.key] = list;
			}	
		}
	}
	
	/**
	 * @copy org.spicefactory.lib.reflect.MetadataAware#hasMetadata()
	 */
	public function hasMetadata (type:Object) : Boolean {
		if (!tagMap) return false;
		resolve();
		return (tagMap[type] != undefined);
	}
	
	/**
	 * @copy org.spicefactory.lib.reflect.MetadataAware#getMetadata()
	 */
	public function getMetadata (type:Object, validate:Boolean) : Array {
		if (!tagMap) return [];
		resolve();
		var list:MemberTagList = tagMap[type] as MemberTagList;
		return (list) ? list.getValues(validate) : [];
	}
	
	/**
	 * @copy org.spicefactory.lib.reflect.MetadataAware#getAllMetadata()
	 */
	public function getAllMetadata (validate:Boolean) : Array {
		if (!tagMap) return [];
		resolve();
		var all:Array = new Array();
		for each (var list:MemberTagList in tagMap) {
			all = all.concat(list.getValues(validate));
		}
		return all;
	}
	
	
}
}
