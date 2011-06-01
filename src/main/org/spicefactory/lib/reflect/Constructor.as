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
import org.spicefactory.lib.reflect.errors.MethodInvocationError;
import org.spicefactory.lib.util.ClassUtil;

/**
 * Represents a Constructor.
 * 
 * @author Jens Halm
 */
public class Constructor extends FunctionBase {


	/**
	 * @private
	 */
	function Constructor (params:Array, owner:ClassInfo) {
		super({parameters:params, name:owner.simpleName}, owner);
	}
	

	/**
	 * Creates a new instance of the class this constructor belongs to.
	 * 
	 * @param params the parameters to pass to the constructor
	 * @return a new instance of the class this constructor belongs to
	 *
	 * @throws org.spicefactory.lib.reflect.errors.ConversionError if one of the specified parameters
	 * is not of the required type and can not be converted
	 * @throws org.spicefactory.lib.reflect.errors.MethodInvocationError 
	 * if the specified number of parameters is not valid for this constructor
	 * @throws Error any Error thrown by the constructor will not be catched by this method
	 */
	public function newInstance (params:Array) : * {
		convertParameters(params);
		try {
			return ClassUtil.createNewInstance(owner.getClass(), params);
		}
		catch (e:ArgumentError) {
			throw new MethodInvocationError(e.message, e);
		}
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[Constructor in class " + owner.name + "]";
	}
	
	
}

}
