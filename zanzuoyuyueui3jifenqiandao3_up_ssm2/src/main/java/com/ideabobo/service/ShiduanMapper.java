package com.ideabobo.service;

import com.ideabobo.model.Shiduan;

public interface ShiduanMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Shiduan record);

    int insertSelective(Shiduan record);

    Shiduan selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Shiduan record);

    int updateByPrimaryKey(Shiduan record);
}