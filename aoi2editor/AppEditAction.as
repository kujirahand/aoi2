// ActionScript file
import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.events.Event;
import mx.rpc.soap.LoadEvent;
import flash.events.IOErrorEvent;
import flash.events.ErrorEvent;
import mx.collections.XMLListCollection;
import mx.collections.ArrayCollection;
import mx.events.DragEvent;
import mx.core.UIComponent;
import mx.events.MenuEvent;
import mx.controls.Alert;
import mx.events.CloseEvent;
import flash.system.System;
import flash.external.ExternalInterface;

import global.Lang;
import flash.events.FullScreenEvent;
import flash.display.Stage;
import mx.managers.PopUpManager;
import global.*;
/**
 * アプリケーションの初期化
 */
}

private function def_text_onLoadError(event:ErrorEvent):void {
    trace("load error:" + event.text);
}

private function def_text_onLoad(event:Event):void {
    var txt:String = String(URLLoader(event.target).data);
    txt = txt.replace(/(\r\n|\r)/g, "\n");
    var txt_array:Array = txt.split("\n");
    var h1:String = null;
    var h2:String = null;
    var title:XML;
        var line:String = txt_array[i];
        if (line.charAt(0) == "+") {
            h1 = line.substr(1);
            continue;
        }
        if (line.charAt(0) == "-") {
            h2 = line.substr(1);
            subtitle = <subtitle aoi={h2} bas={h2}/>;
            title.appendChild(subtitle);
            continue;
        }
        if (line.charAt(0) == "|") {
        }
    }
    command_xml.refresh();
}
