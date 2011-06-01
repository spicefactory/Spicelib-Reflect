/*
 * Copyright 2007 the original author or authors.
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

import flash.utils.getQualifiedClassName;

/**
 * Represents a single method.
 * 
 * @author Jens Halm
 */
public class Method	extends FunctionBase {


	private var _isStatic:Boolean;
	
	
	/**
	 * @private
	 */
	function Method (info:Object, isStatic:Boolean, owner:ClassInfo) {
		super(info, owner);
		_isStatic = isStatic;
	}
	

	/**
	 * Determines if the method represented by this instance is static.
	 * 
	 * @return true if the method represented by this instance is static
	 */
	public function get isStatic () : Boolean {
		return _isStatic;
	}
	
	/**
	 * Returns the return type of the method represented by this instance.
	 * The return type <code>&#42;</code> is represented by the <code>Any</code> class and
	 * the return type void is represented by the <code>Void</code> class, both members
	 * of the <code>org.spicefactory.lib.reflect.types</code> package. All other return types
	 * are represented by their corresponding Class instance.
	 * 
	 * @return the return type of the method represented by this instance
	 */
	public function get returnType () : ClassInfo {
		if (info.returnType is String) {
			info.returnType = ClassInfo.resolve(info.returnType, owner.applicationDomain);
		}
		return info.returnType;
	}
	
	/**
	 * Invokes the method represented by this instance on the specified target instance.
	 * If necessary, parameters will be automatically converted to the required type if
	 * a matching Converter is registered for the parameter type.
	 * 
	 * @param instance the instance to invoke the method on.
	 * @param params the parameters to pass to the method
	 * @return the return value of the method that gets invoked
	 * @throws org.spicefactory.lib.reflect.errors.ConversionError if one of the specified parameters
	 * is not of the required type and can not be converted
	 * @throws org.spicefactory.lib.reflect.errors.MethodInvocationError 
	 * if the specified target instance is not of the required type
	 * @throws Error any Error thrown by the target method will not be catched by this method
	 */
	public function invoke (instance:Object, params:Array) : * {
		checkInstanceParameter(instance);
		convertParameters(params);
		var qname:Object = (namespaceURI) ? new QName(namespaceURI, name) : name;
		var f:Function = (_isStatic) ? owner.getClass()[qname] : instance[qname];
		try {
			return f.apply(instance, params);
		}
		catch (e:ArgumentError) {
			throw new MethodInvocationError(e.message, e);
		}
	}
	
	private function checkInstanceParameter (instance:Object) : void {
		if (_isStatic) {
			if (instance != null) {
				throw new MethodInvocationError("Instance parameter must be null for static methods");
			}
		} else {
			if (instance == null) {
				throw new MethodInvocationError("Instance parameter must not be null for non-static methods");
			} else if (!(instance is owner.getClass())) {
				throw new MethodInvocationError("Instances must be of type " + getQualifiedClassName(owner));
			}
		}		
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[Method " + name + " in class " + owner.name + "]";
	}


}

}