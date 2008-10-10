/*
 * ErrMsg.java
 * Created on 2007/01/30, 17:03
 */

package com.aoikujira.aoi2.compiler;
/**
 * @author desk
 */
public class ErrMsg {
    public static String AOICError          = "エラー。";
    public static String NoSystemModule     = "システムモジュールが指定されていません。対象となるシステムの基本ファイルを取り込んでください。";
    public static String NoParser           = "拡張子に対応した言語が定義されていません。";
    public static String SyntaxError        = "文法に間違いがあります。";
    public static String TokenizerError     = "単語の切り出しに失敗しました。";
    public static String SystemError        = "システムエラーです。";
    public static String IsProperty         = "プロパティは変数として利用できません。";
    public static String FileLoadError      = "ファイルを開けませんでした。";
    public static String FileIncludeError   = "ファイルの取り込みに失敗しました。";
    public static String StringNotTerminated= "文字列の終端記号がありません。";
    public static String UnrecognizedChar   = "認識できない文字があります。";
    public static String InvalidIndentNum   = "インデントの個数が間違っています。";
    public static String ArgCountError      = "関数の呼び出しで引数の個数が間違っています。";
    public static String NoArgError         = "関数の呼び出しで対応する助詞がありません。";
    public static String InvalidForVar      = "「繰り返す」構文で対象変数が間違っています。";
    public static String InvalidForArg      = "「繰り返す」構文で引数が間違っています。「(変数)で(値)から(値)まで」の書式で記述します。";
    public static String DefFuncInvalidName = "関数定義で名前がありません。";
    public static String DefFuncInvalidArg  = "関数定義で引数の記述に間違いがあります。";
    public static String DefFuncLib         = "モジュール関数の定義に間違いがあります。";
    public static String AlreadyExistsVar   = "既に宣言されている変数です。";
    public static String DefConst           = "定数の定義方法に間違いがあります。";
    public static String ExecCommand        = "コマンドが実行できませんでした。";
    public static String Nearby             = "次の単語付近に誤りがあります。";
    public static String DefAccessor        = "アクセサの定義に誤りがあります。";
    public static String NotDefineFunction  = "関数が定義されていません。";
    public static String NoSetter           = "読み込み専用アクセサです。";
    public static String NoGetter           = "書き込み専用アクセサです。";
    public static String UnknownWord        = "未知の単語があります。";
}
