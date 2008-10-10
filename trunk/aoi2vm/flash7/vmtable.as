/**
 * vmtable.as
 */

class vmtable
{
  static var ftable:Array;
  static var ntable:Object;
  static function init() {
    ftable = new Array();
    ntable = new Object();
    ftable[95] = Stackmachine.run_NOP;//"_"
    ntable[95] = "NOP";
    ftable[98] = Stackmachine.run_PUSH_NULL;//"b"
    ntable[98] = "PUSH_NULL";
    ftable[105] = Stackmachine.run_CONST_INT;//"i"
    ntable[105] = "CONST_INT";
    ftable[110] = Stackmachine.run_CONST_NUM;//"n"
    ntable[110] = "CONST_NUM";
    ftable[115] = Stackmachine.run_CONST_STR;//"s"
    ntable[115] = "CONST_STR";
    ftable[100] = Stackmachine.run_LOAD;//"d"
    ntable[100] = "LOAD";
    ftable[68] = Stackmachine.run_LOAD_LOCAL;//"D"
    ntable[68] = "LOAD_LOCAL";
    ftable[104] = Stackmachine.run_GET_HASH;//"h"
    ntable[104] = "GET_HASH";
    ftable[116] = Stackmachine.run_STORE;//"t"
    ntable[116] = "STORE";
    ftable[84] = Stackmachine.run_STORE_LOCAL;//"T"
    ntable[84] = "STORE_LOCAL";
    ftable[61] = Stackmachine.run_LET;//"="
    ntable[61] = "LET";
    ftable[112] = Stackmachine.run_POP;//"p"
    ntable[112] = "POP";
    ftable[43] = Stackmachine.run_ADD;//"+"
    ntable[43] = "ADD";
    ftable[45] = Stackmachine.run_SUB;//"-"
    ntable[45] = "SUB";
    ftable[42] = Stackmachine.run_MUL;//"*"
    ntable[42] = "MUL";
    ftable[47] = Stackmachine.run_DIV;//"/"
    ntable[47] = "DIV";
    ftable[37] = Stackmachine.run_MOD;//"%"
    ntable[37] = "MOD";
    ftable[38] = Stackmachine.run_ADDSTR;//"&"
    ntable[38] = "ADDSTR";
    ftable[62] = Stackmachine.run_GT;//">"
    ntable[62] = "GT";
    ftable[71] = Stackmachine.run_GTEQ;//"G"
    ntable[71] = "GTEQ";
    ftable[60] = Stackmachine.run_LT;//"<"
    ntable[60] = "LT";
    ftable[76] = Stackmachine.run_LTEQ;//"L"
    ntable[76] = "LTEQ";
    ftable[101] = Stackmachine.run_EQEQ;//"e"
    ntable[101] = "EQEQ";
    ftable[111] = Stackmachine.run_NOTEQ;//"o"
    ntable[111] = "NOTEQ";
    ftable[33] = Stackmachine.run_NOT;//"!"
    ntable[33] = "NOT";
    ftable[65] = Stackmachine.run_AND;//"A"
    ntable[65] = "AND";
    ftable[79] = Stackmachine.run_OR;//"O"
    ntable[79] = "OR";
    ftable[114] = Stackmachine.run_RET;//"r"
    ntable[114] = "RET";
    ftable[74] = Stackmachine.run_JUMP;//"J"
    ntable[74] = "JUMP";
    ftable[90] = Stackmachine.run_JUMP_ZERO;//"Z"
    ntable[90] = "JUMP_ZERO";
    ftable[78] = Stackmachine.run_JUMP_NON_ZERO;//"N"
    ntable[78] = "JUMP_NON_ZERO";
    ftable[117] = Stackmachine.run_CALL_USR;//"u"
    ntable[117] = "CALL_USR";
    ftable[108] = Stackmachine.run_CALL_LIB;//"l"
    ntable[108] = "CALL_LIB";
    ftable[113] = Stackmachine.run_EXIT;//"q"
    ntable[113] = "EXIT";
    ftable[126] = Stackmachine.run_EOL;//"~"
    ntable[126] = "EOL";
    ftable[119] = Stackmachine.run_POWER;//"w"
    ntable[119] = "POWER";
    // end of table
  }// end of function init
}// end of class
