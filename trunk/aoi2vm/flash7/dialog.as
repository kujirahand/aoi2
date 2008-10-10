import KLog;

class dialog
{
    // dialog.swf
    static var dialog_mc:MovieClip;
    
    // param
    static var modal_continue_index:Number;
    
    // dialog.message_dlg
    static var message_dlg:MovieClip;
    static var message_dlg_ok_btn:MovieClip;
    static var message_dlg_msg_txt:TextField;
    // dialog.yesno_dlg
    static var yesno_dlg:MovieClip;
    static var yesno_dlg_msg_txt:MovieClip;
    static var yesno_dlg_yes_btn:TextField;
    static var yesno_dlg_no_btn:TextField;
    // dialog.input_dlg
    static var input_dlg:MovieClip;
    static var input_dlg_msg_txt:TextField;
    static var input_dlg_input_txt:TextField;
    static var input_dlg_ok_btn:MovieClip;
    static var input_dlg_cancel_btn:MovieClip;
    
    
    static function check(mc:MovieClip, name:String) {
        if (mc[name] == undefined) {
            KLog.write("[ERROR] no instance in dialog = " + name);
            return;
        }
        dialog[name] = mc[name];
    }
    
    static function setLink(mc:MovieClip) {
        // message_dlg
        check(mc, "message_dlg");
        check(message_dlg, "message_dlg_msg_txt");
        check(message_dlg, "message_dlg_ok_btn");
        
        // yesno_dlg
        check(mc, "yesno_dlg");
        check(yesno_dlg, "yesno_dlg_msg_txt");
        check(yesno_dlg, "yesno_dlg_yes_btn");
        check(yesno_dlg, "yesno_dlg_no_btn");
        
        // input_dlg
        check(mc, "input_dlg");
        check(input_dlg, "input_dlg_msg_txt");
        check(input_dlg, "input_dlg_input_txt");
        check(input_dlg, "input_dlg_ok_btn");
        check(input_dlg, "input_dlg_cancel_btn");
    }
    
    static function loadSWF(onLoad:Function, arg) {
        // already loaded ?
        if (dialog_mc != undefined) {
            dialog_mc.swapDepths(_root.getNextHighestDepth());
            onLoad(arg);
            return;
        }
        // load movie
        _root.createEmptyMovieClip("dialog_mc",_root.getNextHighestDepth());
        dialog_mc = _root["dialog_mc"];
        var loader:MovieClipLoader = new MovieClipLoader();
        var evt_obj:Object = new Object();
        evt_obj.onLoadInit = function (dialog_mc:MovieClip) {
            dialog.setLink(dialog_mc);
            onLoad(arg);
        };
        var path:String = KUtils.getModulePath("dialog.swf");
        evt_obj.onLoadError = function () {
            KLog.err("dialog load error:" + path);
        }
        loader.addListener(evt_obj);
        loader.loadClip(path, dialog_mc);
    }
    
    /**
     * message box
     */
    static function showMessageBox(mac:Object, msg:String):Void {
        KDraw.blackout(true);
        mac.flag_quit = true;
        modal_continue_index = mac.index + 1;
        loadSWF(showMessageBox_onLoad, [msg, mac]);
    }
    
    static function showMessageBox_onLoad(args) {
        var msg:String       = args[0];
        var mac:Stackmachine = args[1];
        KDraw.moveToCenter(dialog.message_dlg);
        dialog.message_dlg._visible = true;
        dialog.message_dlg_msg_txt.text = msg;
        dialog.message_dlg_ok_btn.onRelease = function () {
            KDraw.blackout(false);
            dialog.message_dlg._visible = false;
            mac.index = dialog.modal_continue_index;
            mac.flag_quit = false;
        };
    }
    
    /**
     * yesno dialog
     */
     static function showYesNoDialog(mac:Object, msg:String):Void {
        KDraw.blackout(true);
        mac.flag_quit = true;
        modal_continue_index = mac.index + 1;
        loadSWF(showYesNoDialog_onLoad, [msg, mac]);
     }
     
     static function showYesNoDialog_onLoad(args) {
        var msg:String       = args[0];
        var mac:Stackmachine = args[1];
        KDraw.moveToCenter(dialog.yesno_dlg);
        dialog.yesno_dlg._visible = true;
        dialog.yesno_dlg_msg_txt.text = msg;
        
        var evt = function () {
            KDraw.blackout(false);
            dialog.yesno_dlg._visible = false;
            mac.index = dialog.modal_continue_index;
            mac.flag_quit = false;
        };
        
        dialog.yesno_dlg_yes_btn.onRelease = function () {
            Stackmachine.swap_stacktop(mac, new Number(1));
            evt();
        };
        dialog.yesno_dlg_no_btn.onRelease = function () {
            Stackmachine.swap_stacktop(mac, new Number(0));
            evt();
        };
     }
     
     /**
      * input dialog
      */
     static function showInputDialog(mac:Object, msg:String):Void {
        KDraw.blackout(true);
        mac.flag_quit = true;
        modal_continue_index = mac.index + 1;
        loadSWF(showInputDialog_onLoad, [msg, mac]);
     }
     
     static function showInputDialog_onLoad(args) {
        var msg:String       = args[0];
        var mac:Stackmachine = args[1];
        KDraw.moveToCenter(dialog.input_dlg);
        dialog.input_dlg._visible = true;
        dialog.input_dlg_msg_txt.text = msg;
        dialog.input_dlg_input_txt.text = "";
        
        var evt = function () {
            KDraw.blackout(false);
            dialog.input_dlg._visible = false;
            mac.index = dialog.modal_continue_index;
            mac.flag_quit = false;
        };
        
        dialog.input_dlg_ok_btn.onRelease = function () {
            Stackmachine.swap_stacktop(mac, dialog.input_dlg_input_txt.text);
            evt();
        };
        dialog.input_dlg_cancel_btn.onRelease = function () {
            Stackmachine.swap_stacktop(mac, "");
            evt();
        };
     }
}

