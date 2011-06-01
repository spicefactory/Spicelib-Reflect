package org.spicefactory.lib.reflect.model {
import flash.utils.Proxy;
import flash.utils.flash_proxy;

/**
 * @author Jens Halm
 */
public class TestProxy extends Proxy {
	
	override flash_proxy function getProperty(name:*):*
    {
        throw new Error("Unknown property: " + name);
    }
	
}
}
