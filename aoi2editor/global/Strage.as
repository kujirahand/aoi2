package global
{
    import flash.net.SharedObject;
    
    public class Strage
    {
        private static var so:SharedObject = null;
        private static var soname:String = "aoi2edit";
        
        public static function getSO():SharedObject
        {
            if (so == null) {
                so = SharedObject.getLocal(soname);
            }
            return so;
        }
        
        public static function save(key:String, value:*):void
        {
            if (so == null) getSO();
            so.data[key] = value;
        }
        public static function load(key:String, def:*):*
        {
            if (so == null) getSO();
            return (so.data[key] != undefined) ? so.data[key] : def;
        }
    }
}