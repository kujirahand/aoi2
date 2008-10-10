package com.aoikujira.aoi2.compiler;

public class ANode {
    
    public int              type;
    public Object           value;
    public Object           desc;
    public ANodeVector      list;
    public String           josi;
    private ANode           next;
    public int              tag;
    
    public ANode() {
        init();
    }
    public ANode(int type) {
        init();
        this.type = type;
    }
    public ANode(int type, Object value) {
        init();
        this.type  = type;
        this.value = value;
    }
    public ANode(int type, int value) {
        init();
        this.type  = type;
        this.value = new Integer(value);
    }
    public void init() {
        next = null;
        value = null;
        desc = null;
        list = null;
        tag = 0;
    }
    public void setNode(ANode n) {
        this.type  = n.type;
        this.value = n.value;
        this.desc  = n.desc;
        this.list  = n.list;
        this.tag   = n.tag;                
    }
    public ANode duplicate() {
        ANode src = this;
        ANode top = new ANode();
        top.setNode(src);
        ANode dup = top;
        while (src != null) {
            dup.setNode(src);
            if (src.next != null) {
                dup.next = new ANode();
            }
            src = src.next;
            dup = dup.next;
        }
        return top;
    }
    public boolean equalDescript(String key) {
        if (desc == null) return false;
        String s = desc.toString();
        return (s.compareTo(key) == 0);
    }
    
    public boolean isJumpNode() {
        return (type == ANodeTypes.JUMP) || (type == ANodeTypes.JUMP_NON_ZERO) || (type == ANodeTypes.JUMP_ZERO);
    }
    public boolean isNOPorEOL() {
        return (type == ANodeTypes.NOP) || (type == ANodeTypes.EOL);
    }
    
    public void addChild(ANode n) {
        if (list == null) {
            list = new ANodeVector();
        }
        list.add(n);
    }
    
    public void expandList() {
        if (list != null) {
            ANode anode = this;
            ANode tmp_next = anode.next;
            anode.next = null;
            for (int i = 0; i < list.size(); i++) {
                ANode n = (ANode)list.get(i);
                n.expandList();
                anode.append(n);
                anode = n;
            }
            if (tmp_next != null) tmp_next.expandList();
            anode.append(tmp_next);
            this.list = null;
        }
        else {
            if (next != null) next.expandList();
        }
    }
    
    public void append(ANode node) {
        ANode p = this;
        while (p.next != null) {
            p = p.next;
        }
        p.next = node;
    }
    
    public static ANode connect(ANode[] nodes) {
        if (nodes == null || nodes.length == 0) return null;
        ANode top = nodes[0];
        ANode last = top;
        for (int i = 1; i < nodes.length; i++) {
            ANode n = nodes[i];
            last.append(n);
            last = n;
        }
        return top;
    }
    
    public int countLength() {
        ANode n = this;
        int count = 0;
        while (n != null) {
            n = n.next;
            count++;
        }
        return count;
    }
    
    public ANode getNext() {
        return this.next;
    }
    
    public void setNext(ANode next) {
        this.next = next;
    }
    
    public String getListJosi(int i) {
        if (list == null)       return "";
        if (list.size() <= i)   return "";
        ANode n = (ANode)list.get(i);
        return n.josi;
    }
    
    public ANode pickupList(String josi) {
        if (josi == null) josi = "";
        // find children
        if (list != null) {
            ANode n = null;
            for (int i = 0; i < list.size(); i++) {
                //n = list.get(list.size() - i - 1);
                n = (ANode)list.get(i);
                if (n.josi == null) n.josi = "";
                if (josi.compareTo(n.josi) == 0) {
                    list.remove(n);
                    return n;
                }
            }
        }
        // check this
        if (this.josi == null) this.josi = "";
        if (this.josi.compareTo(josi) == 0) {
            return this;
        }
        return null;
    }
    
    public String getNodeJosi() {
        String josi = "";
        ANode n = this;
        for (n = this; n != null && n.next != null; n = n.next);
        if (n != null) {
            return n.josi;
        }
        return josi;
    }
    
}
