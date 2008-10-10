package global
{
    import mx.containers.ViewStack;
    import flash.net.URLRequest;
    import global.Config;
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import mx.controls.Alert;
    import com.adobe.serialization.json.JSON;
    import flash.net.URLVariables;
    import mx.managers.PopUpManager;
    import flash.external.ExternalInterface;
    import flash.system.System;
    import mx.managers.SystemManager;
    import flash.system.SecurityDomain;
    import flash.system.IMEConversionMode;
    import mx.utils.Base64Encoder;
    
    public class ViewCtrl
    {
        public static var app:AppEditor;
        public static var file_id:String;
        
        private static var frmLoading:NowLoading;
        private static var instance:ViewCtrl = null;
        public static function create():ViewCtrl {
            if (instance == null) {
                instance = new ViewCtrl();
            }
            return instance;
        }
        
        public function ViewCtrl() {
            if (instance) return;
        }
        
        public static function loadInfo():void {
            loadSetting();
            loadFileInfo();
        }
        
        public static function clearFile():void {
            GlobalData.model.clearFile();
            GlobalData.app.edit_view.main_txt.text = "";
            GlobalData.js.editor_setArgs(GlobalData.model.file_info);
        }
        
        public static function openFile(file_id:int, password:String = ""):void {
            var req:URLRequest = new URLRequest();
            var param:URLVariables = new URLVariables();
            param.file_id  = file_id;
            param.password = password;
            req.url = Config.getAPIUrl("loadSource");
            req.data = param;
            var lod:URLLoader = new URLLoader();
            lod.addEventListener(Event.COMPLETE, openFile_onLoad);
            lod.addEventListener(IOErrorEvent.IO_ERROR, openFile_onError);
            lod.load(req);
            frmLoading = NowLoading(PopUpManager.createPopUp(app,NowLoading,false));
            PopUpManager.centerPopUp(frmLoading);
        }
        private static function openFile_onLoad(event:Event):void {
            try {
	            var lod:URLLoader = URLLoader(event.target);
	            var obj:Object = JSON.decode(String(lod.data));
	            if (obj.result == false) {
	            	throw new Error(obj.message);
	            }
	            var src:String = obj["file"]["source"];
	            app.edit_view.main_txt.text = src.replace(/(\r\n|\r)/g,"\n");
	            obj["file"]["source"] = src;
	            
	            var file_info:ModelFileInfo = GlobalData.model.file_info;
	            for (var key:String in obj["file"]) {
	                if (file_info.hasOwnProperty(key)) {
	                    file_info[key] = obj["file"][key];
	                    trace("file_info." + key + "=" + obj["file"][key]);
	                }
	            }
	            
	            checkTitle();
	            PopUpManager.removePopUp(frmLoading);
	            
	            saveSetting();
	            GlobalData.model.saveFileInfo();
	            changeEditView();
	     	} catch (e:Error) {
	     		Alert.show(Lang.msg('Failed to read') + "\n->" + e.message);
	            PopUpManager.removePopUp(frmLoading);
	     	}
        }
        
        public static function setTitle(id:int, title:String, lang:String):void {
            if (title == null) title = "***";
            if (lang == null) lang = ".aoi";
            var s:String = Lang.lang_xml.title + " - " + id + ":" + title + lang;
            app.apptitle_lbl.text = s;
        }
        
        public static function checkTitle():void {
            var fi:ModelFileInfo = GlobalData.model.file_info;
            setTitle(fi.file_id, fi.filename, fi.lang);
            
        }
        
        private static function openFile_onError(event:IOErrorEvent):void {
            Alert.show("Load Error");
            PopUpManager.removePopUp(frmLoading);
        }
        
        public static function saveSetting():void {
            var setting:ModelSetting = GlobalData.model.setting;
            setting.main_txt_text  = app.edit_view.main_txt.text;
            setting.main_txt_index = app.edit_view.main_txt.selectionBeginIndex;
            GlobalData.model.saveSetting();
        }
        
        public static function loadSetting():void {
            var setting:ModelSetting = GlobalData.model.loadSetting();
            // text
            if (setting.main_txt_text != null) {
                // text
                var txt:String = setting.main_txt_text;
                if (txt == null) txt = "";
                txt = txt.replace(/(\r\n|\n)/g, "\r");
                app.edit_view.main_txt.text = txt;
                // index
                var idx:int = setting.main_txt_index;
                app.edit_view.main_txt.setSelection(idx, idx);
                app.edit_view.main_txt.setFocus();
                // fontsize
                var size:int = setting.main_txt_fontsize;
                if (size >= 8) {
                    app.edit_view.main_txt.setStyle("fontSize", size);
                }
            }
       }
       
       public static function loadFileInfo():void {
            GlobalData.model.loadFileInfo();
            checkTitle();
       }
       public static function changeFileView():void {
           app.editor_views.selectedIndex = 0;
       }
       public static function changeEditView():void {
           app.editor_views.selectedIndex = 1;
       }
       public static function runScript():void {
            var file_info:ModelFileInfo = GlobalData.model.file_info;
            file_info["source"] = escape(GlobalData.app.edit_view.main_txt.text);
            GlobalData.js.callCompile(file_info);
       }
       public static function changeLang(): void {
            ViewCtrl.checkTitle();
            // lang
            var lang:String = GlobalData.model.file_info.lang;
            if (lang == null || lang == "") lang = ".aoi";
            // ime
            if (lang == ".aoi") {
                app.edit_view.main_txt.imeMode = IMEConversionMode.JAPANESE_HIRAGANA;
            } else {
                app.edit_view.main_txt.imeMode = IMEConversionMode.ALPHANUMERIC_HALF;
            }
            // tree
            lang = lang.replace(/^\./, "@");
            app.edit_view.command_tree.labelField = lang;
            app.edit_view.find_list.labelField = lang;
       }
    }
}

