package iotBadSmellMonitoring.member.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.join.service.JoinVO;

import java.util.List;

/**
 * @ Class Name   : MemberMapper.java
 * @ Modification : 회원관리 MAPPER.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.04.    양유정
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/

public interface MemberMapper {

    /**
     * 회원 리스트 조회
     * @param   joinVO
     * @return  list
     * @throws Exception
     */
    List<EgovMap> memberListSelect(JoinVO joinVO) throws Exception;

    /**
     * 회원 리스트 TOTAL COUNT 조회
     * @param   joinVO
     * @return  int
     * @throws Exception
     */
    int memberListTotalCnt(JoinVO joinVO) throws Exception;

    /**
     * 회원 비밀번호 변경
     * @param   joinVO
     * @return
     * @throws Exception
     */
    int memberPasswordUpdate(JoinVO joinVO) throws Exception;

    /**
     * 회원 탈퇴
     * @param   joinVO
     * @return
     * @throws Exception
     */
    void memberDelete(JoinVO joinVO) throws Exception;

    /**
     * USER_ID / USER_NAME GET
     * @param  userId
     * @return
     * @throws Exception
     */
    EgovMap memberGetInfoSelect(String userId) throws Exception;

}
