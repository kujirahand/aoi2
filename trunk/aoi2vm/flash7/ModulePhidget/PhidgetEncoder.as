﻿class PhidgetEncoder extends Phidget {
		for(var i=0;i<numInputs;i++) {
			var temp:Boolean = getBoolean(dataArray[i+1]);
		}
			
		for(var i=0;i<numEncoders;i++) {
			posn  = parseInt(dataArray[numInputs+2*i+2]);
		}