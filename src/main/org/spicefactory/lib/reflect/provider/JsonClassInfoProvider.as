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

package org.spicefactory.lib.reflect.provider {

/**
 * ClassInfoProvider that uses the describeTypeJSON function under the hood.
 * This provider requires Flash Player 10.1 or newer. For older players
 * the reflection API will automatically fall back to using the <code>XmlClassInfoProvider</code>.
 * 
 * @author Jens Halm
 */
public class JsonClassInfoProvider implements ClassInfoProvider {

	
	private var type:Class;
	
	private var functionRef:Function;
	private var staticFlags:int;
	private var instanceFlags:int;
	
	private var _staticInfo:Object;
	private var _instanceInfo:Object;
	
	/**
	 * Creates a new instance.
	 * 
	 * @param type the type to reflect upon
	 */
	function JsonClassInfoProvider (type:Class, functionRef:Function, staticFlags:int, instanceFlags:int) {
		this.type = type;
		this.functionRef = functionRef;
		this.staticFlags = staticFlags;
		this.instanceFlags = instanceFlags;
	}

	public function get staticInfo () : Object {
		if (!_staticInfo) {
			_staticInfo = functionRef(type, staticFlags);
		}
		return _staticInfo;
	}
	
	public function get instanceInfo () : Object {
		if (!_instanceInfo) {
			_instanceInfo = functionRef(type, instanceFlags);
		}
		return _instanceInfo;
	}
	
	
}
}
