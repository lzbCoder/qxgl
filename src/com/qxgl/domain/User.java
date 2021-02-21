package com.qxgl.domain;

import java.io.Serializable;

public class User implements Serializable {

    private Integer uid;  // int基本数据类型-Integer包装类
    private String uname;
    private String upass;
    private String truename;
    private String sex;
    private Integer age;

    private String yl1;
    private String yl2;

    public User() {}

    public User(Integer uid, String uname, String upass, String truename, String sex, Integer age, String yl1, String yl2) {
        this.uid = uid;
        this.uname = uname;
        this.upass = upass;
        this.truename = truename;
        this.sex = sex;
        this.age = age;
        this.yl1 = yl1;
        this.yl2 = yl2;
    }

    @Override
    public String toString() {
        return "User{" +
                "uid=" + uid +
                ", uname='" + uname + '\'' +
                ", upass='" + upass + '\'' +
                ", truename='" + truename + '\'' +
                ", sex='" + sex + '\'' +
                ", age=" + age +
                ", yl1='" + yl1 + '\'' +
                ", yl2='" + yl2 + '\'' +
                '}';
    }

    public Integer getUid() {
        return uid;
    }
    public void setUid(Integer uid) {
        this.uid = uid;
    }
    public String getUname() {
        return uname;
    }
    public void setUname(String uname) {
        this.uname = uname;
    }
    public String getUpass() {
        return upass;
    }
    public void setUpass(String upass) {
        this.upass = upass;
    }
    public String getTruename() {
        return truename;
    }
    public void setTruename(String truename) {
        this.truename = truename;
    }
    public String getSex() {
        return sex;
    }
    public void setSex(String sex) {
        this.sex = sex;
    }
    public Integer getAge() {
        return age;
    }
    public void setAge(Integer age) {
        this.age = age;
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
