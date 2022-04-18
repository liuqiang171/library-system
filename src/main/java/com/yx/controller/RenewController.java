package com.yx.controller;

import com.github.pagehelper.PageInfo;
import com.yx.po.LendList;
import com.yx.po.Renew;
import com.yx.service.LendListService;
import com.yx.service.RenewService;
import com.yx.utils.DataInfo;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.xml.crypto.Data;
import java.util.Date;

/**
 * @ClassName RenewController
 * @Description TODO
 * @Author liuqiang
 * @Date 2022-04-14-11:02
 */
@Controller
public class RenewController {
    @Autowired
    RenewService renewService;

    @Autowired
    LendListService lendListService;

    @GetMapping("/renewalApplication")
    public String renewalApplication(){
        return "renew/renewalApplication";
    }

    @PostMapping("/queryAllRenew")
    @ResponseBody
    public DataInfo queryAllRenew(@RequestParam(value = "bookName",required = false) String bookName,
                                  @RequestParam(value = "readerNumber",required = false) String readerNumber,
                                  @RequestParam(value = "page",defaultValue = "1") Integer page,
                                  @RequestParam(value = "limit",defaultValue = "15") Integer limit){
        PageInfo<Renew> pageInfo = renewService.queryAllRenew(bookName, readerNumber, page, limit);

        return DataInfo.ok("ok",pageInfo.getTotal(),pageInfo.getList());
    }

    @GetMapping("/approval")
    @ResponseBody
    public DataInfo approval(@Param("id") Integer id,
                             @Param("renewDays") Integer renewDays,
                             @Param("lid") Integer lid){
        Renew renew = new Renew();
        renew.setRenewDays(renewDays);
        renew.setId(id);
        renew.setStatus('1');
        //lendListService.updateById();
        if(renewService.updateRenewStatusById(renew) == true){
            LendList lendList = lendListService.queryLendListById(lid);
            long dueDateTime = lendList.getDueDate().getTime() + renew.getRenewDays()*24*60*60*1000;
            Date date = new Date(dueDateTime);
            lendList.setDueDate(date);
            lendList.setBackType(6);
            lendListService.updateDueDate(lendList);
            return DataInfo.ok();
        }
        else {
            return DataInfo.fail("批准失败，请稍后再试！");
        }

    }

    @GetMapping("/refuse")
    @ResponseBody
    public DataInfo refuse(@Param("id") Integer id, @Param("lid") Integer lid){
        Renew renew = new Renew();
        renew.setId(id);
        renew.setStatus('2');
        if(renewService.updateRenewStatusById(renew) == true){
            LendList lendList = lendListService.queryLendListById(lid);
            lendList.setBackType(7);
            lendListService.updateDueDate(lendList);
            return DataInfo.ok();
        }
        else {
            return DataInfo.fail("拒绝续借申请失败，请稍后再试！");
        }
    }
}
