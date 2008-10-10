/*
 * KUtils.java
 *
 * Created on 2007/02/13, 14:06
 */

package com.aoikujira.utils;

/**
 * light function library.
 * @author desk
 */
import java.io.*;
import java.lang.RuntimeException;
import java.net.*;
import java.util.Calendar;

public class KUtils {

    public static String loadFromFile(String filename) {
        String result = "";
        try {
            FileInputStream fis = new FileInputStream(filename);
            InputStreamReader isr = new InputStreamReader(fis, "UTF8");
            BufferedReader br = new BufferedReader(isr);
            String line;
            while ((line = br.readLine()) != null) {
                result += line + "\n";
            }
            br.close();
            isr.close();
            fis.close();
        } catch (IOException e) {
            throw new RuntimeException(e.toString());
        }
        return result;
    }
    
    public static void saveToFile(String filename, String str) {
        try {
            FileOutputStream fos = new FileOutputStream(filename);
            OutputStreamWriter osw = new OutputStreamWriter(fos, "UTF8");
            BufferedWriter bw = new BufferedWriter(osw);
            bw.write(str);
            bw.close();
            osw.close();
            fos.close();
        } catch (IOException e) {
            throw new RuntimeException(e.toString());
        }
        return;
    }
    
    public static String extractFileName(String fname) {
        // get last path flag 
        int lastpath = 0;
        for (int i = 0; i < fname.length(); i++) {
            char c = fname.charAt(i);
            if (c == '\\' || c == '/') lastpath = i + 1;
        }
        return fname.substring(lastpath, fname.length());
    }
    
    public static String extractFilePath(String fname) {
        // get last path flag 
        int lastpath = 0;
        for (int i = 0; i < fname.length(); i++) {
            char c = fname.charAt(i);
            if (c == '\\' || c == '/') lastpath = (i + 1);
        }
        return fname.substring(0, lastpath);
    }
    
    public static String extractFileExt(String fname) {
        // get last path flag 
        int lastpath = 0;
        for (int i = 0; i < fname.length(); i++) {
            char c = fname.charAt(i);
            if (c == '.') lastpath = i;
        }
        return fname.substring(lastpath, fname.length());
    }
    
    public static String changeFileExt(String fname, String ext) {
        String oldext = extractFileExt(fname);
        return fname.substring(0, fname.length()-oldext.length()) + ext;
    }
    
    public static boolean fileExists(String fname) {
        File file = new File(fname);
        return file.exists();
    }
    
    public static long fileAge(String fname) {
        File file = new File(fname);
        return file.lastModified();
    }
    
    public static String getCurrentDir() {
        return new File( "." ).getAbsoluteFile().getParentFile().toString();
    }
    
    public static String addLastPathFlag(String dir) {
        if (dir == null) return "";
        char ch = dir.charAt(dir.length() - 1);
        if (ch == File.separatorChar || ch == '/' || ch == '\\') {
            return dir;
        }
        dir += File.separatorChar;
        return dir;
    }
    
    public static String stdin_readByte(int len) {
        BufferedReader br = new BufferedReader(
                new InputStreamReader(System.in));
        char buf[] = new char[len];
        try {   
            br.read(buf);
        } catch (IOException e) {
        }
        String s = String.valueOf(buf);
        return s;
    }
        
    public static String replaceAll(String src, String find, String replace) {
        int index = 0;
        for (;;) {
            String sub = src.substring(index);
            int i = sub.indexOf(find);
            if (i >= 0) {
                String s = sub.substring(0, i);
                s += replace;
                s += sub.substring((i+find.length()));
                src = src.substring(0, index) + s;
                index += i + replace.length();
                continue;
            }
            break;
        }
        return src;
    }
    public static String replaceOne(String src, String find, String replace) {
        int i = src.indexOf(find);
        if (i >= 0) {
            String s = src.substring(0, i);
            s += replace;
            s += src.substring((i+find.length()));
            src = s;
        }
        return src;
    }
    public static String trimS(String s) {
        int index = 0;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == ' ' || c == '\t' || c == '\r' || c == '\n') {
                index = i + 1;
            } else {
                break;
            }
        }
        s = s.substring(index, s.length());
        return s;
    }
    public static String trimE(String s) {
        int index = s.length();
        for (int i = 0; i < s.length(); i++) {
            int j = s.length() - i - 1;
            char c = s.charAt(j);
            if (c == ' ' || c == '\t' || c == '\r' || c == '\n') {
                index = j;
            } else {
                break;
            }
        }
        s = s.substring(0, index);
        return s;
    }
    public static String trim(String s) {
        s = trimE(s);
        s = trimS(s);
        return s;
    }
    public static void print(String msg) {
        System.out.println(msg);
    }
    public static String left(String n, int len) {
        return n.substring(0, len);
    }
    public static String right(String n, int len) {
        return n.substring((n.length() - len), n.length());
    }
    // 超手抜きワイルドカード(ただし高速)
    // 前後のマッチを調べる(つまり、ワイルドカードは１つのみ許される)
    public static boolean wildcard_match_light(String str, String pattern) {
        // "?"
        int i = pattern.indexOf('?');
        if (i >= 0) {
            String mae   = pattern.substring(0, i);
            String usiro = pattern.substring((i+1), pattern.length());
            if (left(str, mae.length()).equalsIgnoreCase(mae) && 
                    right(str, usiro.length()).equalsIgnoreCase(usiro) &&
                    (mae.length() + usiro.length() == str.length()-1)) {
                return true;
            }
            return false;
        }
        // "*""
        i = pattern.indexOf('*');
        if (i >= 0) {
            String mae   = pattern.substring(0, i);
            String usiro = pattern.substring((i+1), pattern.length());
            if (left(str, mae.length()).equalsIgnoreCase(mae) &&
                    right(str, usiro.length()).equalsIgnoreCase(usiro)) {
                return true;
            }
            return false;
        }
        // othar
        return pattern.equalsIgnoreCase(str);
    }
    public static StringVector enumFiles(String path) {
        String base = KUtils.extractFilePath(path);
        String name = KUtils.extractFileName(path);
        StringVector result = new StringVector();
        if (base.length() == 0) base = ".";
        if (name.length() == 0) name = "*";
        File dir = new File(base);
        File files[] = dir.listFiles();
        if (files == null) return result;
        for (int i = 0; i < files.length; i++) {
            File f = files[i];
            if (f.isFile()) {
                if (wildcard_match_light(f.getName(), name)) {
                    result.add(f.getName());
                }
            }
        }
        return result;
    }
    public static StringVector enumDirs(String path) {
        String base = KUtils.extractFilePath(path);
        String name = KUtils.extractFileName(path);
        if (name.length() == 0) name = "*";
        File dir = new File(base);
        File files[] = dir.listFiles();
        StringVector result = new StringVector();
        for (int i = 0; i < files.length; i++) {
            File f = files[i];
            if (f.isDirectory()) {
                if (wildcard_match_light(f.getName(), name)) {
                    result.add(f.getName());
                }
            }
        }
        return result;
    }
    public static StringVector str_split(String str, String splitter) {
        StringVector res = new StringVector();
        for (;;) {
            int i = str.indexOf(splitter);
            if (i < 0) {
                res.addStr(str);
                break;
            }
            String token = str.substring(0, i);
            res.addStr(token);
            str = str.substring(i + splitter.length());
        }
        return res;
    }
    public static String getUrl(URL url) {
        String result = "";
        try{
            InputStream is = url.openStream();
            InputStreamReader isr = new InputStreamReader(is, "UTF8");
            BufferedReader bur = new BufferedReader(isr);

            String line;
            while ((line = bur.readLine()) != null) {
                result += line + "\n";
            }

            bur.close();
            isr.close();
            is.close();
        }
        catch(IOException e){
            throw new RuntimeException(e.toString());
        }
        return result;
    }
    public static String str_fillZero(String v, int keta) {
        int zero_count = keta - v.length();
        String s = v;
        for (int i = 0; i < zero_count; i++) s = "0" + s;
        return s;
    }
    public static Calendar str_toDate(String s) {
        // check splitter
        char splitter = '-';
        if (s.indexOf("/") >= 0) {
            splitter = '/';
        }
        else if (s.indexOf(".") >= 0) {
            splitter = '.';
        }
        // separate .. set default value
        Calendar res = Calendar.getInstance();
        int yy = res.get(Calendar.YEAR);
        int mm = res.get(Calendar.MONTH) + 1;
        int dd = res.get(Calendar.DATE);
        StringVector ss = KUtils.str_split(s, ""+splitter);
        if (ss.size() >= 1) yy = Integer.parseInt(ss.getStr(0));
        if (ss.size() >= 2) mm = Integer.parseInt(ss.getStr(1));
        if (ss.size() >= 3) dd = Integer.parseInt(ss.getStr(2));
        res.set(yy, mm - 1, dd);
        return res;
    }
    public static Calendar str_toTime(String s) {
        // separate .. set default value
        Calendar res = Calendar.getInstance();
        int hh = res.get(Calendar.HOUR);
        int nn = res.get(Calendar.MINUTE);
        int ss = res.get(Calendar.SECOND);
        StringVector s_ary = KUtils.str_split(s, ":");
        if (s_ary.size() >= 1) hh = Integer.parseInt(s_ary.getStr(0));
        if (s_ary.size() >= 2) nn = Integer.parseInt(s_ary.getStr(1));
        if (s_ary.size() >= 3) ss = Integer.parseInt(s_ary.getStr(2));
        res.set(Calendar.HOUR,  hh);
        res.set(Calendar.MINUTE,nn);
        res.set(Calendar.SECOND,ss);
        return res;
    }
    /**
     * return "yyyy-mm-dd"
     */
    public static String date_toString(Calendar date) {
        int yy = date.get(Calendar.YEAR);
        int mm = date.get(Calendar.MONTH) + 1;
        int dd = date.get(Calendar.DATE);
        String smm = KUtils.str_fillZero(String.valueOf(mm), 2);
        String sdd = KUtils.str_fillZero(String.valueOf(dd), 2);
        String s = yy + "-" + smm + "-" + sdd;
        return s;
    }
    public static String time_toString(Calendar date) {
        String s = "";
        int hh = date.get(Calendar.HOUR);   // 12 時間
        int mn = date.get(Calendar.MINUTE);
        int sc = date.get(Calendar.SECOND);
        String shh = KUtils.str_fillZero(String.valueOf(hh), 2);
        String smn = KUtils.str_fillZero(String.valueOf(mn), 2);
        String ssc = KUtils.str_fillZero(String.valueOf(sc), 2);
        s = shh + ":" + smn + ":" + ssc;
        return s;
    }
}
