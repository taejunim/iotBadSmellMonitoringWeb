package iotBadSmellMonitoring.join.service;

/**
 * @ Class Name   : JoinService.java
 * @ Modification : 회원가입 / 아이디 찾기 관련 SERVICE
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.03.    고재훈
 * @
 * @    수정일        수정자
 * @ ---------    ---------
 * @
 **/

public interface JoinService {

    /**
     * 회원가입
     * @param joinVO     회원가입 / 아이디 찾기 관련 VO.
     * @return           int
     * @throws Exception
     */
    int userJoinInsert(JoinVO joinVO) throws Exception;
}
