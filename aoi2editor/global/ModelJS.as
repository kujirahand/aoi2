package global
{
    import flash.external.ExternalInterface;
    import mx.controls.Alert;
    
    /**
     * JavaScript との連携
     */
    public class ModelJS
    {
        public function get enable():Boolean {
            return ExternalInterface.available;
        }
        
        public function ModelJS() {
            if (enable) {
                ExternalInterface.addCallback("editor_setArgs", editor_setArgs);
            }
        }
        
        // callback
        public function editor_setArgs(args_obj:Object):void {
            var file_info:ModelFileInfo = GlobalData.model.file_info;
            for (var key:String in args_obj) {
                if (file_info.hasOwnProperty(key)) {
                    file_info[key] = args_obj[key];
                }
            }
            GlobalData.model.saveFileInfo();
            ViewCtrl.checkTitle();
            GlobalData.app.edit_view.onShow();
        }
                
        public function callCompile(args_obj:Object):void {
            if (!enable) {
                Alert.show("Not Browser Mode");
                return;
            }
            // 一度保存する
            GlobalData.model.saveFileInfo();
            GlobalData.model.saveSetting();
            // 値をセット
            ExternalInterface.call("aoic_setArgs", args_obj);
            // コンパイル
            ExternalInterface.call("aoic_compile");
        }
    }
}