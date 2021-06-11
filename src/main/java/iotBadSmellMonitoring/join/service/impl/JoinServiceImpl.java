package iotBadSmellMonitoring.join.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.join.service.JoinService;
import iotBadSmellMonitoring.join.service.JoinVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @ Class Name   : JoinServiceImpl.java
 * @ Modification : 회원가입 / 로그인 / 아이디 찾기 관련 SERVICE IMPL
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.03.    고재훈
 * @
 * @   수정일         수정자
 * @ ---------    ---------
 * @
 **/

@Service
public class JoinServiceImpl implements JoinService {

    @Autowired
    SqlSession sqlSession;

    /**
     * 회원가입
     * @param joinVO     회원가입 / 로그인 / 아이디 찾기 관련 VO.
     * @return           int
     * @throws Exception
     */
    @Override
    public int userJoinInsert(JoinVO joinVO) throws Exception {

        JoinMapper joinMapper = sqlSession.getMapper(JoinMapper.class);

        return joinMapper.userJoinInsert(joinVO);
    }

    /**
     * 로그인
     * @param joinVO     회원가입 / 로그인 / 아이디 찾기 관련 VO.
     * @return           EgovMap
     * @throws Exception
     */
    @Override
    public EgovMap userLoginSelect(JoinVO joinVO) throws Exception {

        JoinMapper joinMapper = sqlSession.getMapper(JoinMapper.class);

        return joinMapper.userLoginSelect(joinVO);
    }

    /**
     * USER ID CHECK
     * @param       userId      CHECK USER ID.
     * @return      string
     * @throws      Exception
     */
    @Override
    public String userFindIdSelect(String userId) throws Exception {

        JoinMapper joinMapper = sqlSession.getMapper(JoinMapper.class);

        return joinMapper.userFindIdSelect(userId);
    }

}
