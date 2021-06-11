package iotBadSmellMonitoring.join.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.join.service.JoinVO;


/**
 * @ Class Name   : JoinMapper.java
 * @ Modification : 회원가입 / 로그인 / 아이디 찾기 관련 MAPPER.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.03.    고재훈
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/

public interface JoinMapper {

    /**
     * 회원가입
     * @param joinVO     회원가입 / 로그인 / 아이디 찾기 관련 VO.
     * @return           int
     * @throws Exception
     */
    int userJoinInsert(JoinVO joinVO) throws Exception;

    /**
     * 로그인
     * @param joinVO     회원가입 / 로그인 / 아이디 찾기 관련 VO.
     * @return           EgovMap
     * @throws Exception
     */
    EgovMap userLoginSelect(JoinVO joinVO) throws Exception;

    /**
     * USER ID CHECK
     * @param       userId      CHECK USER ID.
     * @return      string
     * @throws      Exception
     */
    String userFindIdSelect(String userId) throws Exception;

}
