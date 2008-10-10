//--------------------------------------------------------------------
// clipbrd.js
// Unoh Inc. 2006/12/21
// version 1.000
//--------------------------------------------------------------------
var clipbrd_setup = {
  obj_id:   'clipbrd_id',
  swf_path: 'clipbrd.swf',
  body_id:  'clipbrd_body_id'
};
var clipbrd;
//--------------------------------------------------------------------
document.write('<!-- saved from url=(0013)about:internet -->');
document.write('<div id="'+clipbrd_setup.body_id+'"></div>');
var clipbrd_so = new SWFObject(clipbrd_setup.swf_path, clipbrd_setup.obj_id, 
    "1", "1", "8", "white");
clipbrd_setup.tid = setInterval(function(){
  clearInterval(clipbrd_setup.tid);
  clipbrd_so.write(clipbrd_setup.body_id);
  if (navigator.appName.indexOf("Microsoft") != -1) {
    var clipbrd = new Object();
    clipbrd.copyText = function(txt) { clipboardData.setData("Text", txt); }
  } else {
    clipbrd = document[clipbrd_setup.obj_id];
  }
}, 300);
//--------------------------------------------------------------------


