package com.yx.po;

/**
 * @ClassName Renew
 * @Description TODO
 * @Author liuqiang
 * @Date 2022-04-11-23:53
 */
public class Renew {
    private Integer id;
    private Integer renewDays;
    private char status;
    private String remarks;
    private LendList lendList;
    private BookInfo bookInfo;
    private ReaderInfo readerInfo;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public LendList getLendList() {
        return lendList;
    }

    public void setLendList(LendList lendList) {
        this.lendList = lendList;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public Integer getRenewDays() {
        return renewDays;
    }

    public void setRenewDays(Integer renewDays) {
        this.renewDays = renewDays;
    }

    public char getStatus() {
        return status;
    }

    public void setStatus(char status) {
        this.status = status;
    }

    public BookInfo getBookInfo() {
        return bookInfo;
    }

    public void setBookInfo(BookInfo bookInfo) {
        this.bookInfo = bookInfo;
    }

    public ReaderInfo getReaderInfo() {
        return readerInfo;
    }

    public void setReaderInfo(ReaderInfo readerInfo) {
        this.readerInfo = readerInfo;
    }
}
