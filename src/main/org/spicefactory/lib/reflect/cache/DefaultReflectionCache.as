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
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.reflect.ClassInfo;

import flash.system.ApplicationDomain;
import flash.utils.Dictionary;

/**
 * Default implementation of the ReflectionCache interface.
 * 
 * @author Jens Halm
 */
public class DefaultReflectionCache implements ReflectionCache {

	
	private var cache:Dictionary = new Dictionary();
	
	private var _active:Boolean = true;
	
	
	private function getDomainCache (domain:ApplicationDomain) : DomainCache {
		if (domain == null) domain = ClassInfo.currentDomain;
		return cache[domain] as DomainCache;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addClass (type:ClassInfo, domain:ApplicationDomain = null) : void {
		if (!active) return;
		var domainCache:DomainCache = getDomainCache(domain);
		if (domainCache == null) {
			domainCache = new DomainCache();
			cache[domain] = domainCache;
		}
		domainCache.addClass(type);
	}
	
	/**
	 * @inheritDoc
	 */
	public function getClass (type:Class, domain:ApplicationDomain = null) : ClassInfo {
		var domainCache:DomainCache = getDomainCache(domain);
		return (domainCache == null) ? null : domainCache.getClass(type);
	}
	
	/**
	 * @inheritDoc
	 */
	public function purgeClass (type:Class, domain:ApplicationDomain = null) : void {
		var domainCache:DomainCache = getDomainCache(domain);
		if (domainCache != null) {
			domainCache.purgeClass(type);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function purgeDomain (domain:ApplicationDomain) : void {
		var domainCache:DomainCache = getDomainCache(domain);
		if (domainCache != null) {
			domainCache.purgeAll();
			delete cache[domain];
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function purgeAll () : void {
		for each (var domainCache:DomainCache in cache) {
			domainCache.purgeAll();
		}
		cache = new Dictionary();	
	}
	
	/**
	 * @inheritDoc
	 */
	public function get active () : Boolean {
		return _active;
	}
	
	/**
	 * @inheritDoc
	 */
	public function set active (value:Boolean) : void {
		_active = value;
	}
}
}

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.cache.DefaultReflectionCache;

import flash.utils.Dictionary;

class DomainCache {
	
	private static const log:Logger = LogContext.getLogger(DefaultReflectionCache);
	
	private static var nextDomainNo:int = 1;
	
	private var name:String;
	private var cache:Dictionary = new Dictionary();
	
	function DomainCache () {
		name = "[Domain " + nextDomainNo++ + "]";
	}
	
	public function addClass (type:ClassInfo) : void {
		if (log.isDebugEnabled() && getClass(type.getClass()) == null) {
			log.debug("Add {0} to cache for {1}", type.name, name);
		}
		cache[type.getClass()] = type;
	}
	
	public function getClass (type:Class) : ClassInfo {
		return cache[type] as ClassInfo;
	}
	
	public function purgeClass (type:Class) : void {
		if (log.isDebugEnabled() && getClass(type) == null) {
			log.debug("Purge {0} from cache for {1}", getClass(type).name, name);
		}
		delete cache[type];
	}
	
	public function purgeAll () : void {
		if (log.isDebugEnabled()) {
			log.debug("Purge all classes from cache for {0}", name);
		}
		cache = new Dictionary();
	}
	
	
}
