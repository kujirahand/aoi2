﻿
	public static var PHIDSPEC_GPS:Number = 0x1F
	public static var PHIDSPEC_ENCODER_HS:Number = 0x20
	public static var PHIDSPEC_UNIPOLAR_STEPPER:Number = 0x21
	public static var PHIDSPEC_BIPOLAR_STEPPER:Number = 0x22
	public static var PHIDSPEC_JOYSTICK:Number = 0x23
	public static var PHIDSPEC_TEXTLCD_with_888:Number = 0x24
	public static var PHIDSPEC_888_with_lcd:Number = 0x25
	[PHIDDEF_ENCODER,			0x6C2,0x0078,4,4,0], //4 encoder
	[PHIDDEF_GPS,				0x6C2,0x0079,1,0,0], 
	[PHIDDEF_ENCODER,			0x6C2,0x0080,1,0,0], //high speed encoder
	[PHIDDEF_STEPPER,			0x6C2,0x007A,4,0,0], //unipolar stepper
	[PHIDDEF_STEPPER,			0x6C2,0x007B,1,0,0],
	[PHIDDEF_INTERFACEKIT,		0x6C2,0x007C,2,1,0], //joystick
	[PHIDDEF_TEXTLCD,			0x6C2,0x007D,2,20,0], //TextLCD 8/8/8 Composite Device
	[PHIDDEF_INTERFACEKIT,		0x6C2,0x007D,8,8,8]]; //linear touch sensor