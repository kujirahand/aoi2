// ActionScript file
import mx.core.UIComponent;
import mx.managers.DragManager;
import mx.events.DragEvent;
import com.kujirahand.CSVUtils;
import mx.events.MenuEvent;
import mx.events.CloseEvent;
import mx.controls.Alert;
import global.Lang;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import global.Strage;
import global.Config;
import global.ViewCtrl;
import flash.external.ExternalInterface;
import global.GlobalData;
import global.ModelFileInfo;
import flash.system.IMEConversionMode;
import mx.core.Application;
import mx.controls.TextInput;
import flash.text.TextField;
import flash.geom.Point;
import mx.controls.Text;
import mx.charts.chartClasses.StackedSeries;
import mx.controls.List;
import mx.binding.utils.ChangeWatcher;

private var nise_clipboard:String = "";
private var undo_ary:Array = [];
private var max_undo:int = 3;


private function onCreate():void {
    callLater(onShow);
}

private function runScript():void {
    ViewCtrl.runScript();
}

public function onShow():void {
    ViewCtrl.changeLang();
}

private function acceptDrop(event:DragEvent):void {
    DragManager.acceptDragDrop(event.currentTarget as UIComponent);
}
private function main_txt_dragOver(event:DragEvent):void {
    var txt:TextField = this.main_txt.getTextField();
    var i:int = txt.getCharIndexAtPoint(txt.mouseX, txt.mouseY);
    if (i < 0) i = main_txt.length - 1;
    main_txt.setFocus();
    main_txt.setSelection(i,i);
}

private function checkSpecialKey(event:KeyboardEvent):void {
    // Ctrl + Z(90)
    if (event.ctrlKey){
        var ch:String = String.fromCharCode(event.keyCode);
        if (ch == 'Z') {
            var o:Object = undo_ary.pop();
            if (o == null) return;
            main_txt.text = o.text;
            main_txt.setSelection(o.index, o.index);
            return;
        }
        if (event.keyCode == Keyboard.SPACE) {
            var m1:String = main_txt.text.substring(0, main_txt.selectionBeginIndex);
            var m2:String = main_txt.text.substring(main_txt.selectionBeginIndex, main_txt.length);
            var i:int = main_txt.selectionBeginIndex;
            if (m1.substr(-1, 1) == " ") {
                m1 = m1.substring(0, m1.length-1);
                i--;
            }
            hokan(i);
            main_txt.text = m1 + m2;
            main_txt.setSelection(i,i);
            event.stopImmediatePropagation();
            return;
        }
    }
    checkStatus(event);
}

private function hokan(charIndex:int):void {
    //---
    // 補完語句の取得
    var txt:String = main_txt.text.substring(0, charIndex);
    var res:String = "";
    var i:int = txt.length - 1;
    var re:RegExp = /[a-zA-Z_]/;
    while (i >= 0) {
        var c:String = txt.charAt(i);
        if (re.test(c) || 0xFF < c.charCodeAt(0)) {
            res = c + res;
            i--;
            continue;
        }
        break;
    }
    find_txt.text = res;
    //---
    find_command();
}

private function commandLineToObj(line:String):Object {
    var csv:Array   = CSVUtils.CsvToArray(line);
    var c:Array     = csv[0];
    if (c[4] == '') c[4] == c[0];
    return {
        "@aoi":  c[0],
        "@bas":  c[4],
        name: c[0],
        args: c[1],
        desc: c[2],
        no:   c[3],
        sid:  c[4],
        type: c[5],
        module:c[6]
    };
}

private function showCommandInList():void {
    var o:Object = find_list.selectedItem;
    if (o == null) return;
    desc_txt.text = o.desc + " .. (" + o.args + ")";
}

private function text_onChange():void {
    GlobalData.model.modified = true;
    saveSatting();
    // make undo buffer
    undo_ary.push( {text:main_txt.text,index:main_txt.selectionBeginIndex} );
    if (undo_ary.length > max_undo) {
        undo_ary.splice(0, 1);
    }
}


private function command_tree_onChange():void {
    if (command_tree.selectedItem == null) return;
    var xml:XML = XML(command_tree.selectedItem);
    var line:String = xml.@line;
    if (line == null || line == "") {
        desc_txt.text = xml.@label;
        return;
    }
    var csv:Array = CSVUtils.CsvToArray(line);
    var name:String = csv[0][0];
    var arg:String  = csv[0][1];
    var des:String  = csv[0][2];
    var no:String     = csv[0][3];
    var sid:String    = csv[0][4]; if (sid == '') sid = name;
    var type:String   = csv[0][5];
    var mod:String    = csv[0][6];
    
    if (GlobalData.model.file_info.lang == ".bas") {
        name = sid;
        arg = arg.split("|")[0];
        arg = arg.replace(/[^0-9A-Za-z_]+/g, ",");
        arg = arg.replace(/\,\,/g, ",");
        if (arg.substr(-1,1) == ",") {
            arg = arg.substr(0, arg.length - 1);
        }
    }
    if (type == "命令") {
        desc_txt.htmlText = ""+
            "●"+name+"(" + arg + ")\n" + des;
    } else {
        desc_txt.htmlText = ""+
            "<b>"+name+"</b>\n" +
            "<b>定義</b>:"+arg;
    }
}

private function insertCommand():void {
    if (command_tree.selectedItem == null) return;
    var xml:XML = XML(command_tree.selectedItem);
    var line:String = xml.@line;
    if (line == null || line == "") return;
    var csv:Array = CSVUtils.CsvToArray(line);
    var name:String = csv[0][0];
    var arg:String  = csv[0][1];
    var type:String = csv[0][5];
    var bas:String  = csv[0][4];
    var lang:String = GlobalData.model.file_info.lang;
    arg = arg.split("|")[0];
    var s:String = main_txt.text;
    var cmd:String = arg + name + "\n";
    if (type != "命令") cmd = name + "\n";
    if (lang == ".bas") {
        arg = arg.replace(/[^0-9A-Za-z_]+/g, ",");
        arg = arg.replace(/\,\,/g, ",");
        if (arg.substr(-1,1) == ",") {
            arg = arg.substr(0, arg.length - 1);
        }
        cmd = bas + '(' + arg + ')';
    }
    main_txt.text = s.substr(0,main_txt.selectionBeginIndex) + 
        cmd + s.substr(main_txt.selectionEndIndex);
    main_txt.selectionBeginIndex += cmd.length;
    main_txt.selectionEndIndex = main_txt.selectionBeginIndex;
    main_txt.setFocus();
    //
    command_tree_onChange();
}

private function insertCommandList():void {
    if (find_list.selectedItem == null) return;
    var obj:Object = (find_list.selectedItem);
    var name:String = obj.name;
    var arg:String  = obj.args;
    var type:String = obj.type;
    var bas:String  = obj.sid;
    var lang:String = GlobalData.model.file_info.lang;
    arg = arg.split("|")[0];
    var s:String = main_txt.text;
    var cmd:String = arg + name + "\n";
    if (type != "命令") cmd = name + "\n";
    if (lang == ".bas") {
        arg = arg.replace(/[^0-9A-Za-z_]+/g, ",");
        arg = arg.replace(/\,\,/g, ",");
        if (arg.substr(-1,1) == ",") {
            arg = arg.substr(0, arg.length - 1);
        }
        cmd = bas + '(' + arg + ')';
    }
    main_txt.text = s.substr(0,main_txt.selectionBeginIndex) + 
        cmd + s.substr(main_txt.selectionEndIndex);
    main_txt.selectionBeginIndex += cmd.length;
    main_txt.selectionEndIndex = main_txt.selectionBeginIndex;
    main_txt.setFocus();
}

private function find_execute(event:KeyboardEvent):void {
    if (event.keyCode != Keyboard.ENTER) return;
    find_command();
    /*
    var key:String = find_txt.text;
    if (key == null || key.length == 0) return;
    var i:int = main_txt.text.indexOf(key, main_txt.selectionBeginIndex);
    if (i < 0) {
        i = main_txt.text.indexOf(key);
    }
    if (i < 0) return;
    main_txt.setSelection(i, i + key.length);
    main_txt.setFocus();
    */
}

private function find_command():void {
    // 語句の検索
    left_acc.selectedIndex = 1;
    find_list_data.removeAll();
    var res:String = find_txt.text;
    var items:Array = [];
    var lang:String = GlobalData.model.file_info.lang;
    lang = lang.replace(/^\./, '@');
    var list:XMLList = GlobalData.app.command_xml.source;
    res = res.replace(/(\　|\s)+/, '');
    for each(var titles:XML in list) {
        for each (var subs:XML in titles.subtitle) {
            for each (var item:XML in subs.item) {
                var o:Object = commandLineToObj(item.@line);
                if (o[lang].indexOf(res) >= 0) {
                    find_list_data.addItem(o);
                }
            }
        }
    }
}

private function checkStatus(event:KeyboardEvent):void {
    var row:int = main_txt.getTextField().getLineIndexOfChar(main_txt.selectionBeginIndex);
    status_txt.text = "[" + (row + 1) + "]行目";
}

private function loadSetting():void {
    ViewCtrl.loadSetting();
}
private function saveSatting():void {
    ViewCtrl.saveSetting();
}
