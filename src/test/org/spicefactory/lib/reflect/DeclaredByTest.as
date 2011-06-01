package org.spicefactory.lib.reflect {
import org.hamcrest.assertThat;
import org.hamcrest.object.sameInstance;
import org.spicefactory.lib.reflect.model.DeclaredBySub;
import org.spicefactory.lib.reflect.model.DeclaredBySuper;

/**
 * @author Jens Halm
 */
public class DeclaredByTest {
	
	
	[Test]
	public function superClass () : void {
		var ci:ClassInfo = ClassInfo.forClass(DeclaredBySuper);
		assertThat(ci.getProperty("someProp").declaredBy, sameInstance(ci));
		assertThat(ci.getMethod("someMethod").declaredBy, sameInstance(ci));
		assertThat(ci.getMethod("otherMethod").declaredBy, sameInstance(ci));
	}
	
	[Test]
	public function subClass () : void {
		var ciSuper:ClassInfo = ClassInfo.forClass(DeclaredBySuper);
		var ci:ClassInfo = ClassInfo.forClass(DeclaredBySub);
		assertThat(ci.getProperty("someProp").declaredBy, sameInstance(ci));
		assertThat(ci.getMethod("someMethod").declaredBy, sameInstance(ci));
		assertThat(ci.getMethod("otherMethod").declaredBy, sameInstance(ciSuper));
	}
	
	
}
}
