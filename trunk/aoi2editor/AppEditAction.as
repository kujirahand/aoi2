// ActionScript file
import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.events.Event;
import mx.rpc.soap.LoadEvent;
import flash.events.IOErrorEvent;
import flash.events.ErrorEvent;
import mx.collections.XMLListCollection;
import mx.collections.ArrayCollection;import mx.managers.DragManager;
import mx.events.DragEvent;
import mx.core.UIComponent;
import mx.events.MenuEvent;
import mx.controls.Alert;
import mx.events.CloseEvent;
import flash.system.System;
import flash.external.ExternalInterface;
import com.kujirahand.CSVUtils;
import global.Lang;
import flash.events.FullScreenEvent;
import flash.display.Stage;
import mx.managers.PopUpManager;
import global.*;public var command_xml:XMLListCollection = new XMLListCollection();
/**
 * アプリケーションの初期化
 */private function onPreInit():void {    GlobalData.create(this);}private function onInit():void {    config_service.send();}private function onCreate():void {    // set version info    version_lbl.text = "ver." + Config.version;    // load setting    ViewCtrl.loadInfo();    initApp();}private function initApp():void {    //    Lang.lang_xml = lang_xml;    //    edit_view.command_tree.dataProvider = command_xml;    //    var files:Array = [    	"command-ModuleSwf.txt?ver=1000",		"command-ModuleSystem.txt?ver=1000",		"command-ModuleVideo.txt?ver=1000",		"command-ModulePhidget.txt?ver=1000",		"command-ModuleOffice.txt?ver=1000"    ];    for each (var file:String in files) {    	trace(file);    	var request:URLRequest = new URLRequest();    	var loader:URLLoader = new URLLoader();    	request.url = file;    	loader.addEventListener(Event.COMPLETE, def_text_onLoad);    	loader.addEventListener(IOErrorEvent.IO_ERROR, def_text_onLoadError);    	loader.load(request);    }
}
private function config_onLoad():void {    trace('config_onLoad');    Config.data_xml = XML(config_service.lastResult);    trace('path=' + Config.basePath);}
private function def_text_onLoadError(event:ErrorEvent):void {
    trace("load error:" + event.text);
}

private function def_text_onLoad(event:Event):void {    trace("load");
    var txt:String = String(URLLoader(event.target).data);
    txt = txt.replace(/(\r\n|\r)/g, "\n");
    var txt_array:Array = txt.split("\n");
    var h1:String = null;
    var h2:String = null;
    var title:XML;    var subtitle:XML;    for (var i:int = 0; i < txt_array.length; i++) {
        var line:String = txt_array[i];
        if (line.charAt(0) == "+") {
            h1 = line.substr(1);            title = <title aoi={h1} bas={h1}/>;            command_xml.addItem(title);
            continue;
        }
        if (line.charAt(0) == "-") {
            h2 = line.substr(1);
            subtitle = <subtitle aoi={h2} bas={h2}/>;
            title.appendChild(subtitle);
            continue;
        }
        if (line.charAt(0) == "|") {            line = line.substr(1);            var csv:Array    = CSVUtils.CsvToArray(line);            var name:String  = csv[0][0];            var bas:String   = csv[0][4];            if (bas == "") bas = csv[0][0];            subtitle.appendChild(<item aoi={name} bas={bas} line={line}/>);
        }
    }
    command_xml.refresh();
}
private function changeFull():void {    if (this.stage.displayState == "fullScreen") {        this.stage.displayState = "normal";    } else {        this.stage.displayState = "fullScreen";    }}private function testClick():void {    var n:TestWindow = PopUpManager.createPopUp(this, TestWindow, true) as TestWindow;}