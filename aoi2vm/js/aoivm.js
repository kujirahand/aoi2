/**
 * aoivm.js
 */

if (typeof aoivm == "undefined") {

// global object aoivm
var aoivm = {
  VERSION: 1000,
};

aoivm.error = function (message) {
  alert("[ERROR]" + message);
};

aoivm.run = function (vmcode_json) {
  var mac = new Stackmachine(vmcode_json);
  mac.run();
  return mac;
};


// IRCode class
function IRCode() {
  this.name  = "unknown";
  this.value = null;
  this.f     = null;
};

//--------------------------------------------------------------------
// AValue class
function AValue() {}
AValue.NULL = 0;
AValue.INT  = 1;
AValue.NUM  = 2;
AValue.STR  = 3;
AValue.ARRAY = 4;
AValue.HASH  = 5;
AValue.FUNC  = 6;
AValue.getType = function (v) {
  var t = typeof(v);
  if (t == "number") return AValue.NUM;
  if (t == "string") return AValue.STR;
  if (v instanceof Array)  return AValue.ARRAY;
  if (v instanceof Object) return AValue.HASH;
  return AValue.NULL;
};

//--------------------------------------------------------------------

function ALocalFrame() {
  this.vars = new Array();
  this.return_index = -1;
  this.vars[0] = new AValue(AValue.typeUnknown, null); // it
}

function AFunctionArg(mac) {
  this.result = null;
  this.args = new Array();
  this.mac = mac;
}

//--------------------------------------------------------------------
// Stackmachine class
function Stackmachine(maincode_json) { // constructor
  // property
  this.ir    = new Array();
  this.stack = new Array();
  this.framestack = new Array();
  this.cur_code = null;
  this.globalvars = new Array();
  this.flag_quit = false;
  this.index = 0;
  this.localframe = new ALocalFrame();
  this.framestack.push( this.localframe );
  // main
  this.setMainCode(maincode_json);
}

Stackmachine.prototype.setMainCode = function (vmcode) {
  if (vmcode.type != "aoi") { aoivm.error("Main code not supported.") }
  this.string_table = vmcode.string_table;
  this.func_table   = vmcode.func_table;
  this.module_table = vmcode.module_table;
  this.setIRCode(vmcode.ir);
}

Stackmachine.prototype.setIRCode = function (ir_str) {
  var ls = ir_str.split(",");
  for (var i = 0; i < ls.length; i++) {
    var cur  = ls[i];
    var code = new IRCode();
    var ch = cur.charAt(0);
    cur = cur.substr(1, cur.length - 1);
    code.f    = vmtable.ftable[ch];
    code.name = vmtable.ntable[ch];
    if (cur.indexOf(".") > 0) {
      code.value = parseFloat(cur);
    } else {
      code.value = parseInt(cur);
    }
    this.ir[i] = code;
  }
};

Stackmachine.prototype.run = function () {
  var oldindex = this.index;
  while (this.index < this.ir.length) {
    // check exit
    if (this.flag_quit) break;
    if (this.index < 0) break;
    // prepare
    this.cur_code = this.ir[this.index];
    console.log("run:"+this.index+":"+this.cur_code.name+":"+this.cur_code.value);
    // run
    this.cur_code.f(this, this.cur_code.value);
    // next
    if (this.index == oldindex) { this.index++; }
    oldindex = this.index;
  }
};

Stackmachine.prototype.stack_push = function (v) {
  this.stack.push(v);
  console.log("push=" + v.toString());
};
Stackmachine.prototype.stack_pop = function () {
  var v = this.stack.pop();
  console.log("pop=" + v.toString());
  return v;
};

//--------------------------------------------------------------------
// stackmachine function
Stackmachine.run_NOP = function (mac, arg) {
    // NOP
};
Stackmachine.run_PUSH_NULL = function (mac, arg) {
  mac.stack_push(null);
};
Stackmachine.run_CONST_INT = function (mac, arg) {
  mac.stack_push(new Number(arg));
};
Stackmachine.run_CONST_NUM = function (mac, arg) {
  mac.stack_push(new Number(arg));
};
Stackmachine.run_CONST_STR = function (mac, arg) {
  mac.stack_push(new String(this.string_table[arg]));
};
Stackmachine.run_LOAD = function (mac, arg) {
  // todo: run_LOAD
};
Stackmachine.run_LOAD_LOCAL = function (mac, arg) {
  // todo: run_LOAD_LOCAL
};
Stackmachine.run_GET_HASH = function (mac, arg) {
  // todo: run_GET_HASH
};
Stackmachine.run_STORE = function (mac, arg) {
  // todo: run_STORE
};
Stackmachine.run_STORE_LOCAL = function (mac, arg) {
  // todo: run_STORE_LOCAL
};
Stackmachine.run_LET = function (mac, arg) {
  // todo: run_LET
};
Stackmachine.run_POP = function (mac, arg) {
  // todo: run_POP
};
Stackmachine.run_ADD = function (mac, arg) {
  // todo: run_ADD
};
Stackmachine.run_SUB = function (mac, arg) {
  // todo: run_SUB
};
Stackmachine.run_MUL = function (mac, arg) {
  // todo: run_MUL
};
Stackmachine.run_DIV = function (mac, arg) {
  // todo: run_DIV
};
Stackmachine.run_MOD = function (mac, arg) {
  // todo: run_MOD
};
Stackmachine.run_ADDSTR = function (mac, arg) {
  // todo: run_ADDSTR
};
Stackmachine.run_GT = function (mac, arg) {
  // todo: run_GT
};
Stackmachine.run_GTEQ = function (mac, arg) {
  // todo: run_GTEQ
};
Stackmachine.run_LT = function (mac, arg) {
  // todo: run_LT
};
Stackmachine.run_LTEQ = function (mac, arg) {
  // todo: run_LTEQ
};
Stackmachine.run_EQEQ = function (mac, arg) {
  // todo: run_EQEQ
};
Stackmachine.run_NOTEQ = function (mac, arg) {
  // todo: run_NOTEQ
};
Stackmachine.run_NOT = function (mac, arg) {
  // todo: run_NOT
};
Stackmachine.run_AND = function (mac, arg) {
  // todo: run_AND
};
Stackmachine.run_OR = function (mac, arg) {
  // todo: run_OR
};
Stackmachine.run_RET = function (mac, arg) {
  // todo: run_RET
};
Stackmachine.run_JUMP = function (mac, arg) {
  // todo: run_JUMP
};
Stackmachine.run_JUMP_ZERO = function (mac, arg) {
  // todo: run_JUMP_ZERO
};
Stackmachine.run_JUMP_NON_ZERO = function (mac, arg) {
  // todo: run_JUMP_NON_ZERO
};
Stackmachine.run_CALL_USR = function (mac, arg) {
  // todo: run_CALL_USR
};
Stackmachine.run_CALL_LIB = function (mac, arg) {
  // todo: run_CALL_LIB
};
Stackmachine.run_EXIT = function (mac, arg) {
  // todo: run_EXIT
};
Stackmachine.run_EOL = function (mac, arg) {
  // todo: run_EOL
};
//--------------------------------------------------------------------




//--------------------------------------------------------------------
// vmtable
var vmtable = {
  ftable:{},
  ntable:{},
  init: function (mac) {
    var chk = function (name, a) { if (typeof a == "undefined") { console.log("ir.link.error=" + name); } return a; }
    var ftable = this.ftable;
    var ntable = this.ntable;
    ftable["_"] = chk("NOP",Stackmachine.run_NOP);
    ntable["_"] = "NOP";
    ftable["b"] = chk("PUSH_NULL",Stackmachine.run_PUSH_NULL);
    ntable["b"] = "PUSH_NULL";
    ftable["i"] = chk("CONST_INT",Stackmachine.run_CONST_INT);
    ntable["i"] = "CONST_INT";
    ftable["n"] = chk("CONST_NUM",Stackmachine.run_CONST_NUM);
    ntable["n"] = "CONST_NUM";
    ftable["s"] = chk("CONST_STR",Stackmachine.run_CONST_STR);
    ntable["s"] = "CONST_STR";
    ftable["d"] = chk("LOAD",Stackmachine.run_LOAD);
    ntable["d"] = "LOAD";
    ftable["D"] = chk("LOAD_LOCAL",Stackmachine.run_LOAD_LOCAL);
    ntable["D"] = "LOAD_LOCAL";
    ftable["h"] = chk("GET_HASH",Stackmachine.run_GET_HASH);
    ntable["h"] = "GET_HASH";
    ftable["t"] = chk("STORE",Stackmachine.run_STORE);
    ntable["t"] = "STORE";
    ftable["T"] = chk("STORE_LOCAL",Stackmachine.run_STORE_LOCAL);
    ntable["T"] = "STORE_LOCAL";
    ftable["="] = chk("LET",Stackmachine.run_LET);
    ntable["="] = "LET";
    ftable["p"] = chk("POP",Stackmachine.run_POP);
    ntable["p"] = "POP";
    ftable["+"] = chk("ADD",Stackmachine.run_ADD);
    ntable["+"] = "ADD";
    ftable["-"] = chk("SUB",Stackmachine.run_SUB);
    ntable["-"] = "SUB";
    ftable["*"] = chk("MUL",Stackmachine.run_MUL);
    ntable["*"] = "MUL";
    ftable["/"] = chk("DIV",Stackmachine.run_DIV);
    ntable["/"] = "DIV";
    ftable["%"] = chk("MOD",Stackmachine.run_MOD);
    ntable["%"] = "MOD";
    ftable["&"] = chk("ADDSTR",Stackmachine.run_ADDSTR);
    ntable["&"] = "ADDSTR";
    ftable[">"] = chk("GT",Stackmachine.run_GT);
    ntable[">"] = "GT";
    ftable["G"] = chk("GTEQ",Stackmachine.run_GTEQ);
    ntable["G"] = "GTEQ";
    ftable["<"] = chk("LT",Stackmachine.run_LT);
    ntable["<"] = "LT";
    ftable["L"] = chk("LTEQ",Stackmachine.run_LTEQ);
    ntable["L"] = "LTEQ";
    ftable["e"] = chk("EQEQ",Stackmachine.run_EQEQ);
    ntable["e"] = "EQEQ";
    ftable["o"] = chk("NOTEQ",Stackmachine.run_NOTEQ);
    ntable["o"] = "NOTEQ";
    ftable["!"] = chk("NOT",Stackmachine.run_NOT);
    ntable["!"] = "NOT";
    ftable["A"] = chk("AND",Stackmachine.run_AND);
    ntable["A"] = "AND";
    ftable["O"] = chk("OR",Stackmachine.run_OR);
    ntable["O"] = "OR";
    ftable["r"] = chk("RET",Stackmachine.run_RET);
    ntable["r"] = "RET";
    ftable["J"] = chk("JUMP",Stackmachine.run_JUMP);
    ntable["J"] = "JUMP";
    ftable["Z"] = chk("JUMP_ZERO",Stackmachine.run_JUMP_ZERO);
    ntable["Z"] = "JUMP_ZERO";
    ftable["N"] = chk("JUMP_NON_ZERO",Stackmachine.run_JUMP_NON_ZERO);
    ntable["N"] = "JUMP_NON_ZERO";
    ftable["u"] = chk("CALL_USR",Stackmachine.run_CALL_USR);
    ntable["u"] = "CALL_USR";
    ftable["l"] = chk("CALL_LIB",Stackmachine.run_CALL_LIB);
    ntable["l"] = "CALL_LIB";
    ftable["q"] = chk("EXIT",Stackmachine.run_EXIT);
    ntable["q"] = "EXIT";
    ftable["~"] = chk("EOL",Stackmachine.run_EOL);
    ntable["~"] = "EOL";
    // end of table
  }// end of function init
}// end of class

//--------------------------------------------------------------------
// vmtable.init
vmtable.init();
//--------------------------------------------------------------------




//----------------------------------------------------------------------
}// end of if (aoivm)
//----------------------------------------------------------------------

