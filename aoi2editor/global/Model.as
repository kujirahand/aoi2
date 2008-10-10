package global
{
    import flash.display.LoaderInfo;
    
    public class Model
    {
        public var modified:Boolean = false;
        public var file_info:ModelFileInfo;
        public var setting:ModelSetting;
        
        public function loadSetting():ModelSetting {
            setting = new ModelSetting();
            var obj:Object = Strage.load("model_setting", null);
            if (obj) {
                for (var key:String in obj) {
                    setting[key] = obj[key];
                }
            }
            modified = false;
            return setting;
        }
        
        public function saveSetting():void {
            Strage.save("model_setting", setting);
            modified = false;
            return;
        }
        
        public function saveFileInfo():void {
            Strage.save("file_info", file_info);
        }
        
        public function loadFileInfo():ModelFileInfo {
            file_info = new ModelFileInfo();
            var obj:Object = Strage.load("file_info", null);
            if (obj) {
                for (var key:String in obj) {
                    file_info[key] = obj[key];
                }
            }
            return file_info;
        }
        
        public function clearFile():void {
            file_info = new ModelFileInfo();
            setting   = new ModelSetting();
        }
    }
}

