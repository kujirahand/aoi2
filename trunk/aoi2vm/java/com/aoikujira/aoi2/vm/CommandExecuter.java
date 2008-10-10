/*
 * CommandExecuter.java
 * [参照元] http://q.hatena.ne.jp/1107934603
 */

package com.aoikujira.aoi2.vm;

import java.io.*;
import java.io.BufferedReader;
import java.io.InputStreamReader;

/**
 * 外部コマンドを実行するクラス。
 * 外部コマンドを実行し、そのコマンドが標準出力に出力する文字列を取得することができる。
 * @since 2004/05/05
 * @author Net Aqua Project all rights reserved.
 */

public class CommandExecuter implements Runnable {
    private StringWriter strWriter;
    private PrintWriter pwriter;
    private BufferedReader buffReader;
    
    /**
     *
     * コンストラクタ
     *
     */
    
    public CommandExecuter() {
    }
    
    /**
     * 外部コマンドを実行する。
     * @param command 実行する外部コマンド
     * @return String 外部コマンドが標準出力に出力する実行結果
     * @throws IOException
     */
    
    public String doExec(String command) throws IOException {
        Runtime rt = Runtime.getRuntime();
        Process proc = rt.exec(command);
        buffReader = new BufferedReader(new InputStreamReader(proc.getInputStream()));
        strWriter = new StringWriter();
        pwriter = new PrintWriter(strWriter);
        //出力結果を読み終わるまで待つ。
        Thread th = new Thread(this);
        th.start();
        try {
            th.join();
        } catch (InterruptedException e) {
            throw new IOException("Command Exec Failed");
        }
        buffReader.close();
        pwriter.close();      
        //文字列の最後の改行を削除する。
        String temp = strWriter.toString();
        if ((temp.length() > 1) && (temp.substring(temp.length() - 1).getBytes()[0] == 10)) {
            temp = temp.substring(0,temp.length() - 1);
        }
        return temp;
        
    }
    
    /**
     *
     * コマンドの実行結果を読み出す。
     *
     * @see java.lang.Runnable#run()
     *
     */
    public void run() {
        String line = null;
        try {
            while((line = buffReader.readLine()) != null ) {
                pwriter.println(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
}