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

package org.spicefactory.lib.reflect.metadata {
import flash.system.ApplicationDomain;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Member;
import org.spicefactory.lib.reflect.Property;


import flash.utils.Dictionary;

/**
 * Utility method to set the member name for a property or method with a metadata tag.
 * 
 * @author Jens Halm
 */
public class TargetPropertyUtil {
	
	
	private static const targetPropertyMap:Dictionary = new Dictionary(true);
	
	
	/**
	 * Locates the property marked with the <code>[Target]</code> metadata tag in the specified
	 * metadata object to the name of the specified member (property or method).
	 * 
	 * @param member the member whose name should be applied to the metadata object
	 * @param metadata the metadata object to apply the member name to
	 * @param domain the ApplicationDomain to use for reflection
	 */
	public static function setPropertyName (member:Member, metadata:Object, domain:ApplicationDomain = null) : void {
		var ci:ClassInfo = ClassInfo.forInstance(metadata, domain);
		var target:* = targetPropertyMap[ci.getClass()];
		if (target == undefined) {
			for each (var property:Property in ci.getProperties()) {
				if (property.getMetadata(Target).length > 0) {
					if (!property.writable) {
						target = new Error(property.toString() + " was marked with [Target] but is not writable");
					}
					else if (!property.type.isType(String)) {
						target = new Error(property.toString() + " was marked with [Target] but is not of type String");
					}
					else {
						target = property;
					}
					break; 
				}
			}
			if (target == null) {
				target = new Error("No property marked with [Target] in class " + ci.name);
			}
			// we also cache errors so we do not process the same class twice
			targetPropertyMap[ci.getClass()] = target;
		}
		if (target is Property) {
			Property(target).setValue(metadata, member.name);
		}
		else {
			throw new IllegalStateError(Error(target).message);
		}					
	}
	
	
}
}
