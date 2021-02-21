package com.qxgl.domain;

import java.io.Serializable;
import java.util.List;

/**
 * 装载分页查询的数据
 */
public class Page implements Serializable {
    private List<?> list;  //?表示泛型不确定，泛型中的<T>表示类中的一个具体类型不确定
    private Integer max;
    private Integer page;

    public Page() {}

    public Page(List<?> list, Integer max, Integer page) {
        this.list = list;
        this.max = max;
        this.page = page;
    }

    @Override
    public String toString() {
        return "Page{" +
                "list=" + list +
                ", max=" + max +
                ", page=" + page +
                '}';
    }

    public List<?> getList() {
        return list;
    }

    public void setList(List<?> list) {
        this.list = list;
    }

    public Integer getMax() {
        return max;
    }

    public void setMax(Integer max) {
        this.max = max;
    }

    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }
}
