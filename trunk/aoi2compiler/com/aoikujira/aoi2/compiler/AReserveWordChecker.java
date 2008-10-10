package com.aoikujira.aoi2.compiler;

import com.aoikujira.utils.IntegerHashtable;


public class AReserveWordChecker {
	
	private IntegerHashtable tables;
	private static AReserveWordChecker _instance = null;
	public static AReserveWordChecker getInstance() {
		if (_instance == null) {
			_instance = new AReserveWordChecker();
		}
		return _instance;
	}
	public static Integer convert(String key) {
		AReserveWordChecker i = AReserveWordChecker.getInstance();
		return i.tables.getInteger(key);
	}
	
	private AReserveWordChecker() {
		initTable();
	}
	
	private void initTable() {
		tables = new IntegerHashtable();
	}
}
