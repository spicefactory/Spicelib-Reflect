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

[Metadata(name="Event", types="class", multiple="true", strict="false")]
/**
 * Represent a single Event metadata tag.
 * 
 * @author Jens Halm
 */
public class EventInfo {
	
	
	/**
	 * The name of the event.
	 */
	[Required]
	[DefaultProperty]
	public var name:String;
	
	/**
	 * The type of the event (a fully qualified class name).
	 */
	public var type:String = "";
	
	
}

}
