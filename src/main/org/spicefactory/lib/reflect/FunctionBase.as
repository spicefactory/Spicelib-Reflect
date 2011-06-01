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

/**
 * Abstract base class for Function types (Methods and Constructors).
 * 
 * @author Jens Halm
 */
public class FunctionBase extends Member {
	
	
	private var _parameters:Array;
	
	private var minArgs:uint = 0;
	private var maxArgs:uint;
	
	
	/**
	 * @private
	 */
	function FunctionBase (info:Object, owner:ClassInfo) {
		super(info, owner);
	}
	
	private function initParameters () : void {
		if (_parameters) return;
		_parameters = new Array();
		for each (var param:Object in info.parameters) {
			// TODO - check whether param.optional is a Boolean
			_parameters.push(new Parameter(ClassInfo.resolve(param.type, owner.applicationDomain), !param.optional));
			if (!param.optional) minArgs++;
		}
		maxArgs = _parameters.length;
	}
	
	/**
	 * The parameter types of the function represented by this instance.
	 * Each element in the returned Array is an instance of the <code>Parameter</code> class.
	 * 
	 * @return the parameter types of the function represented by this instance
	 */
	public function get parameters () : Array {
		initParameters();
		return _parameters;
	}
	
	/**
	 * Converts the specified parameters to the types expected for this function if necessary.
	 * 
	 * @param params the parameters to convert
	 * @throws MethodInvocationError if the specified number of parameters is invalid for this function
	 * @throws ConversionError if the conversion for one of parameters fails
	 */
	protected function convertParameters (params:Array) : void {
		initParameters();
		if (params.length < minArgs) {
			var message:String = "" + this + " expects at least " + minArgs + " arguments"; 
			throw new ArgumentError(message);
		}
		var numConversions:uint = Math.min(maxArgs, params.length);
		for (var i:uint = 0; i < numConversions; i++) {
			var param:Parameter = parameters[i] as Parameter;
			var value:* = params[i];
			params[i] = Converters.convert(value, param.type.getClass(), param.type.applicationDomain);
		}
	}
	
	
}
}
