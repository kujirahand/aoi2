package com.aoikujira.aoi2.compiler;

import com.aoikujira.aoi2.compiler.lang.aoi.AOIScanner;
import com.aoikujira.aoi2.compiler.lang.basic.BasicScanner;
import com.aoikujira.utils.KUtils;
import com.aoikujira.utils.StringVector;

public class Main {
    
    public GlobalObject global;
    public ANode node;
    public static boolean isDebugMode = false;
    public static boolean isJavaMode = false;
    public static boolean is_err2txt = false;
    public static StringVector main_args;
    public String mainfile;
    public static String USAGE = "USAGE:\n" + 
            "java -jar aoi2.jar [source file]\n" +
            "--lib [library path]\n" +
            "--java       : Compile & Run with Java\n" +
            "--debug      : use Debug Mode\n" +
            "--err2txt    : write error.txt\n";
    public static String ext_ir = ".aoir";
    public String outErrorMessage;
    
    public boolean analizeArgs(String[] args) {
        main_args = new StringVector();
        if (args.length == 0) {
            System.out.println(USAGE);
            return false;
        }
        int i = 0;
        while (i < args.length) {
            String a = args[i];
            if (a.compareTo("--replace") == 0) {
                String infile  = args[i]; i++;
                String outfile = args[i]; i++;
                String str     = args[i]; i++;
                String s = KUtils.loadFromFile(infile);
                s = KUtils.replaceAll(s, "__FILE__", str);
                KUtils.saveToFile(outfile, s);
                return false;
            }
            if (a.compareTo("--lib") == 0 || a.compareTo("--library") == 0) {
                i++;
                global.files.path_lib = args[i]; i++;
                continue;
            }
            if (a.compareTo("--java") == 0) {
                i++;
                isJavaMode = true;
                continue;
            }
            if (a.compareTo("--debug") == 0) {
                i++;
                isDebugMode = true;
                continue;
            }
            if (a.compareTo("--err2txt") == 0) {
                i++;
                is_err2txt = true;
                continue;
            }
            String chk = a.substring(0, 1);
            if (chk.compareTo("-") == 0) {
                throw new AOICException("[ERROR] : Invalid Option [" + a + "]");
            }
            main_args.addStr(a);
            if (this.mainfile == null) this.mainfile = a;
            i++;
        }
        return true;
    }
    
    public static boolean needCompile(String aoifile) {
        String vmfile = getIRNameFromSourceName(aoifile);
        if (KUtils.fileExists(vmfile)) {
            long tm_aoi = KUtils.fileAge(aoifile);
            long tm_vm  = KUtils.fileAge(vmfile);
            return (tm_aoi > tm_vm);
        }
        return true;
    }
    
    public static String getIRNameFromSourceName(String sourcename) {
        return KUtils.changeFileExt(sourcename, ext_ir);
    }
    
    public boolean compileFile(String fname) {
        if (isDebugMode || needCompile(fname)) {
            try {
                loadMainFile(fname);
                return true;
            } catch (Exception e) {
                outErrorMessage = e.getMessage();
                return false;
            }
        } else {
            return true;
        }
    }
    
    /**
     * コマンドラインパラメータをつけてコンパイルを行う
     */
    public static Main compileParams(String[] args) {
        Main main = new Main();
        if (!main.analizeArgs(args)) {
            return null;
        }
        if (main.mainfile == null) {
            KUtils.print(USAGE);
            return null;
        }
        // -- compile
        if (isDebugMode || needCompile(main.mainfile)) {
            try {
                main.loadMainFile(main.mainfile);
                if (is_err2txt) {
                    KUtils.saveToFile("error.txt", "ok");
                }
            } catch (AOICException e){
                if (is_err2txt) {
                    KUtils.saveToFile("error.txt", e.getMessage(main.global));
                } else {
                    System.out.print("<pre>\n" + e.getMessage(main.global)+"\n");
                }
            } catch (Exception e) {
                if (is_err2txt) {
                    KUtils.saveToFile("error.txt", e.getMessage());
                } else {
                    System.out.print("<pre>\n" + e.getMessage()+"\n");
                }
                return null;
            }
        } else {
            if (is_err2txt) {
                KUtils.saveToFile("error.txt", "ok");
            }
        }
        return main;
    }
    /**
     * コマンドラインをつけてコンパイルのみ
     */
    public static void main(String[] args) {
        compileParams(args);
        /*
        // test
        String src = KUtils.loadFromFile(args[0]);
        KUtils.print( compileAOI_static(src, ".bas") );
        */
    }
    
    public static String compileAOI_static(String source, String ext) {
        Main c = new Main();
        try {
            String res;
            res = c.compileAOI(source, ext, true);
            return res;
        } catch (AOICException e) {
            return e.getMessage(c.global);
        } catch (Exception e) {
            return "[ERROR]:\n" + e.getMessage();
        }
    }
    
    public Main() {
        init();
    }    
    
    private void init() {
        global = new GlobalObject();
    }
    
    public String compileAOI(String source, String ext, boolean debug_mode) {
        Scanner scanner = getScannerFromExt(ext);
        // LoadFile
        try {
            Main.isDebugMode = debug_mode;
            scanner.setSource(source);
        } catch (AOICException e) {
            if (isDebugMode) { e.printStackTrace(); }
            throw new AOICException(ErrMsg.TokenizerError + e.getMessage(global), e.fileid, e.lineno);
        } catch (Exception e) {
            if (isDebugMode) { e.printStackTrace(); }
            throw new AOICException(e.getMessage() + ErrMsg.TokenizerError + ":" + "Main");
        }
        // parse
        try {
            Parser parser = scanner.parser;
            parser.parse(scanner);
            parser.expandNode();
            ANodePrinter pri = new ANodePrinter(parser.topnode, global);
            String json = pri.writeCode();
            return json;
        } catch (AOICException e) {
            e.printStackTrace();
            String s = ErrMsg.SyntaxError + e.getMessage(global);
            throw new AOICException(s, e.fileid, e.lineno);
        }
    }
    
    public Scanner getScannerFromExt(String ext) {
        Scanner scanner = null;
        ext = ext.toUpperCase();
        if (ext.compareTo(".AOI") == 0 ||ext.compareTo(".AOI2") == 0) {
            scanner = new AOIScanner(global);
        } else if (ext.compareTo(".BAS") == 0) {
            scanner = new BasicScanner(global);            
        } else {
            throw new AOICException(ErrMsg.NoParser);
        }
        return scanner;
    }
    
    public void loadMainFile(String filename) {
        if (KUtils.fileExists(filename) == false) {
            throw new AOICException(ErrMsg.FileLoadError + ":" + KUtils.extractFileName(filename));
        }
        String outfilename = KUtils.changeFileExt(filename, ext_ir);
        String ext = KUtils.extractFileExt(filename);
        // Scanner .. 拡張子に応じたスキャナを作る
        Scanner scanner = getScannerFromExt(ext);
        // LoadFile
        try {
            scanner.loadFile(filename);
        } catch (AOICException e) {
            if (isDebugMode) { e.printStackTrace(); }
            throw new AOICException(ErrMsg.TokenizerError + e.getMessage(), e.fileid, e.lineno);
        } catch (Exception e) {
            if (isDebugMode) { e.printStackTrace(); }
            throw new AOICException(e.getMessage() + ErrMsg.TokenizerError + ":" + filename);
        }
        // parse
        boolean b;
        try {
            b = parse(scanner);
        } catch (AOICException e) {
            String s = ErrMsg.SyntaxError + e.getMessage(global);
            throw new AOICException(s, e.fileid, e.lineno);
        }
        if (b) {
            saveToFile(outfilename);
        }
    }

    private boolean parse(Scanner scanner) {
        boolean result = false;
        Parser parser = scanner.parser;
        
        // --- parse ---
        //parser.yyparse(scanner, new jay.yydebug.yyAnim("jay.yydebug.yyAnim",2));
        //parser.yyparse(scanner, new jay.yydebug.yyDebugAdapter());
        try {
            
            parser.parse(scanner);
            parser.expandNode();
            this.node = parser.topnode;
            traceNode(node, global);
            result = true;
            
        } catch (Exception e) {
            String s_cur = scanner.reportCur();
            String s_con = e.toString();
            e.printStackTrace();
            throw new AOICException(s_cur + ":" + s_con, scanner.cur);
        }
            
        return result;
    }
    
    public static void traceNode(ANode node, GlobalObject global) {
        if (isDebugMode) {
            System.out.println("\n--- node ---");
            ANodePrinter pri = new ANodePrinter(node, global);
            System.out.print( pri.printToString(0) + "---\n");
        }
    }
    
    
    private void saveToFile(String outfilename) {
        ANodePrinter pri = new ANodePrinter(node, global);
        String json = pri.writeCode();
        KUtils.saveToFile(outfilename, json);
        // debug
        if (isDebugMode) {
            System.out.print( json );
            //KUtils.saveToFile("aoivm/flash7/test.aoivm", json);
            //KUtils.saveToFile("aoivm/java/test.aoivm", json);
        }
    }

}
