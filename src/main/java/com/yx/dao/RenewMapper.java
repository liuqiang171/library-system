package com.yx.dao;

import com.yx.po.Renew;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface RenewMapper {
    boolean insertRenew(Renew renew);
    List<Renew> selectAllRenew(@Param("bookName") String bookName, @Param("readerNumber") String readerNumber);
    boolean updateRenewStatusById(Renew renew);

}
