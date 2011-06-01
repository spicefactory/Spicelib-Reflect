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
 * Provides reflection information for a particular type.
 * This interface abstracts the actual mechanism used under the hood (e.g. the old XML-based describeType or 
 * the newer JSON based one).
 * 
 * @author Jens Halm
 */
public interface ClassInfoProvider {
	
	/**
	 * The information about static properties and methods.
	 * The format of the untyped object is identical with the format used in <code>describeTypeJSON</code> 
	 * in Flash Player 10.1 or newer.
	 */
	function get staticInfo () : Object;
	
	/**
	 * The reflection information about the instance.
	 * The format of the untyped object is identical with the format used in <code>describeTypeJSON</code> 
	 * in Flash Player 10.1 or newer.
	 */
	function get instanceInfo () : Object;
	
}
}
