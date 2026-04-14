package com.ideabobo.model;

import java.io.Serializable;

public class Site implements Serializable {
    private Integer id;

    private String pid;

    private String note;

    private String ndate;

    private String title;

    private String statecn;

    private static final long serialVersionUID = 1L;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid == null ? null : pid.trim();
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note == null ? null : note.trim();
    }

    public String getNdate() {
        return ndate;
    }

    public void setNdate(String ndate) {
        this.ndate = ndate == null ? null : ndate.trim();
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title == null ? null : title.trim();
    }

    public String getStatecn() {
        return statecn;
    }

    public void setStatecn(String statecn) {
        this.statecn = statecn == null ? null : statecn.trim();
    }
}