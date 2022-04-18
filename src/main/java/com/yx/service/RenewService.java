package com.yx.service;

import com.github.pagehelper.PageInfo;
import com.yx.po.Renew;

public interface RenewService {
    boolean saveRenew(Renew renew);

    PageInfo<Renew> queryAllRenew(String bookName, String readerNumber, Integer page, Integer limit);

    boolean updateRenewStatusById(Renew renew);
}
