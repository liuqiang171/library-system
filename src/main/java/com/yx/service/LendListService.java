package com.yx.service;

import com.github.pagehelper.PageInfo;
import com.yx.po.LendList;

import java.util.List;

public interface LendListService {

    //分页查询
    PageInfo<LendList> queryLendListAll(LendList lendList, int page, int limit);

    //添加借阅记录
    void addLendListSubmit(LendList lendList);


    /**
     * 删除
     */
    void deleteLendListById(List<String> ids, List<String> bookIds);

    /**
     * 还书
     */
    void updateLendListSubmit(List<String> ids, List<String> bookIds);

    /**
     * 异常还书
     */
    void backBook(LendList lendList);

    /**
     * 时间线查询
     */
    List<LendList> queryLookBookList(Integer rid, Integer bid);

    /**
     * @Description: 读者查询自己借阅的图书
     * @Author: liuqiang
     * @param rid: 读者id
     * @return: java.util.List<com.yx.po.LendList>
     * @Date: 2022/4/11 9:44
     **/

    PageInfo<LendList> queryLendListByReaderId(Integer rid, Integer page, Integer limit, String bookName, String status);

    LendList queryLendListById(Integer id);

    boolean updateById(LendList lendList);

    boolean updateDueDate(LendList lendList);
}
