

class ModuleVideoFunc extends ModuleBase
{
    // --- ������
    // (�O���t�@�C���ɕ����Ȃ���) ���ߍ��ގ��͂�����Ă�
    static function init() {
        KLog.write("init");
        var m = new ModuleVideoFunc();
        m.module_init("ModuleVideo");
        ModuleVideoTable.initTable(m.ftable);
    }
    function ModuleVideoFunc() {} // constructor  for [Flash IDE]
    
    //------------------------------------------------------------------
    // Variables
    static var video:Object; // --- VideoPlayer
    static var video_mc:MovieClip;
    static var loop_mode:Boolean = false;
    static var module_mc:MovieClip;
    //
    static var net_con:NetConnection;
    static var net_stream:NetStream;
    static var my_camera:Camera;
    
    static function _video_play(url:String):Void
    {
        // connection
        net_con = new NetConnection();
        net_con.connect(null);
        net_stream = new NetStream(net_con);
        net_stream.onStatus = function(infoObject) {
            // todo:event
            var code:String   = infoObject.code;
            var level:String = infoObject.level;
            // KLog.write("code="+code);
            if (code == "NetStream.Play.Stop") {
            }
            else if (code == "NetStream.Buffer.Flush") {
            }
            else if (code == "NetStream.Buffer.Full") { // Buffering full
            }
            else if (code == "NetStream.Play.Start") {
            }
            else if (code == "NetStream.Buffer.Empty") {
                if (ModuleVideoFunc.loop_mode) {
                    net_stream.play(url);
                }
            }
        }
        // NetStream �r�f�I�t�B�[�h�� Video �I�u�W�F�N�g�Ɋ��蓖�Ă� :
        video.attachVideo(net_stream);
        // �o�b�t�@���Ԃ�ݒ肷�� :
        net_stream.setBufferTime(3);
        // FLV �t�@�C�����Đ����� :
        net_stream.play(url);
        // Show video
        // module ���őO�ʂ�
        module_mc.swapDepths(module_mc._parent.getNextHighestDepth());
        video_mc._visible = true;
        //
        KLog.write("ModuleVideo.video_play");
    }
    
    //------------------------------------------------------------------
    // *����Đ�(URL��)="ModuleVideo"@1 // 1
    // URL�̓�����Đ�����
    static function video_play(arg:ModuleFunctionArg)
    {
        var url:String = arg.getArgStr(0);
        loop_mode = false;
        _video_play(url);
    }
    // *�����~()="ModuleVideo"@2 // 0
    // �Đ����̓�����~����
    static function video_stop(arg:ModuleFunctionArg)
    {
        net_stream.stop();
    }
    // *����J��Ԃ��Đ�(URL��|URL��)="ModuleVideo"@3 // 1
    // URL�̓�����J��Ԃ��Đ�����
    static function video_playLoop(arg:ModuleFunctionArg)
    {
        var url:String = arg.getArgStr(0);
        loop_mode = true;
        _video_play(url);
    }
    // *����T�C�Y�ݒ�(X,Y,W,H��|H��)="ModuleVideo"@4 // 4
    // ����v���C���[�̃T�C�Y��ݒ肷��
    static function video_setRect(arg:ModuleFunctionArg)
    {
        video._x = arg.getArgNum(0);
        video._y = arg.getArgNum(1);
        video._width = arg.getArgNum(2);
        video._height = arg.getArgNum(3);
    }
    // *����N���A()="ModuleVideo"@5 // 0
    // �Đ����̓�����~����
    static function video_clear(arg:ModuleFunctionArg)
    {
        net_stream.stop();
        video.attachVideo(null);
        video_mc._visible = false;
    }
    // *�J�����\��()="ModuleVideo"@20 // 0
    // ���[�J���J������\������
    static function camera_show(arg:ModuleFunctionArg)
    {
        if (!my_camera) {
            my_camera = Camera.get();
        }
        video.attachVideo(my_camera);
        video_mc._visible = true;
    }
    // *�J�������[�V�����ݒ�(EVENT��LEVEL��|EVENT��)="ModuleVideo"@21 // 2
    // �J�����摜�̐؂�ւ�莞�Ɏ��s����C�x���gEVENT��LEVEL(0-100)�Őݒ肷��
    static function camera_setMotion(arg:ModuleFunctionArg)
    {
        var event:String = arg.getArgStr(0);
        var level:Number = arg.getArgNum(1);
        if (!my_camera) {
            my_camera = Camera.get();
        }
        my_camera.setMotionLevel(level, 3000);
        my_camera.onActivity = function (active:Boolean) {
            ModuleFunctionApi.addEvent(event);
        };
        video.attachVideo(my_camera);
        video_mc._visible = true;
    }
}

