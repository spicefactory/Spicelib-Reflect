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

package org.spicefactory.lib.reflect.cache {
import org.spicefactory.lib.reflect.ClassInfo;

import flash.system.ApplicationDomain;

/**
 * A reflection cache used by the ClassInfo class for performance optimizations. 
 * 
 * @author Jens Halm
 */
public interface ReflectionCache {
	
	/**
	 * Adds the specified ClassInfo instance to this cache. If the <code>active</code>
	 * flag is set to false, this method does nothing.
	 * 
	 * @param type the ClassInfo instance to add to this cache
	 * @param domain the ApplicationDomain the ClassInfo belongs to
	 */
	function addClass (type:ClassInfo, domain:ApplicationDomain = null) : void;

	/**
	 * Returns the matching ClassInfo instance for the specified class from this cache
	 * or null if no such instance has been cached yet.
	 * 
	 * @param type the class to return the ClassInfo instance for
	 * @param domain the ApplicationDomain the class belongs to
	 * @return the matching ClassInfo instance for the specified class
	 * or null if no such instance has been cached yet
	 */
  	function getClass (type:Class, domain:ApplicationDomain = null) : ClassInfo;

	/**
	 * Removes a single class from the cache. Use this method judiciously, as it might
	 * have the opposite effect that you might expect. If you remove a single ClassInfo
	 * instance that is referenced from other ClassInfo instance (as a property type for example)
	 * than it is still not egligible for garbage collection. Even worse, subsequent calls
	 * to ClassInfo.forClass (or forName etc.) will create a duplicate ClassInfo instance
	 * representing the same class and thus increasing the memory footprint.
	 * 
	 * @param type the class to remove from the cache
	 * @param domain the ApplicationDomain the class belongs to
	 */
  	function purgeClass (type:Class, domain:ApplicationDomain = null) : void;

	/**
	 * Clears the cache for the specified ApplicationDomain.
	 * 
	 * @param domain the domain to clear the reflection cache for
	 */
  	function purgeDomain (domain:ApplicationDomain) : void;

	/**
	 * Clears the entire cache, removing all ClassInfo instances for all ApplicationDomains.
	 */
  	function purgeAll () : void;

	/**
	 * Indicates whether this cache instance is active. If the cache is not active,
	 * no further ClassInfo instances will be added to the cache when <code>addClass</code>
	 * is invoked. Setting this property to false does not clear the existing cached instance.
	 * Use one of the purge methods to clear the cache. 
	 * 
	 * <p>This property may be used to permanently or temporarily disable caching when
	 * reflection operations must be performed on classes which will not be reused afterwards.</p> 
	 */
  	function get active () : Boolean;

  	function set active (value:Boolean) : void;
	
	
}
}
