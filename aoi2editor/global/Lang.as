package global
{
    public class Lang
    {
        public static var lang_xml:XML;
        
        public static function msg(name:String):String
        {
            var s:String = lang_xml.messages.item.(@name == name);
            if (s == null) return name;
            return s;
        }
    }
}