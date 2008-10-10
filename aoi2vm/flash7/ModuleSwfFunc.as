
import ModuleSwfClass.*;
import GuiParts.*;

class ModuleSwfFunc extends ModuleBase
{
    // --- 初期化
    // (外部ファイルに分けないで) 埋め込む時はこれを呼ぶ
    static function init() {
        KLog.write("ModuleSwf.version=" + version);
        //--- お決まりの呼び出し
        var m = new ModuleSwfFunc();
        m.module_init("ModuleSwf");
        ModuleSwfTable.initTable(m.ftable);
        //--- 拡張
        initObject();
        // Wiiチェック
        if (System.capabilities.os == "Nintendo Wii") {
            isWii = true;
            Wii.init();
        }
        //---
        test();
    }
    // ---
    function ModuleSwfFunc() {}
    // ---
    static var isWii:Boolean = false;
    static var version:Number = 1001;
    // ---
    static function test() {
        /*
        var k:GuiGrid = new GuiGrid(_root, 0);
        k.setProperty("X",10);
        k.setProperty("Y",10);
        */
        /*
        var e:GuiSprite = new GuiSprite(_root, 0);
        e.setProperty("画像", AValue.create("test.png"));
        e.setProperty("X", AValue.create(10));
        e.setProperty("Y", AValue.create(10));
        */
        /*
        var t:GuiList = new GuiList(_root, 0);
        t.setProperty("アイテム", new Array(1,2,3,4,5));
        t.setProperty("X", 40);
        t.setProperty("Y", 10);
        t.setProperty("W", 300);
        */
    }
    
    static function initObject() {
        stage_w = Stage.width;
        stage_h = Stage.height;
        initScreen();
    }
    static function initScreen() {
        gui_array = new Array();
        gui_count = 0;
        draw_target = 0;
        // create main screen
        gui_array[0] = new GuiScreen(_root, 0); // main screen
        gui_root = gui_array[0]._mc;
        gui_root_id = 0;
        gui_count++;
    }
    
    //------------------------------------------------------------------
    // Variables
    //------------------------------------------------------------------
    // Draw variable
    static var stage_w:Number;
    static var stage_h:Number;
    static var draw_line_color:Number = 0;
    static var draw_line_width:Number = 2;
    static var draw_fill_color:Number = 0xFFFFFF;
    static var draw_fill_alpha:Number = 100;
    static var draw_target:Number     = 0;
    static var font_size:Number = 16;
    static var font_color:Number = 0;
    static var font_name:String = "_ゴシック";
    static var rakugaki_str:String = "";
    static var tile_colors:Array = [
        0x000000,0x0000FF,0xFF0000,0xFF00FF,0x00FF00,0x00FFFF,0xFFFF00,0xFFFFFF,
        0x808080,0x000080,0x800000,0x800080,0x008000,0x008080,0x808000,0x000000
        ]; // タイル描画に使うカラー
    // Gui variable
    static var gui_root:MovieClip;
    static var gui_root_id:Number;
    static var gui_count:Number = 0;
    static var gui_array:/*GuiObject*/Array;
    static var gui_activeParts:Number = 0;
    static var gui_def_x:Number = 8;
    static var gui_def_y:Number = 8;
    static var gui_def_margin_h:Number = 4;
    // Gui Parts Type
    static var TYPE_BUTTON = 100;
    static var TYPE_EDIT   = 101;
    static var TYPE_LABEL  = 102;
    static var TYPE_LIST   = 103;
    static var TYPE_SPRITE = 104;
    static var TYPE_MEMO   = 105;
    static var TYPE_BAR    = 106;
    static var TYPE_GRID   = 107;
    static var TYPE_TURTLE = 108;
    
    //------------------------------------------------------------------
    // GUI function
    
    // --- 関数の定義 ---
    static function gui_create(arg:ModuleFunctionArg) {
        var obj:Object      = arg._args[0];
        var gtype:Number    = arg.getArgNum(1);
        var g:GuiObject     = _gui_create(gtype);
        AValue.changeLinkValue(obj, new Number(g._no)); // set obj no
    }
    static function _gui_create(gtype:Number):GuiObject {
        // IDを取得
        var no:Number = gui_count++;
        var g:GuiObject;
        // type に応じてGUI部品を作成
        switch (gtype) {
        case TYPE_BUTTON:   g = new GuiButton(gui_root, no);    break;
        case TYPE_EDIT:     g = new GuiEdit(gui_root, no);      break;
        case TYPE_LABEL:    g = new GuiLabel(gui_root, no);     break;
        case TYPE_LIST:     g = new GuiList(gui_root, no);      break;
        case TYPE_SPRITE:   g = new GuiSprite(gui_root, no);    break;
        case TYPE_MEMO:     g = new GuiMemo(gui_root, no);      break;
        case TYPE_BAR:      g = new GuiBar(gui_root, no);       break;
        case TYPE_GRID:     g = new GuiGrid(gui_root, no);      break;
        case TYPE_TURTLE:   g = new GuiTurtle(gui_root, no);    break;
        default:
            g = new GuiObject(gui_root, no);
        }
        gui_array[no] = g;
        // 初期値を設定
        var xx = gui_def_x;
        var yy = gui_def_y;
        g.setProperty("Y", yy);
        g.setProperty("X", xx);
        g.setProperty("FONT_SIZE",  font_size);
        g.setProperty("FONT_COLOR", font_color);
        g.setProperty("FONT_NAME",  font_name);
        g.resize();
        return g;
    }
    // ●ラベル作成(TEXTの|TEXTで)          # TEXTのラベルを作成して、IDを返す
    static function create_label(arg:ModuleFunctionArg) {
        var text:String = arg.getArgStr(0);
        var g:GuiObject = _gui_create(TYPE_LABEL);
        g.setProperty("TEXT", text);
        arg.return_num(g._no);
    }
    // ●エディタ作成(TEXTの|TEXTで)        # TEXTの内容でエディタを作成して、IDを返す
    static function create_edit(arg:ModuleFunctionArg) {
        var text:String = arg.getArgStr(0);
        var g:GuiObject = _gui_create(TYPE_EDIT);
        g.setProperty("TEXT", text);
        arg.return_num(g._no);
    }
    // ●リスト作成(ITEMSの|ITEMSで)        # ITEMSを持つリストを作成して、IDを返す
    static function create_list(arg:ModuleFunctionArg) {
        var text:Object = arg._args[0];
        var g:GuiObject = _gui_create(TYPE_LIST);
        g.setProperty("ITEMS", text);
        arg.return_num(g._no);
    }
    // ●スプライト作成                     # スプライトを作成して、IDを返す
    static function create_sprite(arg:ModuleFunctionArg) {
        var g:GuiObject = _gui_create(TYPE_SPRITE);
        arg.return_num(g._no);
    }
    // ●メモ作成(TEXTの|TEXTで)            # TEXTの内容でメモを作成して、IDを返す
    static function create_memo(arg:ModuleFunctionArg) {
        var text:String = arg.getArgStr(0);
        var g:GuiObject = _gui_create(TYPE_MEMO);
        g.setProperty("TEXT", text);
        arg.return_num(g._no);
    }
    // ●ボタン作成(TEXTの|TEXTで)          # TEXTのボタンを作成して、IDを返す
    static function create_button(arg:ModuleFunctionArg) {
        var text:String = arg.getArgStr(0);
        var g:GuiObject = _gui_create(TYPE_BUTTON);
        g.setProperty("TEXT", text);
        g.setProperty("EVENT", text+"イベント");
        arg.return_num(g._no);
    }
    // ●表示(Sを|Sと|Sで|Sの)              # 画面にSを表示する(実際はラベルを作成してIDを返す)
    static function print(arg:ModuleFunctionArg) {
        create_label(arg);
    }
    // ●グリッド作成(ITEMSで|ITEMSの)      # ITEMSを持つグリッドを作成し、IDを返す
    static function create_grid(arg:ModuleFunctionArg) {
        var text:Object = arg._args[0];
        var g:GuiObject = _gui_create(TYPE_GRID);
        g.setProperty("ITEMS", text);
        arg.return_num(g._no);
    }
    // ●カメ次郎召喚                       # カメ次郎を召喚してIDを返す
    static function create_turtle(arg:ModuleFunctionArg) {
        var g:GuiObject = _gui_create(TYPE_TURTLE);
        g.setProperty("X", (stage_w) / 2);
        g.setProperty("Y", (stage_h) / 2);
        arg.return_num(g._no);
    }
    // ●歩前進(IDをN|IDが)                 # カメ次郎をN歩前へ進ませる
    static function turtle_forward(arg:ModuleFunctionArg) {
        var id:Number = arg.getArgNum(0);
        var n:Number  = arg.getArgNum(1);
        var g:GuiTurtle = GuiTurtle(gui_array[id]);
        g.turtle_forward(n);
        // _turtle_wait(g, arg); // no wait
    }
    // ●度右回転(IDをN|IDが)               # カメ次郎をN度左回転させる
    static function turtle_left(arg:ModuleFunctionArg) {
        var id:Number = arg.getArgNum(0);
        var n:Number  = arg.getArgNum(1);
        var g:GuiTurtle = GuiTurtle(gui_array[id]);
        g.turtle_turnLeft(n);
    }
    // ●度左回転(IDをN|IDが)               # カメ次郎をN度右回転させる
    static function turtle_right(arg:ModuleFunctionArg) {
        var id:Number = arg.getArgNum(0);
        var n:Number  = arg.getArgNum(1);
        var g:GuiTurtle = GuiTurtle(gui_array[id]);
        g.turtle_turnRight(n);
    }
    static function _turtle_wait(g:GuiTurtle, arg:ModuleFunctionArg) {
        var name:String = "_wait_turtle_" + g._no;
        _root.createEmptyMovieClip(name, _root.getNextHighestDepth());
        var m:MovieClip = _root[name];
        arg.flag_quit = true;
        m.onEnterFrame = function () {
            if (g.turtle_cmd.length > 0) return;
            arg.flag_quit = false;
        };
    }
    // ●カメ待機(IDを|IDの)                # カメ次郎IDの動作終了まで待機する
    static function turtle_wait(arg:ModuleFunctionArg) {
        var id:Number = arg.getArgNum(0);
        var g:GuiTurtle = GuiTurtle(gui_array[id]);
        _turtle_wait(g, arg);
    }
    // ●マウスポインタ可視設定(Bに|Bへ|Bで)# マウスポインタを表示するか設定する
    static var _mouse_pointer_visible:Number = 1;
    static function mouse_setVisible(arg:ModuleFunctionArg) {
        var b:Number = arg.getArgNum(0);
        _mouse_pointer_visible = b;
        if (b != 0) {
            Mouse.show();
        } else {
            Mouse.hide();
        }
    }
    // ●マウスポインタ可視取得             # マウスポインタを表示するか調べて返す
    static function mouse_getVisible(arg:ModuleFunctionArg) {
        arg.return_num(_mouse_pointer_visible);
    }
    // ●ローカル読む(FILEを|FILEから)      # ブラウザローカル領域(SharedObject)のFILEを読み込んで返す
    static function local_read(arg:ModuleFunctionArg) {
        var fname:String = arg.getArgStr(0);
        var aoi_so:SharedObject = SharedObject.getLocal("aoi_so");
        arg.return_str( aoi_so.data[fname] );
    }
    // ●ローカル書く(FILEにVを|FILEへ)     # ブラウザローカル領域(SharedObject)のFILEへVを書き込む
    static function local_write(arg:ModuleFunctionArg) {
        var fname:String = arg.getArgStr(0);
        var v:String     = arg.getArgStr(1);
        var aoi_so:SharedObject = SharedObject.getLocal("aoi_so");
        aoi_so.data[fname] = v;
    }
    static function gui_set(arg:ModuleFunctionArg) {
        var obj:Number  = arg.getArgNum(0);
        var prop:String = arg.getArgStr(1);
        var v:Object    = arg._args[2];
        var g:GuiObject = gui_array[obj];
        gui_activeParts = obj;
        g.setProperty(prop, AValue.getLink(v));
    }
    static function gui_get(arg:ModuleFunctionArg) {
        var obj:Number  = arg.getArgNum(0);
        var prop:String = arg.getArgStr(1);
        var g:GuiObject = gui_array[obj];
        var v:Object    = g.getProperty(prop);
        gui_activeParts = obj;
        arg._result = v;
    }
    static function gui_getActive(arg:ModuleFunctionArg) {
        arg.return_num(ModuleSwfFunc.gui_activeParts);
    }
    static function gui_move(arg:ModuleFunctionArg) {
        gui_def_x = arg.getArgNum(0);
        gui_def_y = arg.getArgNum(1);
    }
    // 部品削除
    static function gui_remove(arg:ModuleFunctionArg) {
        var obj_id:Number = arg.getArgNum(0);
        KLog.write("gui_remove=" + obj_id);
        if (obj_id == 0) return;
        var g:GuiObject = gui_array[obj_id];
        g._mc.removeMovieClip();
        delete g;
        gui_array[obj_id] = undefined;
    }
    static function gui_removeAll(arg:ModuleFunctionArg) {
        for (var i = 0; i < gui_array.length; i++) {
            var g:GuiObject = gui_array[i];
            if (g == undefined) continue;
            g._mc.removeMovieClip();
            delete gui_array[i];
            gui_array[i] = undefined;
        }
        initScreen();
    }
    // ●最前面設定(OBJを) # GUI部品OBJを最前面に移動する
    static function gui_bringToFront(arg:ModuleFunctionArg) {
        var id = arg.getArgNum(0);
        var g:GuiObject = gui_array[id];
        g._mc.swapDepths(g._mc._parent.getNextHighestDepth());
    }
    // ●画面クリア # 描画対象に描画された内容を消去する
    static function draw_clear(arg:ModuleFunctionArg) {
        var g:GuiObject = gui_array[draw_target];
        g._mc.clear();
    }
    // ●センタリング(OBJを)                # GUI部品OBJを中央に移動する
    static function gui_setCenter(arg:ModuleFunctionArg) {
        var id = arg.getArgNum(0);
        var g:GuiObject = gui_array[id];
        var x:Number = (stage_w - g._w) / 2;
        var temp_x:Number = gui_def_x;
        g.setProperty("X", AValue.create(x));
        gui_def_x = temp_x;
    }
    //------------------------------------------------------------------
    // Draw function
    
    static function getDrawCanvas():MovieClip {
        return GuiObject(gui_array[draw_target])._mc;
    }
    
    // ●線(X1,Y1からX2,Y2へ) # 線を引く
    static function draw_line(arg:ModuleFunctionArg) {
        var x1:Number = arg.getArgNum(0);
        var y1:Number = arg.getArgNum(1);
        var x2:Number = arg.getArgNum(2);
        var y2:Number = arg.getArgNum(3);
        var g:GuiObject = gui_array[draw_target];
        g._mc.lineStyle(draw_line_width, draw_line_color);
        g._mc.moveTo(x1, y1);
        g._mc.lineTo(x2, y2);
    }
    // ●四角(X1,Y1からX2,Y2へ) # 四角形(矩形)を描画する
    static function draw_rectangle(arg:ModuleFunctionArg) {
        var x1:Number = arg.getArgNum(0);
        var y1:Number = arg.getArgNum(1);
        var x2:Number = arg.getArgNum(2);
        var y2:Number = arg.getArgNum(3);
        var g:GuiObject = gui_array[draw_target];
        g._mc.lineStyle(draw_line_width, draw_line_color);
        if (draw_fill_alpha > 0) {
            g._mc.beginFill(draw_fill_color, draw_fill_alpha);
        }
        g._mc.moveTo(x1, y1);
        g._mc.lineTo(x2, y1);
        g._mc.lineTo(x2, y2);
        g._mc.lineTo(x1, y2);
        g._mc.lineTo(x1, y1);
        if (draw_fill_alpha > 0) {
            g._mc.endFill();
        }
    }
    // ●ブロック描画(W,Hで,DATAを) # 幅W,高さHを1ブロックとして二次元配列DATAを描画する
    static function draw_blocks(arg:ModuleFunctionArg) {
        // get arguments
        var w:Number  = arg.getArgNum(0);
        var h:Number  = arg.getArgNum(1);
        var ary:Array = arg.getArgArray(2);
        // get target
        var g:GuiObject = gui_array[draw_target];
        //
        for (var row = 0; row < ary.length; row++) {
            var cols:Array = AValue.convArray(ary[row]);
            for (var col = 0; col < cols.length; col++) {
                var cno:Number = AValue.convNumber(cols[col]);
                var xx:Number = col * w;
                var yy:Number = row * h;
                KDraw.rectangle(g._mc, xx, yy, (xx+w), (yy+h), cno, draw_line_color, draw_line_width);
            }
        }
    }
    // circle method (x1, y1) - (x2, y2)
    static function drawCircle(mc:MovieClip, x1:Number,y1:Number,x2:Number,y2:Number){
        var w = x2 - x1;
        var h = y2 - y1;
        var w2 = w / 2;
        var h2 = h / 2;
        var x = x1 + w2;
        var y = y1 + h2;
        drawOval(mc, x, y, w2, h2);
    }
    // circle method center(x, y), 半径(width, height)
    static function drawOval(mc:MovieClip, x:Number,y:Number,width:Number,height:Number){
        mc.lineStyle(draw_line_width, draw_line_color);
        if (draw_fill_alpha > 0) {
            mc.beginFill(draw_fill_color, draw_fill_alpha);
        }
        var j = width * 0.70711;
        var n = height * 0.70711;
        var i = j - (height - n) * width / height;
        var m = n - (width - j) * height / width;
        mc.moveTo(x + width, y);
        mc.curveTo(x + width, y - m, x + j, y - n);
        mc.curveTo(x + i, y - height, x, y - height);
        mc.curveTo(x - i, y - height, x - j, y - n);
        mc.curveTo(x - width, y - m, x - width, y);
        mc.curveTo(x - width, y + m, x - j, y + n);
        mc.curveTo(x - i, y + height, x, y + height);
        mc.curveTo(x + i, y + height, x + j, y + n);
        mc.curveTo(x + width, y + m, x + width, y);
        if (draw_fill_alpha > 0) {
            mc.endFill();
        }
    }
    // ●円描画(X1,Y1からX2,Y2へ) # 円を描画する
    static function draw_circle(arg:ModuleFunctionArg) {
        var x1:Number = arg.getArgNum(0);
        var y1:Number = arg.getArgNum(1);
        var x2:Number = arg.getArgNum(2);
        var y2:Number = arg.getArgNum(3);
        var g:GuiObject = gui_array[draw_target];
        drawCircle(g._mc, x1, y1, x2, y2);
    }
    // ●多角形(ARRAYの) # 多角形を描画する
    static function draw_poly(arg:ModuleFunctionArg) {
        var ary:Array = arg.getArgArray(0);
        var mc:MovieClip = getDrawCanvas();
        // basic point
        mc.lineStyle(draw_line_width, draw_line_color);
        if (draw_fill_alpha > 0) {
            mc.beginFill(draw_fill_color, draw_fill_alpha);
        }
        for (var i = 0; i < ary.length; i++) {
            var xy:Array = Array(AValue.getLink( ary[i] ));
            var xx:Number = Number(AValue.getLink(xy[0]));
            var yy:Number = Number(AValue.getLink(xy[1]));
            if (i == 0) {
                mc.moveTo(xx, yy);
            } else {
                mc.lineTo(xx, yy);
            }
        }
        if (draw_fill_alpha > 0) {
            mc.endFill();
        }
    }
    
    // ●線色設定(COLORに)                  # 線色を指定
    static function draw_setLineColor(arg:ModuleFunctionArg) {
        draw_line_color = arg.getArgNum(0);
        KLog.write("draw_line_color=" + draw_line_color);
    }
    // ●線色取得                           # 線色を取得
    static function draw_getLineColor(arg:ModuleFunctionArg) {
        arg.return_num(draw_line_color);
    }
    // ●線太さ設定(Wに)                    # 線太さを指定
    static function draw_setLineWidth(arg:ModuleFunctionArg) {
        draw_line_width = arg.getArgNum(0);
    }
    // ●線太さ取得                         # 線の太さを取得
    static function draw_getLineWidth(arg:ModuleFunctionArg) {
        arg.return_num(draw_line_width);
    }
    // ●塗り色設定(COLORに)                # 塗り色を指定
    static function draw_setFillColor(arg:ModuleFunctionArg) {
        draw_fill_color = arg.getArgNum(0);
    }
    // ●塗り色取得                         # 塗り色を取得
    static function draw_getFillColor(arg:ModuleFunctionArg) {
        arg.return_num(draw_fill_color);
    }
    // ●透明度設定(PERCENTに)              # 塗り透明度を指定
    static function draw_setAlpha(arg:ModuleFunctionArg) {
        draw_fill_alpha = arg.getArgNum(0);
    }
    // ●透明度取得                         # 塗り透明度を取得
    static function draw_getAlpha(arg:ModuleFunctionArg) {
        arg.return_num(draw_fill_alpha);
    }
    // ●描画対象設定(OBJが|OBJに|OBJへ)    # 描画対象オブジェクトを指定
    static function draw_setTarget(arg:ModuleFunctionArg) {
        draw_target = arg.getArgNum(0);
    }
    // ●描画対象取得                       # 描画対象オブジェクトのIDを返す
    static function draw_getTarget(arg:ModuleFunctionArg) {
        arg.return_num(draw_target);
    }
    // ●フォントサイズ設定(SIZEに|SIZEへ)  # フォントサイズを設定
    static function font_setSize(arg:ModuleFunctionArg) {
        font_size = arg.getArgNum(0);
    }
    // ●フォントサイズ取得                 # フォントサイズを取得
    static function font_getSize(arg:ModuleFunctionArg) {
        arg.return_num(font_size);
    }
    // ●フォント色設定(COLに|COLへ)        # フォント色(0xRRGGBB)を設定
    static function font_setColor(arg:ModuleFunctionArg) {
        font_color = arg.getArgNum(0);
    }
    // ●フォント色取得                     # フォント色を取得
    static function font_getColor(arg:ModuleFunctionArg) {
        arg.return_num(font_color);
    }
    // ●フォント種類設定(NAMEに|NAMEへ)    # フォント種類(「_ゴシック」など)を設定
    static function font_setName(arg:ModuleFunctionArg) {
        font_name = arg.getArgStr(0);
    }
    // ●フォント種類取得                   # フォント種類を取得
    static function font_getName(arg:ModuleFunctionArg) {
        arg.return_str(font_name);
    }
    // *親部品設定(OBJが|OBJに|OBJへ)="ModuleSwf"@140 // 1
    // これから生成する部品の親オブジェクトのIDを指定
    static function gui_setParent(arg:ModuleFunctionArg)
    {
        gui_root_id = arg.getArgNum(0);
        if (gui_root_id == -1) {
            gui_root = _root;
        } else {
            gui_root = gui_array[gui_root_id]._mc;
        }
    }
    // *親部品取得()="ModuleSwf"@141 // 0
    // これから生成する部品の親オブジェクトのIDを返す
    static function gui_getParent(arg:ModuleFunctionArg)
    {
        arg.return_num(gui_root_id);
    }
    //------------------------------------------------------------------
    // Network function
    static var net_event_data:Object;
    // ●読む(URLを|URLから) # URLにあるデータを取得して返す
    static function net_read(arg:ModuleFunctionArg) {
        var url:String = arg.getArgStr(0);
        //
        arg.flag_quit = true;
        var lv:LoadVars = new LoadVars();
        lv.onData = function (dat:String) {
            arg.swap_stacktop(AValue.create(dat));
            arg.flag_quit = false;
        };
        lv.load(url);
    }
    static function net_readASync(arg:ModuleFunctionArg) {
        var url:String = arg.getArgStr(0);
        var event_name:String = arg.getArgStr(1);
        //
        var lv:LoadVars = new LoadVars();
        lv.arg = arg;
        lv.event_name = event_name;
        lv.onData = function (dat:String) {
            ModuleSwfFunc.net_event_data = AValue.create(dat);
            ModuleFunctionApi.addEvent(lv.event_name);
        };
        lv.load(url);
    }
    // ●イベントデータ # イベントが起きたときデータが代入される
    static function net_getEventData(arg:ModuleFunctionArg) {
        arg._result = net_event_data;
    }
    // ●ポスト(URLにDATAを|URLへ) # URLにデータDATA(ハッシュ)をポストし、サーバーからの応答を取得して返す
    static function net_post(arg:ModuleFunctionArg) {
        var url:String = arg.getArgStr(0);
        var h:Object   = arg._args[1];
        // 受信イベント
        arg.flag_quit = true;
        var recv_lv:LoadVars = new LoadVars();
        var send_lv:LoadVars = new LoadVars();
        recv_lv.onData = function (dat:String) {
            arg.swap_stacktop(dat);
            arg.flag_quit = false;
        };
        // 送信データを指定
        h = AValue.convHash(h);
        for (var key in h) {
            var v = AValue.convString(h[key]);
            send_lv[key] = v;
        }
        send_lv.sendAndLoad(url, recv_lv, "POST");
    }
    //------------------------------------------------------------------
    // System function    
    // ●秒待つ(N) # N秒待つ
    static function wait(arg:ModuleFunctionArg) {
        var n:Number = arg.getArgNum(0);
        n *= 1000;
        arg.flag_quit = true;
        var tid:Number;
        tid = setInterval(function(){
            clearInterval(tid);
            arg.flag_quit = false;
        },n);
    }
    // ●秒タイマー設定(EVENTに,N|EVENTを|EVENTへ) # N秒後にEVENT関数(文字列で指定)を呼ぶタイマーを設定し、タイマーIDを得る
    static function timer_set(arg:ModuleFunctionArg) {
        var event:String = arg.getArgStr(0);
        var sec:Number   = arg.getArgNum(1);
        sec *= 1000;
        var tid:Number   = setInterval(function(){
            ModuleFunctionApi.addEvent(event);
        },sec);
        arg.return_num(tid);
    }
    // ●タイマー解除(ID) # 「秒タイマー設定」命令で得たタイマーIDを指定してタイマーを解除する
    static function timer_clear(arg:ModuleFunctionArg) {
        var id:Number = arg.getArgNum(0);
        clearInterval(id);
    }
    //------------------------------------------------------------------
    // Key
    // ●最後キー取得 # 最後に押されたキーコードを得る
    static function key_code(arg:ModuleFunctionArg) {
        var code:Number;
        if (isWii) {
            code = Wii.lastCode;
        } else {
            code = Key.getCode();
        }
        arg.return_num(code);
    }
    // ●文字キー取得 # 文字キーの状態を調べる
    static function key_getascii(arg:ModuleFunctionArg) {
        var code = Key.getAscii();
        arg.return_num(code);
    }
    // ●キー状態(KEYの) # KEYを押下中か状態を調べる。押されていれば1、押されてなければ0
    static function key_isdown(arg:ModuleFunctionArg) {
        var code   = arg.getArgNum(0);
        var status:Boolean;
        if (isWii) {
            status = Wii.isDown(code);
        } else {
            status = Key.isDown(code);
        }
        arg.return_num((status) ? 1 : 0);
    }
    // *キー押した時設定(EVENTに)="ModuleSwf"@57 // 1
    // キー押した時のイベントを設定する
    static function key_setDownEvent(arg:ModuleFunctionArg)
    {
        var e = arg.getArgStr(0);
        var obj = new Object();
        obj.onKeyDown = function () {
            ModuleFunctionApi.addEvent(e);
        };
        Key.addListener(obj);
    }
    // *キー離した時設定(EVENTに)="ModuleSwf"@58 // 1
    // キー離した時のイベントを設定する
    static function key_setUpEvent(arg:ModuleFunctionArg)
    {
        var e = arg.getArgStr(0);
        var obj = new Object();
        obj.onKeyUp = function () {
            ModuleFunctionApi.addEvent(e);
        };
        Key.addListener(obj);
    }
    // ●URL移動(URLに|URLへ|URLまで)       # URLにページを移動する
    static function page_jump(arg:ModuleFunctionArg) {
        var url:String = arg.getArgStr(0);
        _root.getURL(url);
    }
    // ●接触判定(OBJ1とOBJ2が|OBJ2で|OBJ2の) # GUI部品OBJ1とOBJ2が接触しているか判定してはいかいいえを返す
    static function gui_hitTest(arg:ModuleFunctionArg) {
        var o1:Number = arg.getArgNum(0);
        var o2:Number = arg.getArgNum(1);
        var g1:GuiObject = gui_array[o1];
        var g2:GuiObject = gui_array[o2];
        if (g1._mc.hitTest(g2._mc)) {
            arg.return_num(1);
        } else {
            arg.return_num(0);
        }
    }
    // ●SWFLOG(N) # SWFLOG
    static function swflog(arg:ModuleFunctionArg) {
        var s = arg.getArgStr(0);
        KLog.write(s);
        arg.return_str(s);
    }
    // ●演奏(URLを|URLで)                  # URLにある音声ファイルを演奏する
    static var _play_snd:Sound;
    static function play(arg:ModuleFunctionArg) {
        var url:String = arg.getArgStr(0);
        // ロードを待たないで実行を継続する
        _play_snd = new Sound();
        _play_snd.onLoad = function (ok) {
            if (!ok) return;
            ModuleSwfFunc._play_snd.start(0);
        };
        _play_snd.loadSound(url);
    }
    // ●演奏停止                           # 演奏を中止する
    static function stop(arg:ModuleFunctionArg) {
        _play_snd.stop();
    }
    // ●FSCOMMAND(CMD,PARAMS)              # 拡張機能(fscommand)でCMDにPARAMSで呼び出す
    static function _fscommand(arg:ModuleFunctionArg) {
        var cmd:String = arg.getArgStr(0);
        var pms:String = arg.getArgStr(1);
        fscommand(cmd,pms);
    }
    // ●FSCOMMAND2(CMD,PARAMS)             # 拡張機能(fscommand2)でCMDにPARAMSで呼び出し、結果を返す
    static function _fscommand2(arg:ModuleFunctionArg) {
        var cmd:String = arg.getArgStr(0);
        var pms:String = arg.getArgStr(1);
        var res = FSCommand2(cmd,pms);
        arg._result = res;
    }
    // ●値設定(OBJのPROPにVALUEを|PROPへ)  # FlashのオブジェクトOBJのプロパティPROPに値VALUEを代入する
    static function object_set(arg:ModuleFunctionArg) {
        var obj:String = arg.getArgStr(0);
        var prop:String = arg.getArgStr(1);
        var value:Object = arg.getArgStr(2);
        var o = eval(obj);
        o[prop] = AValue.getLink(value);
    }
    // ●値取得(OBJのPORPから|PROPを)       # FlashのオブジェクトOBJのプロパティPROPを取得して返す
    static function object_get(arg:ModuleFunctionArg) {
        var obj:String = arg.getArgStr(0);
        var prop:String = arg.getArgStr(1);
        var o = eval(obj);
        arg._result = o[prop];
    }
    // ●SWF実行(OBJのMETHODをARGで)        # FlashのオブジェクトOBJのMETHODを引数ARGで呼んで結果を返す
    static function object_call(arg:ModuleFunctionArg) {
        var obj:String  = arg.getArgStr(0);
        var prop:String = arg.getArgStr(1);
        var v:Object  = arg.getArgStr(2);
        var o = eval(obj);
        v = AValue.getLink(v);
        var res = o[prop](v);
        arg._result = res;
    }
    // ●RGB(R,G,B)                         # Red,Green,Blueの3色を混ぜたカラーコードを返す
    static function rgb(arg:ModuleFunctionArg) {
        var r:Number = arg.getArgNum(0);
        var g:Number = arg.getArgNum(1);
        var b:Number = arg.getArgNum(2);
        r = r & 0xFF;
        g = g & 0xFF;
        b = b & 0xFF;
        arg.return_num((r << 16) | (g << 8) | (b));
    }
    // ●マウスポインタ画像変更(IMAGEに)    # マウスポインタを表示する画像を変更する
    static function mouse_changeImage(arg:ModuleFunctionArg) {
        var image:String = arg.getArgStr(0);
        Mouse.hide();
        var mc:MovieClip;
        var sub_mc:MovieClip;
        _root.createEmptyMovieClip("mouse_pointer_mc_", _root.getNextHighestDepth());
        mc = _root["mouse_pointer_mc_"];
        var eh:KEventHandler = KEventHandler.getHandler(_root);
        eh.addListener( {
            onMouseMove:function(){
                mc._x = _root._xmouse;
                mc._y = _root._ymouse;
                mc.swapDepths(_root.getNextHighestDepth());
            }
        } );
        mc.createEmptyMovieClip("sub", 100);
        sub_mc = mc["sub"];
        image = KUtils.getModulePath(image);
        sub_mc.loadMovie(image);
    }
    // ●マウス落書モード開始               # マウスで画面に落書できるようにする
    static function draw_mousepen_start(arg:ModuleFunctionArg) {
        var mc:MovieClip;
        var isdown:Boolean = false;
        var oldx:Number;
        var oldy:Number;
        var oldc:Number = ModuleSwfFunc.draw_line_color;
        var oldw:Number = ModuleSwfFunc.draw_line_width;
        _root.createEmptyMovieClip("draw_mouse_penmode", _root.getNextHighestDepth());
        mc = _root["draw_mouse_penmode"];
        rakugaki_str = "";
        rakugaki_str += "c" + oldc;
        rakugaki_str += "w" + oldw;
        var eh:KEventHandler = KEventHandler.getHandler(_root);
        eh.addListener( {
            onMouseDown:function() {
                isdown = true;
                oldx = Math.floor( _root._xmouse );
                oldy = Math.floor( _root._ymouse );
                if (oldc != ModuleSwfFunc.draw_line_color) {
                    oldc = ModuleSwfFunc.draw_line_color;
                    ModuleSwfFunc.rakugaki_str += "c" + ModuleSwfFunc.draw_line_color;
                }
                if (oldw != ModuleSwfFunc.draw_line_width) {
                    oldw = ModuleSwfFunc.draw_line_width;
                    ModuleSwfFunc.rakugaki_str += "w" + ModuleSwfFunc.draw_line_width;
                }
                ModuleSwfFunc.rakugaki_str += "p" + oldx + "," + oldy;
            },
            onMouseUp:function() {
                isdown = false;
            },
            onMouseMove:function() {
                if ( isdown ) {
                    var s:String = "";
                    var xx:Number = _root._xmouse;
                    var yy:Number = _root._ymouse;
                    KDraw.line(mc, oldx, oldy, 
                        xx, yy, 
                        ModuleSwfFunc.draw_line_color, 
                        ModuleSwfFunc.draw_line_width
                    );
                    var dx:Number = Math.floor(xx - oldx);
                    var dy:Number = Math.floor(yy - oldy);
                    if (dx == 0 || dy == 0) {
                        if (dx == 0) {
                            if (dy > 0) {
                                s = "d" + dy;
                            } else {
                                s = "u" + (-1 * dy);
                            }
                        }
                        else if (dy == 0) {
                            if (dx > 0) {
                                s = "r" + dx
                            } else {
                                s = "l" + (-1 * dx);
                            }
                        }
                    }
                    else {
                        s = "m" + dx + "," + dy;
                    }
                    oldx = xx;
                    oldy = yy;
                    ModuleSwfFunc.rakugaki_str += s;
                }
            }
        } );
    }
    // ●マウス落書モード終了               # マウスで画面に落書モードを終了する
    static function draw_mousepen_end(arg:ModuleFunctionArg) {
        var mc:MovieClip = _root["draw_mouse_penmode"];
        mc.removeMovieClip();
        arg.return_str(rakugaki_str);
        rakugaki_str = "";
    }
    // *マクロ描画(SをWAITで)="ModuleSwf"@37 // 2
    // マクロ文字列Sで描画する(WAITミリ秒ずつ描画)
    static function draw_macro(arg:ModuleFunctionArg)
    {
        var str:String = arg.getArgStr(0);
        var wait:Number  = arg.getArgNum(1);
        var macro:KDrawMacro = new KDrawMacro(str, wait, getDrawCanvas());
        macro.draw();
    }
    // *タイル描画(W,HでDATAを)="ModuleSwf"@38 // 3
    // 幅W,高さHを1タイルとして16色文字列の配列DATAを描画する
    static function draw_tiles(arg:ModuleFunctionArg)
    {
        var w:Number = arg.getArgNum(0);
        var h:Number = arg.getArgNum(1);
        var a:Array  = arg.getArgArray(2);
        var mc:MovieClip = getDrawCanvas();
        
        a = AValue.convArrayEx(a);
        for (var y = 0; y < a.length; y++) {
            var line:String = String(a[y]);
            line = line.toUpperCase();
            KLog.write("line=" + line);
            for (var x = 0; x < line.length; x++) {
                var c:String = line.charAt(x);
                var code:Number = 0;
                if ('0' <= c && c <= '9') {
                    code = c.charCodeAt(0) -  String("0").charCodeAt(0);
                } else {
                    code = 10 + (c.charCodeAt(0) -  String("A").charCodeAt(0));
                    if (code >= 16) { code = 0; }
                }
                if (code == 15) continue;
                var col:Number = tile_colors[code];
                KDraw.rectangle(mc, x*w, y*h, (x+1)*w, (y+1)*h,
                    col, draw_line_color, draw_line_width);
            }
        }
    }
    // *ホワイトアウト(Vで)="ModuleSwf"@150 // 1
    // 画面を白くフェイドアウトする(Vには速度を)
    static function effect_whiteout(arg:ModuleFunctionArg)
    {
        var power:Number = arg.getArgNum(0);
        var mc:MovieClip = _root.createEmptyMovieClip("effect_whiteout", _root.getNextHighestDepth());
        mc._alpha = 0;
        KDraw.rectangle(mc, 0,0,stage_w,stage_h,draw_fill_color,0,0);
        arg._mac.flag_quit = true;
        var tid:Number;
        tid = setInterval(function(){
            mc._alpha += power;
            if (mc._alpha > 100) {
                mc.removeMovieClip();
                clearInterval(tid);
                arg._mac.flag_quit = false;
            }
        },100);
    }
    // *画面スライド(OBJ1からOBJ2へVで)="ModuleSwf"@151 // 3
    // 画面を表す部品OBJ1からOBJ2へスライドさせる(Vは速度)
    static function effect_slide(arg:ModuleFunctionArg)
    {
        var o1:Number    = arg.getArgNum(0);
        var o2:Number    = arg.getArgNum(1);
        var power:Number = arg.getArgNum(2);
        
        var mc1:MovieClip = gui_array[o1]._mc;
        var mc2:MovieClip = gui_array[o2]._mc;
        
        mc1._x = 0;
        mc1._y = 0;
        mc2._x = stage_w;
        mc2._y = 0;
        mc1._visible = true;
        mc2._visible = true;
        
        var def_w = mc1._width;
        var def_h = mc1._height;
        
        arg._mac.flag_quit = true;
        var tid:Number;
        tid = setInterval(function(){
            mc1._x += power;
            mc2._x -= power;
            mc1._alpha = 100 - (mc2._x / ModuleSwfFunc.stage_w) * 100;
            mc1._width  *= 0.8
            mc1._height *= 0.8
            power *= 1.5;
            if (mc2._x < 0) {
                mc2._x = 0;
                mc1._visible = false;
                mc1._alpha   = 100;
                mc1._width  = def_w;
                mc1._height = def_h;
                clearInterval(tid);
                arg._mac.flag_quit = false;
            }
        },100);
    }
    // *画面スライド2(OBJ1からOBJ2へVで)="ModuleSwf"@152 // 3
    // 画面を表す部品OBJ1からOBJ2へスライドさせる(Vは速度)
    static function effect_slide2(arg:ModuleFunctionArg)
    {
        var o1:Number    = arg.getArgNum(0);
        var o2:Number    = arg.getArgNum(1);
        var power:Number = arg.getArgNum(2);
        
        var mc1:MovieClip = gui_array[o1]._mc;
        var mc2:MovieClip = gui_array[o2]._mc;
        var mc3:MovieClip = _root.createEmptyMovieClip("effect_sliede_mc", _root.getNextHighestDepth());
        mc3._alpha = 0;
        KDraw.rectangle(mc3, 0,0,stage_w, stage_h,draw_fill_color,0,0);
        
        mc1._x = 0;
        mc1._y = 0;
        mc2._x = stage_w;
        mc2._y = 0;
        mc3._x = 0;
        mc3._y = 0;
        mc1._visible = true;
        mc2._visible = true;
        
        arg._mac.flag_quit = true;
        var tid:Number;
        tid = setInterval(function(){
            mc1._x -= power;
            mc3._x = mc1._x;
            mc2._x -= power;
            mc3._alpha = 100 - (mc2._x / ModuleSwfFunc.stage_w) * 100;
            power *= 1.5;
            if (mc2._x < 0) {
                mc2._x = 0;
                mc1._visible = false;
                mc3.removeMovieClip();
                clearInterval(tid);
                arg._mac.flag_quit = false;
            }
        },100);
    }
    // *マスク設定(MASKをOBJに|OBJへ)="ModuleSwf"@39 // 2
    // GUI部品MASKをGUI部品OBJにマスクとして設定する
    static function gui_setMask(arg:ModuleFunctionArg)
    {
        var mask_mc:MovieClip = gui_array[arg.getArgNum(0)]._mc;
        var obj_mc:MovieClip = gui_array[arg.getArgNum(1)]._mc;
        KLog.write("mask="+mask_mc);
        KLog.write("obj="+obj_mc);
        obj_mc.setMask(mask_mc);
    }
}

