package org.spicefactory.lib.reflect {
import org.flexunit.assertThat;
import org.hamcrest.number.closeTo;
import org.hamcrest.object.sameInstance;
import org.hamcrest.object.strictlyEqualTo;
import org.spicefactory.lib.reflect.converter.BooleanConverter;
import org.spicefactory.lib.reflect.converter.ClassConverter;
import org.spicefactory.lib.reflect.converter.ClassInfoConverter;
import org.spicefactory.lib.reflect.converter.DateConverter;
import org.spicefactory.lib.reflect.converter.IntConverter;
import org.spicefactory.lib.reflect.converter.NumberConverter;
import org.spicefactory.lib.reflect.converter.StringConverter;
import org.spicefactory.lib.reflect.converter.UintConverter;
import org.spicefactory.lib.reflect.model.ClassC;

public class ConverterTest {
	

	[Before]	
	public function setUp () : void {
		//new ClassInfo("String", String, ApplicationDomain.currentDomain); // circumwent Flash Player describeType bug
		ClassInfo.cache.purgeAll();
	}
	

	[Test]
	public function convertInt () : void {
		assertThat(IntConverter.INSTANCE.convert("345"), strictlyEqualTo(345));
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.ConversionError")]
	public function convertIllegalInt () : void {
		IntConverter.INSTANCE.convert("5a");
	}
	
	[Test]
	public function convertUint () : void {
		assertThat(UintConverter.INSTANCE.convert("345"), strictlyEqualTo(345));
	}
	
	[Test]
	public function convertFloatToUint () : void {
		assertThat(UintConverter.INSTANCE.convert("7.8"), strictlyEqualTo(7));
	}
	
	[Test]
	public function convertNegativeToUint () : void {
		assertThat(UintConverter.INSTANCE.convert("-23"), strictlyEqualTo(4294967273));
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.ConversionError")]
	public function convertIllegalUint () : void {
		UintConverter.INSTANCE.convert("5 5");
	}
	
	[Test]
	public function convertNumber () : void {
		assertThat(NumberConverter.INSTANCE.convert("345"), strictlyEqualTo(345));
	}	
	
	[Test]
	public function convertFloatNumber () : void {
		assertThat(NumberConverter.INSTANCE.convert("7.8"), closeTo(7.8, 0.01));
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.ConversionError")]
	public function convertIllegalNumber () : void {
		NumberConverter.INSTANCE.convert("a5");
	}	
	
	[Test]
	public function convertBooleanTrue () : void {
		assertThat(BooleanConverter.INSTANCE.convert("true"), strictlyEqualTo(true));
	}
	
	[Test]
	public function convertBooleanFalse () : void {
		assertThat(BooleanConverter.INSTANCE.convert("false"), strictlyEqualTo(false));
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.ConversionError")]
	public function convertIllegalBoolean () : void {
		BooleanConverter.INSTANCE.convert("hallo");
	}
	
	[Test]
	public function convertString () : void {
		var d:Date = new Date();
		var ds:String = d.toString();
		assertThat(StringConverter.INSTANCE.convert(d), strictlyEqualTo(ds));
	}
	
	[Test]
	public function convertDate () : void {
		var s:String = "2002-12-11";
		var d:Date = DateConverter.INSTANCE.convert(s);
		assertThat(d.fullYear, strictlyEqualTo(2002));
		assertThat(d.month, strictlyEqualTo(11));
		assertThat(d.date, strictlyEqualTo(11));
		assertThat(d.hours, strictlyEqualTo(0));
		assertThat(d.minutes, strictlyEqualTo(0));
		assertThat(d.seconds, strictlyEqualTo(0));
	}
	
	[Test]
	public function convertDateTime () : void {
		var s:String = "2002-12-11 13:17:24";
		var d:Date = DateConverter.INSTANCE.convert(s);
		assertThat(d.fullYear, strictlyEqualTo(2002));
		assertThat(d.month, strictlyEqualTo(11));
		assertThat(d.date, strictlyEqualTo(11));
		assertThat(d.hours, strictlyEqualTo(13));
		assertThat(d.minutes, strictlyEqualTo(17));
		assertThat(d.seconds, strictlyEqualTo(24));
	}
	
	[Test]
	public function convertTime () : void {
		var time:Number = new Date(2002, 11, 11, 13, 17, 24).time;
		var d:Date = DateConverter.INSTANCE.convert(time);
		assertThat(d.fullYear, strictlyEqualTo(2002));
		assertThat(d.month, strictlyEqualTo(11));
		assertThat(d.date, strictlyEqualTo(11));
		assertThat(d.hours, strictlyEqualTo(13));
		assertThat(d.minutes, strictlyEqualTo(17));
		assertThat(d.seconds, strictlyEqualTo(24));
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.ConversionError")]
	public function convertIllegalDate () : void {
		DateConverter.INSTANCE.convert("2009-12-12-15 23,12");
	}
	
	[Test]
	public function convertClass () : void {
		assertThat(ClassConverter.INSTANCE.convert("org.spicefactory.lib.reflect.Property"), sameInstance(Property));
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.ConversionError")]
	public function convertIllegalClass () : void {
		ClassConverter.INSTANCE.convert("org.spicefactory.lib.reflect.Broperty");
	}
	
	[Test]
	public function convertClassInfo () : void {
		var ci:ClassInfo = new ClassInfoConverter().convert("org.spicefactory.lib.reflect.Property");
		assertThat(ci.getClass(), sameInstance(Property));
	}
	
	[Test]
	public function convertClassInfoWithRequiredType () : void {
		var requiredType:ClassInfo = ClassInfo.forClass(ClassC);
		var conv:Converter = new ClassInfoConverter(requiredType);
		var ci:ClassInfo = conv.convert("org.spicefactory.lib.reflect.model.ClassC");
		assertThat(ci.getClass(), sameInstance(ClassC));
	}
	
	[Test(expects="org.spicefactory.lib.reflect.errors.ConversionError")]
	public function convertClassInfoNotOfRequiredType () : void {
		var requiredType:ClassInfo = ClassInfo.forClass(Property);
		new ClassInfoConverter(requiredType).convert("org.spicefactory.lib.reflect.Converter");
	}
	
	
}

}