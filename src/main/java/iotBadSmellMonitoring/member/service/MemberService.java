package iotBadSmellMonitoring.member.service;


import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.common.message.MessageVO;
import iotBadSmellMonitoring.join.service.JoinVO;

import java.util.List;
import java.util.Map;

/**
 * @ Class Name   : MemberService.java
 * @ Modification : 회원관리 SERVICE
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.04.    양유정
 * @
 * @    수정일        수정자
 * @ ---------    ---------
 * @
 **/

public interface MemberService {

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

    /**
     * TODAY HISTORY 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    List<Map<String, Object>> todayRegisterListSelect(Map<String, Object> dataList) throws Exception;

    /**
     * USER PHONE CHECK
     * @param userPhone     휴대폰 번호
     * @return              EgovMap
     * @throws Exception
     */
    EgovMap userPhoneCheck(String userPhone) throws Exception;

    /**
     * 메세지 전송될 사용자명, 번호 목록
     * @return List<MessageVO>
     * @throws Exception
     */
    List<MessageVO> userPhoneNumberListSelect() throws Exception;

}
