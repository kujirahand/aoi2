

class ModuleVideoFunc extends ModuleBase
{
    // --- 初期化
    // (外部ファイルに分けないで) 埋め込む時はこれを呼ぶ
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
        // NetStream ビデオフィードを Video オブジェクトに割り当てる :
        video.attachVideo(net_stream);
        // バッファ時間を設定する :
        net_stream.setBufferTime(3);
        // FLV ファイルを再生する :
        net_stream.play(url);
        // Show video
        // module を最前面に
        module_mc.swapDepths(module_mc._parent.getNextHighestDepth());
        video_mc._visible = true;
        //
        KLog.write("ModuleVideo.video_play");
    }
    
    //------------------------------------------------------------------
    // *動画再生(URLの)="ModuleVideo"@1 // 1
    // URLの動画を再生する
    static function video_play(arg:ModuleFunctionArg)
    {
        var url:String = arg.getArgStr(0);
        loop_mode = false;
        _video_play(url);
    }
    // *動画停止()="ModuleVideo"@2 // 0
    // 再生中の動画を停止する
    static function video_stop(arg:ModuleFunctionArg)
    {
        net_stream.stop();
    }
    // *動画繰り返し再生(URLの|URLを)="ModuleVideo"@3 // 1
    // URLの動画を繰り返し再生する
    static function video_playLoop(arg:ModuleFunctionArg)
    {
        var url:String = arg.getArgStr(0);
        loop_mode = true;
        _video_play(url);
    }
    // *動画サイズ設定(X,Y,W,Hに|Hで)="ModuleVideo"@4 // 4
    // 動画プレイヤーのサイズを設定する
    static function video_setRect(arg:ModuleFunctionArg)
    {
        video._x = arg.getArgNum(0);
        video._y = arg.getArgNum(1);
        video._width = arg.getArgNum(2);
        video._height = arg.getArgNum(3);
    }
    // *動画クリア()="ModuleVideo"@5 // 0
    // 再生中の動画を停止する
    static function video_clear(arg:ModuleFunctionArg)
    {
        net_stream.stop();
        video.attachVideo(null);
        video_mc._visible = false;
    }
    // *カメラ表示()="ModuleVideo"@20 // 0
    // ローカルカメラを表示する
    static function camera_show(arg:ModuleFunctionArg)
    {
        if (!my_camera) {
            my_camera = Camera.get();
        }
        video.attachVideo(my_camera);
        video_mc._visible = true;
    }
    // *カメラモーション設定(EVENTにLEVELの|EVENTへ)="ModuleVideo"@21 // 2
    // カメラ画像の切り替わり時に実行するイベントEVENTをLEVEL(0-100)で設定する
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

