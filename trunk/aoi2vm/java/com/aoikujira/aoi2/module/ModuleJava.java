/*
 * ModuleJava.java
 *
 * Created on 2007/03/23, 9:45
 */

package com.aoikujira.aoi2.vm.module;

/**
 *
 * @author desk
 */
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.sql.*;

import com.aoikujira.aoi2.avalue.AValue;
import com.aoikujira.aoi2.avalue.AValueHashtable;
import com.aoikujira.aoi2.compiler.*;
import com.aoikujira.aoi2.vm.*;
import com.aoikujira.utils.KUtils;
import com.aoikujira.utils.StringVector;

public class ModuleJava {
    
    public ModuleJava() {
    }
    
    public void aoimodule_call(int func_no, AFunctionArg arg) {
        ModuleJavaTable.call(func_no, arg);
    }
    public int aoimodule_getArgCount(int id) {
        return ModuleJavaTable.getArgCount(id);
    }
    
    // ●表示(Sを|Sと|Sで) # Sを表示する
    public static void print(AFunctionArg arg) {
        String s = arg.getStr(0);
        PrintWriter out = arg.mac.parent.out;                
        if (s != null) {
            out.println(s);
        }
    }
    // ●環境変数取得(Sの) # 環境変数Sを取得して返す
    public static void getenv(AFunctionArg arg) {
        String name = arg.getStr(0);
        String res = getenv(name);
        arg.setResult(res);
    }
    // ●バイト読む(BYTEを) # 標準入力からBYTEバイトだけ取得して返す
    public static void readByte(AFunctionArg arg) {
        int len = arg.getInt(0);
        String s = KUtils.stdin_readByte(len);
        arg.setResult(s);
    }
    // ●一行読む # 標準入力から一行取得して返す
    public static void readLine(AFunctionArg arg) {
        BufferedReader br = new BufferedReader(
                new InputStreamReader(System.in));
        String s;
        try {
            s = br.readLine();
        } catch (IOException e) {
            s = "";
        }
        arg.setResult(s);
    }
    
    public static String shell_command(String cmd) {
        try {
            CommandExecuter cmdexec = new CommandExecuter();
            String res = cmdexec.doExec(cmd);
            return res;
        } catch (IOException e) {
            throw new AOIRuntimeError(ErrMsg.ExecCommand + e.getMessage());
        }
    }
    
    // ●起動(CMDを) # シェルでコマンドCMDを実行する
    public static void exec(AFunctionArg arg) {
        String cmd = arg.getStr(0);
        arg.setResult(shell_command(cmd));
    }
    // ●開く(FILEを) # FILEの内容を全部読んで返す
    public static void file_load(AFunctionArg arg) {
        AValue f = arg.getArg(0);
        try {
            String fname = f.toString();
            if ( !KUtils.fileExists(fname) ) {
                String base_path = KUtils.addLastPathFlag( arg.mac.parent.base_path );
                fname = base_path + fname;
            }
            String s = KUtils.loadFromFile(fname);
            arg.result = new AValue(s);
        } catch (Exception e) {
            throw new AOIRuntimeError(ErrMsg.FileLoadError + ":" + 
                    f.toString() + ":" + e.getMessage());
        }
    }
    // ●保存(SをFILEに|FILEへ) # 文字列Sの内容をFILEへ保存する
    public static void file_save(AFunctionArg arg) {
        AValue s = arg.getArg(0);
        AValue f = arg.getArg(1);
        KUtils.saveToFile(f.toString(), s.toString());
    }
    // ●存在するか(FILEが) # FILEが存在するか調べて、はい(=1)かいいえ(=0)で返す
    public static void file_exists(AFunctionArg arg) {
        File file = new File(arg.getStr(0));
        boolean b = file.exists();
        arg.setResult(b ? 1 : 0);
    }
    // ●ファイル削除(FILEの) # FILEを削除する
    public static void file_delete(AFunctionArg arg) {
        File file = new File(arg.getStr(0));
        boolean b = file.delete();
        arg.setResult(b ? 1 : 0);
    }
    // ●ファイル日時取得(FILEの) # FILEの最終更新時刻を調べて返す
    public static void file_date(AFunctionArg arg) {
        File file = new File(arg.getStr(0));
        long tm = file.lastModified();
        arg.setResult((int)tm);
    }
    // ●ファイルサイズ取得(FILEの) # FILEのサイズを調べて返す
    public static void file_size(AFunctionArg arg) {
        File file = new File(arg.getStr(0));
        arg.setResult((int)file.length());
    }
    // ●ファイル列挙(PATHの|PATHで) # PATHにあるファイル一覧を返す
    public static void file_list(AFunctionArg arg) {
        String path = arg.getStr(0);
        StringVector r = KUtils.enumFiles(path);
        //
        AValue a = new AValue();
        a.array_create();
        a.array_setStringVecotr(r);
        arg.result = a;
    }
    // ●フォルダ列挙(PATHの|PATHで) # PATHにあるファイル一覧を返す
    public static void dir_list(AFunctionArg arg) {
        String path = arg.getStr(0);
        StringVector r = KUtils.enumDirs(path);
        //
        AValue a = new AValue();
        a.array_create();
        a.array_setStringVecotr(r);
        arg.result = a;
    }
    // ●フォルダ作成(DIRの|DIRに|DIRで) # DIRにフォルダを作成する
    public static void mkdir(AFunctionArg arg) {
        String path = arg.getStr(0);
        File f = new File(path);
        f.mkdirs();
    }
    // ●ファイル名抽出(FILEから|FILEの) # FILEからファイル名のみを抽出する
    public static void file_getName(AFunctionArg arg) {
        File file = new File(arg.getStr(0));
        String s = file.getName();
        arg.setResult(s);
    }
    // ●ファイルパス抽出(FILEから|FILEの) # FILEからパスを抽出する
    public static void file_getPath(AFunctionArg arg) {
        File file = new File(arg.getStr(0));
        String s = file.getParent();
        arg.setResult(s);
    }
    // ●パス区切り記号取得 # FILEからパス区切り記号を抽出する
    public static void file_getSplitter(AFunctionArg arg) {
        arg.setResult(File.separator);
    }
    private static String getenv(String name) {
    	return System.getenv(name);
    }
    // ●CGIフォーム取得 # CGIよりフォームデータを取得してハッシュ形式で返す
    public static void cgi_getForm(AFunctionArg arg) {
        AValue res = new AValue();
        res.type = AValue.typeHash;
        res.value = new AValueHashtable();
        // get method
        String method = getenv("REQUEST_METHOD");
        if (method == null) { method = "POST"; }
        String body;
        method = method.toUpperCase();
        // get body
        if (method.compareTo("GET") == 0) {
            body = getenv("QUERY_STRING");
            if (body == null) body = "";
        } else {
            int len = 0;
            try {
                String slen = getenv("CONTENT_LENGTH");
                if (slen == null) { slen = "0"; }
                len = Integer.valueOf(slen).intValue();
                body = KUtils.stdin_readByte(len);
            } catch (RuntimeException e) {
                body = "";
            }
        }
        // analize
        CurString cbody = new CurString(body);
        while (cbody.hasNext()) {
            String pair = cbody.getToken("&");
            CurString cpair = new CurString(pair);
            String key = cpair.getToken("=");
            if (key.length() == 0) continue;
            String value = cpair.getStringAfterIndex();
            value = KEncoder.decodeURL(value, null);
            res.hash_set(key, new AValue(value));
        }
        arg.result = res;
    }
    // ●作業フォルダ取得 # カレントディレクトリを返す
    public static void pwd(AFunctionArg arg) {
        String dir = KUtils.getCurrentDir();
        arg.setResult(dir);
    }
    // ●作業フォルダ設定(DIRに) # カレントディレクトリをDIRに設定する
    public static void cd(AFunctionArg arg) {
        String dir = arg.getStr(0);
        shell_command("cd \"" + dir + "\"");
    }
    // ●URLエンコード(Sを) # URLエンコード
    public static void url_encode(AFunctionArg arg) {
        String s = arg.getStr(0);
        arg.setResult(KEncoder.encodeURL(s,null));
    }
    // ●URLデコード(Sを) # URLデコード
    public static void url_decode(AFunctionArg arg) {
        String s = arg.getStr(0);
        //arg.setResult(KEncoder.decodeURL(s,"UTF-8"));
        arg.setResult(KEncoder.decodeURL(s,null));
    }
    // ●MYSQL接続(DBへUSERがPASSで) # MYSQLに接続する。DBには「HOST/DB名」で指定する。
    static private Connection mysql_con = null;
    static private Statement mysql_stmt = null;
    static private ResultSet mysql_res = null;
    public static void mysql_connect(AFunctionArg arg) {
        // args
        String db = arg.getStr(0);
        String user = arg.getStr(1);
        String pass = arg.getStr(2);
        db = "jdbc:mysql://" + db + "?characterEncoding=UTF8";
        // check driver
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch (Exception e) {
            throw new AOIRuntimeError("No MySql jdbc DRIVER : " + e.getMessage());
        }
        try {
            // connect
            mysql_con = DriverManager.getConnection(db, user, pass);
        } catch (Exception e) {
            throw new AOIRuntimeError("MySql Error : " + e.getMessage());
        }
        
    }
    // ●MYSQL実行(SQLを) # SQLを実行する
    public static void mysql_exec(AFunctionArg arg) {
        String sql = arg.getStr(0);
        try {
            mysql_stmt = mysql_con.createStatement();
            mysql_res  = mysql_stmt.executeQuery(sql);
        } catch (Exception e) {
            throw new AOIRuntimeError("MySql Error : " + e.getMessage());
        }
    }
    // ●MYSQL全結果取得 # SQLの結果を全部配列形式で取得する
    public static void mysql_getAll(AFunctionArg arg) {
        AValue res = new AValue();
        res.array_create();
        if (mysql_res == null) return;
        try {
            ResultSetMetaData meta = mysql_res.getMetaData();
            while (mysql_res.next()) {
                AValue row = new AValue();
                row.array_create();
                res.array_add(row);
                int cnt = meta.getColumnCount();
                for (int i = 1; i <= cnt; i++) {
                    int type = meta.getColumnType(i);
                    AValue col;
                    switch (type) {
                        case Types.INTEGER:
                            col = new AValue(mysql_res.getInt(i));
                            break;
                        case Types.FLOAT:
                            col = new AValue(mysql_res.getDouble(i));
                            break;
                        case Types.DOUBLE:
                            col = new AValue(mysql_res.getDouble(i));
                            break;
                        default:
                            col = new AValue(mysql_res.getString(i));
                    }
                    row.array_add(col);
                }
            }
            arg.result = res;
        } catch (Exception e) {
            throw new AOIRuntimeError("MySql Error : " + e.getMessage());
        }
    }
    // ●MYSQL切断 # MySqlとの接続を閉じます
    public static void mysql_close(AFunctionArg arg) {
        try {
            if (mysql_res != null) mysql_res.close();
            if (mysql_stmt != null) mysql_stmt.close();
            if (mysql_con != null) mysql_con.close();
        } catch (Exception e) {
            // nothing
        }
    }
    // ●MYSQLテーブル一覧取得 # テーブル一覧を取得する
    public static void mysql_listTables(AFunctionArg arg) {
        if (mysql_con == null) return;
        try {
            DatabaseMetaData meta = mysql_con.getMetaData();
            ResultSet rs = meta.getCatalogs();
            AValue v = new AValue();
            v.array_create();
            while (rs.next()) {
                String s = rs.getString(1);
                v.array_add(new AValue(s));
            }
            arg.result = v;
        } catch (Exception e) {
            // nothing
        }
    }
    // ●母艦パス取得(DIRに) # スクリプトパスを取得する
    public static void dir_getBasePath(AFunctionArg arg) {
        String path = arg.mac.parent.base_path;
        path = KUtils.addLastPathFlag(path);
        arg.setResult(path);
    }
}
