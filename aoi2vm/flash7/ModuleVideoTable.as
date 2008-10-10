// Created by module2txt.nako --- "ModuleVideo.aoi2"
class ModuleVideoTable
{
    function ModuleVideoTable() {} // constructor  for [Flash IDE]
    //--- function table
    static function initTable(ftable:Array) {
        // *動画再生(URLの|URLを)
        ftable[1] = {func:ModuleVideoFunc.video_play, arg:1};
        // *動画停止()
        ftable[2] = {func:ModuleVideoFunc.video_stop, arg:0};
        // *動画繰り返し再生(URLの|URLを)
        ftable[3] = {func:ModuleVideoFunc.video_playLoop, arg:1};
        // *動画サイズ設定(X,Y,W,Hに|Hで)
        ftable[4] = {func:ModuleVideoFunc.video_setRect, arg:4};
        // *動画クリア()
        ftable[5] = {func:ModuleVideoFunc.video_clear, arg:0};
        // *カメラ表示()
        ftable[20] = {func:ModuleVideoFunc.camera_show, arg:0};
        // *カメラモーション設定(EVENTにLEVELの|EVENTへ)
        ftable[21] = {func:ModuleVideoFunc.camera_setMotion, arg:2};

    }
}
/*
    // *動画再生(URLの|URLを)="ModuleVideo"@1 // 1
    // URLの動画を再生する
    static function video_play(arg:ModuleFunctionArg)
    {
    }
    // *動画停止()="ModuleVideo"@2 // 0
    // 再生中の動画を停止する
    static function video_stop(arg:ModuleFunctionArg)
    {
    }
    // *動画繰り返し再生(URLの|URLを)="ModuleVideo"@3 // 1
    // URLの動画を繰り返し再生する
    static function video_playLoop(arg:ModuleFunctionArg)
    {
    }
    // *動画サイズ設定(X,Y,W,Hに|Hで)="ModuleVideo"@4 // 4
    // 動画プレイヤーのサイズを設定する
    static function video_setRect(arg:ModuleFunctionArg)
    {
    }
    // *動画クリア()="ModuleVideo"@5 // 0
    // 再生中の動画を停止する
    static function video_clear(arg:ModuleFunctionArg)
    {
    }
    // *カメラ表示()="ModuleVideo"@20 // 0
    // ローカルカメラを表示する
    static function camera_show(arg:ModuleFunctionArg)
    {
    }
    // *カメラモーション設定(EVENTにLEVELの|EVENTへ)="ModuleVideo"@21 // 2
    // カメラ画像の切り替わり時に実行するイベントEVENTをLEVEL(0-100)で設定する
    static function camera_setMotion(arg:ModuleFunctionArg)
    {
    }

*/
