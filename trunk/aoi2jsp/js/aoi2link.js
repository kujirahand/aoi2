// -----------------------------
// aoi2link.js
// -----------------------------
// import prototype.js
// import swfobject.js
// -----------------------------
var program_id;
var editmode = true;
//var host = "http://aoi-project.com:8080/";
var host = "http://localhost:8080/";
var root = ""; // (ex) aoi2/
var show_url = host + "aoi2show.jsp";
var obj_url = host + "webparts/";
var swf_template = '<object width="640" height="400"><param name="movie" value="[SWF]"></param><param name="wmode" value="transparent"></param><embed src="[SWF]" type="application/x-shockwave-flash" wmode="transparent" width="640" height="400"></embed></object>';
var div_swf       = "swf";
var div_msg       = "msg";
var div_save_form = "save_form";
var txt_source    = "source";
var btn_run       = "run_btn";
var div_prog_title= "prog_title";
// -----------------------------
// compile
// -----------------------------
        function aoi2_compile() {
            Element.hide(div_save_form);
            Element.hide(btn_run);
            $(div_msg).innerHTML = "";
            $(div_swf).innerHTML = "";
            var src = "「ModuleSwf.aoi2」を取り込む。" + $F(txt_source);
            var url = "aoi2ir";
            var params = "ext=.aoi2&source=" + encodeURIComponent(src); 
            var ajax = new Ajax.Request(
                url,
                {
                    method:'post', 
                    parameters:params,
                    onComplete: aoi2_compile_onComplete
                }
            );
        }
        function aoi2_compile_onComplete(r) {
            if (editmode) {
                Element.show(btn_run);
            }
            var msg = $(div_msg);
            var res = r.responseText;
            if (res.indexOf("type:\"error\"") >= 0) {
                var o = eval("(" + res + ")");
                var s = o["message"];
                var a = s.split("\n");
                s = a.join("<br>");
                msg.innerHTML = "<div style='color:red'>[ERROR]:" + s + "</div>";
                return;
            }
            // ok
            res = encodeURIComponent(res);
            var so = new SWFObject("webparts/aoivm.swf", "aoivm", 
                "640", "400", "7", "white");//
            so.addVariable("mainsource", res);//
            so.addVariable("library_path", "/webparts");//
            so.write(div_swf);//
            Element.show(div_save_form);
        }
// -----------------------------
// load
// -----------------------------
        function aoi2_load() {
            var url = "aoi2save";
            var params = "mode=load";
            params += "&id=" + program_id;
            var ajax = new Ajax.Request(
                url, 
                {
                    method:'post', 
                    parameters:params,
                    onComplete: aoi2_load_onComplete
                }
            );
        }
        function aoi2_load_onComplete(r) {
            var res = r.responseText;
            var obj = eval("(" + res + ")");
            var status = obj["status"];
            if (status == "error") {
                program_id = -1;
                Element.hide("save_form");
                return;
            }
            var fields = ["name", "title", "comment", "source"]; 
            for (i = 0; i < fields.length; i++) {
                var key = fields[i];
                $(key).value = obj[key];
            }
            $(div_prog_title).innerHTML = obj["title"];
            Element.show("save_form");
            if (!editmode) {
                Element.hide("source");
            }
            aoi2_compile();
            showLink();
        }
// -----------------------------
// make link
// -----------------------------
        function replace(s, a, b) {
	    var sa = s.split(a);
            return sa.join(b);
        }
        function showLink() {
            var link = host + "aoi2show.jsp?id=" + program_id;
            var link2 = swf_template;
            var mainfile = "/aoi2save?mode=ir&id=" + program_id;
            mainfile = replace(mainfile, "&","%26");
            mainfile = replace(mainfile, "?","%3F");
            var swf  = host + "webparts/aoivm.swf?mainfile=" + mainfile;
            link2 = replace(link2, "[SWF]", swf);
            var frm = "";
            frm += "<table>";
            frm += "<tr><td></td><td>このプログラムへのリンク</td></tr>";
            frm += "<tr><td>URL</td><td><input type='text' size=50 value='"+link+"'></td></tr>";
            frm += "<tr><td>ブログ用</td><td><input type='text' size=50 value='"+link2+"'></td></tr>";
            frm += "<tr><td>swf</td><td><input type='text' size=50 value='"+swf+"'></td></tr>";
            frm += "</table>";
            $("link").innerHTML = frm;
            //$("test").innerHTML = link2;
        }

