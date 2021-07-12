package iotBadSmellMonitoring.history.service.impl;

import iotBadSmellMonitoring.history.service.RegisterService;
import iotBadSmellMonitoring.history.service.RegisterVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @ Class Name   : RegisterServiceImpl.java
 * @ Modification : REGISTER MASTER / DETAIL SERVICE IMPL
 * @
 * @ 최초 생성일     최초 생성자
 * @ ————    ————
 * @ 2021.06.04.    고재훈
 * @
 * @   수정일         수정자
 * @ ————    ————
 * @
 **/

@Service
public class RegisterServiceImpl implements RegisterService {

    @Autowired
    SqlSession sqlSession;

    /**
     * 접수 마스터||디테일 등록
     * @param registerVO REGISTER MASTER / DETAIL VO.
     * @return           int
     * @throws Exception
     */
    public int registerInsert(RegisterVO registerVO) throws Exception {

        RegisterMapper registerMapper = sqlSession.getMapper(RegisterMapper.class);

        registerVO.setSmellRegisterNo(registerMapper.registerSmellRegisterNoSelect());                                  //접수 마스터 번호 CALL.

        int masterResult = registerMapper.registerMasterInsert(registerVO);                                             //접수 마스터 등록 CALL.
        int allResult    = 0;                                                                                           //마스터||디테일 등록 결과

        if(masterResult == 1){

            allResult = 1;

            if(registerVO.getSmellImagePath() != null) {                                                                //접수 디테일이 있으면,

                if(!registerVO.getSmellImagePath().equals("")){

                    int detailResult = registerMapper.registerDetailInsert(registerVO);                                 //접수 디테일 등록 CALL.

                    if(detailResult == 0)                                                                               //접수 마스터&&디테일 결과 1이면,
                        allResult = 0;
                }
            }

        }

        return allResult;
    }

}
