package com.yx.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.yx.dao.RenewMapper;
import com.yx.po.Renew;
import com.yx.service.RenewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName RenewServiceImpl
 * @Description TODO
 * @Author liuqiang
 * @Date 2022-04-12-17:18
 */
@Service
public class RenewServiceImpl implements RenewService {
    @Autowired
    RenewMapper renewMapper;
    @Override
    public boolean saveRenew(Renew renew) {

        return renewMapper.insertRenew(renew);
    }

    @Override
    public PageInfo<Renew> queryAllRenew(String bookName, String readerNumber, Integer page, Integer limit) {
        PageHelper.startPage(page,limit);
        List<Renew> renews = renewMapper.selectAllRenew(bookName, readerNumber);
        PageInfo<Renew> pageInfo = new PageInfo<>(renews);
        return pageInfo;
    }

    @Override
    public boolean updateRenewStatusById(Renew renew) {
        return renewMapper.updateRenewStatusById(renew);
    }


}
