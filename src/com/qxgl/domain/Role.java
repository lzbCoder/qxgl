package com.qxgl.domain;

import java.io.Serializable;

public class Role implements Serializable {

    private Integer rid;
    private String rname;
    private String yl1;
    private String yl2;

    public Role() {}

    public Role(Integer rid, String rname, String yl1, String yl2) {
        this.rid = rid;
        this.rname = rname;
        this.yl1 = yl1;
        this.yl2 = yl2;
    }

    @Override
    public String toString() {
        return "Role{" +
                "rid=" + rid +
                ", rname='" + rname + '\'' +
                ", yl1='" + yl1 + '\'' +
                ", yl2='" + yl2 + '\'' +
                '}';
    }

    public Integer getRid() {
        return rid;
    }

    public void setRid(Integer rid) {
        this.rid = rid;
    }

    public String getRname() {
        return rname;
    }

    public void setRname(String rname) {
        this.rname = rname;
    }

    public String getYl1() {
        return yl1;
    }

    public void setYl1(String yl1) {
        this.yl1 = yl1;
    }

    public String getYl2() {
        return yl2;
    }

    public void setYl2(String yl2) {
        this.yl2 = yl2;
    }
}
