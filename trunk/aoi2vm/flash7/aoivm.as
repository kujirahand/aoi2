/**
 * aoivm.as
 * -------------------------------
 * MTASC_TAG:640:400:12
 * MTASC_VER:7
 * <screen>
 * + AOI2
 * - 640:400:12
 * + Wii
 * - [bar ] 800x528pix（4:3モード）800x396pix（16:9モード）
 * - [none] 800x628pix（4:3モード）800x472pix（16:9モード）
 */

class aoivm
{
    static function main() {
        //--- show log
        KLog.isTest        = true;
        KLog.use_server    = true;
        KLog.use_textfield = false;
        Stackmachine.frame_speed = 256;
        var vm:ALoader = new ALoader();
        //--- Module
        ModuleSystemFunc.init();
        ModuleSwfFunc.init();
        ModuleOfficeFunc.init();
        //--- 
        vm.checkFlashVars();
        
        if (ALoader.mainfile == undefined && ALoader.mainsource == undefined) {
            ALoader.mainfile = "test.aoir";
        }
        if (ALoader.mainfile) {
            vm.loadMainFile(ALoader.mainfile);
        } else {
            //KLog.write("source="+ ALoader.mainsource);
            vm.setMainCodeStr(ALoader.mainsource);
        }
    }
}
