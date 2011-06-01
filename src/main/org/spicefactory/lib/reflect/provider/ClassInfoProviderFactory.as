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
import org.spicefactory.lib.util.Flag;
import avmplus.DescribeTypeJSONAccessor;

/**
 * Factory that creates ClassInfoProvider instances based on the capabilities of the Flash Player.
 * In Player 10.1 or newer providers will use the <code>describeTypeJSON</code> function under the hood,
 * in older players the XML-based <code>describeType</code> will be used.
 * 
 * @author Jens Halm
 */
public class ClassInfoProviderFactory {
	
	
	private static var hasJSON:Flag;
	private static var describeTypeJSON:Function;
	private static var staticFlags:int;
	private static var instanceFlags:int;
	
	/**
	 * Creates a new ClassInfoProvider based on the capabilities of the Flash Player.
	 * 
	 * @param type the type to reflect on
	 * @return a new ClassInfoProvider based on the capabilities of the Flash Player
	 */
	public function newProvider (type:Class) : ClassInfoProvider {
		if (!hasJSON) {
			initJSON();
		}
		return (hasJSON.value) 
				? new JsonClassInfoProvider(type, describeTypeJSON, staticFlags, instanceFlags)
				: new XmlClassInfoProvider(type);
	}
	
	private function initJSON () : void {
		describeTypeJSON = DescribeTypeJSONAccessor.functionRef;
		hasJSON = new Flag(describeTypeJSON != null);
		if (hasJSON.value) {
			staticFlags = DescribeTypeJSONAccessor.staticFlags;
			instanceFlags = DescribeTypeJSONAccessor.instanceFlags;
		}
	}
	
	
}
}
