package global
{
    public class GlobalData
    {
        public static var app:AppEditor;
        public static var model:Model;
        public static var js:ModelJS;
        
        public static function create(app:AppEditor):void {
            // static
            GlobalData.app = app;
            ViewCtrl.app = app;
            ViewCtrl.create();
            Lang.lang_xml = app.lang_xml;
            // class
            model = new Model();
            js    = new ModelJS();
        }
    }
}