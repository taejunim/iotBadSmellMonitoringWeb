package iotBadSmellMonitoring.history.service.impl;

import iotBadSmellMonitoring.history.service.RegisterService;
import iotBadSmellMonitoring.history.service.RegisterVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @ Class Name   : RegisterServiceImpl.java
 * @ Modification : REGISTER MASTER / DETAIL SERVICE IMPL
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.04.    고재훈
 * @
 * @   수정일         수정자
 * @ ---------    ---------
 * @
 **/

public class RegisterServiceImpl implements RegisterService {

    @Autowired
    SqlSession sqlSession;

    /**
     * 접수 마스터 등록
     * @param registerVO REGISTER MASTER / DETAIL VO.
     * @return           int
     * @throws Exception
     */
    public int registerMasterInsert(RegisterVO registerVO) throws Exception {

        RegisterMapper registerMapper = sqlSession.getMapper(RegisterMapper.class);

        return registerMapper.registerMasterInsert(registerVO);
    }

}
