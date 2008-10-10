package global
{
    public class Config
    {
        public static var version:int = 1003;
        public static var data_xml:XML = null;
        public static function read(sec:String, skey:String):String {
            if (data_xml == null) return "";
            return data_xml.section.(@id==sec).key.(@id==skey).@value;
        }
        public static function get basePath():String {
            return read('path','base');
        }
        public static function getAPIUrl(name:String):String {
            return Config.basePath + Config.read('api', name); 
        }
        public static function unixtime2str(item:Object, parent:Object):String {
            var v:Number = Number(item.update_time);
            var date:Date = new Date();
            date.setTime(v * 1000);
            return date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + 
                date.getDay() + " " + date.getHours() + ":" + date.getMinutes();
        }
    }
}