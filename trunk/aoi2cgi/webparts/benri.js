//--------------------------------------------------------------------
// benri.js
//--------------------------------------------------------------------
// author : kujirahand.com
//--------------------------------------------------------------------
/** Benri --> Element function

var v = $("id_xxx");
Benri.show("id_xxx");
Benri.show($("id_xxx"));
Benri.hide("id_xxx");

*/

/** XMLHttpRequest --> KHttp class

// example
var http = new KHttp();
http.onComplete = function(str) {
  alert("text=" + str);
};
http.onError = function (err, code) {
  alert("error:" + err + ":" + code);
};
http.params["param1"] = "xxx";
http.params["param2"] = "xxx";
http.params["param3"] = "xxx";
http.send("http://example.com/data.php", "POST");

*/


function $(id) {
  if (typeof(id) == "string") {
    return document.getElementById(id);
  }
  else {
    return id;
  }
}

function $F(id) {
  var e = $(id);
  if (e) {
    if (e.type == "checkbox") {
      return e.checked;
    }
    else {
      return e.value;
    }
  }
  else {
    return null;
  }
}

function debug_r(id) {
  var obj = $(id);
  for (var key in obj) {
    try {
      console.debug(key + ":" + obj[key]);
    } catch(e) {}
  }
}

var Benri = {
  version:1003,
  setVisible:function(obj, visible) {
    obj = $(obj);
    obj.style.visibility = (visible) ? "visible" : "hidden";
  },
  show:function(obj) { Benri.setVisible(obj, true); },
  hide:function(obj) { Benri.setVisible(obj, false);},
  setDisplay:function(obj, visible) {
    obj = $(obj);
    obj.style.display = (visible) ? "block" : "none";
  },
  open:function(obj) { Benri.setDisplay(obj, true); },
  close:function(obj) { Benri.setDisplay(obj, false);},
  writeApplet: function(element_id, obj_id, w, h, codebase, code, archive) {
    var o = document.getElementById(element_id);
    o.innerHTML = '<applet id="' + obj_id + '" codebase="' + codebase + '"' +
      ' code="' + code + '" width="' + w + '" height="' + h + '"' +
      ' archive="' + archive + '" mayscript></applet>';
  },
  writeSwf: function(element_id, obj_id, w, h, url) {
    var o = document.getElementById(element_id);
    o.innerHTML = '<object id="'+obj_id+'" width="'+w+'" height="'+h+'">' +
      '<param name="movie" value="'+url+'"></param>' +
      '<param name="wmode" value="transparent"></param>' +
      '<embed name="'+obj_id+'" src="'+url+'" ' +
      'type="application/x-shockwave-flash" ' +
      'wmode="transparent" width="'+w+'" height="'+h+'"></embed>' +
      '</object>';
  }
};

/**
 * KHttp Class .. XMLHttpRequest
 */
function KHttp() {
  // -------------------------
  // instance variable
  // -------------------------
  this.request    = null;  // XMLHttpRequest instance
  this.url        = null;  // request url
  this.method     = "GET";
  this.onComplete = null; // = function (response_str) {..}
  this.onError    = null; // = function (error_str, status_int) { .. }
  this.params     = {};   // is hash object
  this.params_str = null; // (ex) p1=xxx&p2=xxx&p3=xxx
  this.content_tyep = 'application/x-www-form-urlencoded; charset=UTF-8';
  // -------------------------
  // Get XMLHttpRequest
  // -------------------------
  if (window.XMLHttpRequest){
    // Mozilla, Safari1.2, Opera7.6, IE7.0
    this.request = new XMLHttpRequest();
  }
  else if (window.ActiveXObject) {
    try {
      // IE6.0
      this.request = new ActiveXObject("Msxml2.XMLHTTP");
    } catch(e) {
      // IE4.0
      this.request = new ActiveXObject("Microsoft.XMLHTTP");
    }
  }
}

// convert params => params_str
KHttp.prototype.serializeParams = function (params_obj) {
  if (!params_obj) return null;
  var param_ary = [];
  var key, val;
  for (key in params_obj) {
    val = params_obj[key];
    key = encodeURIComponent(key);
    val = encodeURIComponent(val);
    param_ary.push(key + "=" + val);
  }
  return param_ary.join("&");
}

KHttp.prototype.send = function (url, method) {
  // set url
  if (url)    this.url = url;
  if (method) this.method = method;
  // Create 'params_str'
  if (this.params_str == null) {
    this.params_str = this.serializeParams(this.params);
  }
  // check event
  var chk = function (f) { if (f) { return f; } else { return function(){} } };
  var _onComplete = chk(this.onComplete);
  var _onError    = chk(this.onError);
  var _request    = this.request;
  if (!_request) { throw new Error('class "KHttp" was not created.'); }
  _request.onreadystatechange = function () {
    if (_request.readyState == 4) {
       switch (_request.status) {
         case 200:
           var str = _request.responseText;
           _onComplete(str);
           break;
         case 404: _onError("File not found", 404); break;
         case 403: _onError("Access denied", 403);  break;
         default:  _onError("Read error", _request.status);
       }
    }
  };
  if (this.url == null || this.url == "") {
    throw new Error('KHttp.url is not set.');
  }
  try {
    this.request.open(this.method, this.url, true);
    this.request.setRequestHeader("Content-Type", this.content_tyep);
    this.request.send(this.params_str);
  } catch (e) {
    throw new Error('KHttp.send failed.' + e);
  }
};



