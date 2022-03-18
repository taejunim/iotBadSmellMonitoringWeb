package iotBadSmellMonitoring.member.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.join.service.JoinVO;

import java.util.List;
import java.util.Map;

/**
 * @ Class Name   : AttendMapper.java
 * @ Modification : USER ATTEND MAPPER.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2022.03.17.    허지명
 * @
 * @  수정일           수정자
 * @ ---------    ---------
 * @ 2022.03.18     고재훈
 **/

public interface AttendMapper {

    /**
     * 출석 회원 리스트 목록
     * @param joinVO
     * @return  list
     * @throws Exception
     */
    List<EgovMap> attendUserList(JoinVO joinVO) throws Exception;


    /**
     * 출석 여부 확인 리스트 목록
     * @param joinVO
     * @return  list
     * @throws Exception
     */
    List<EgovMap> attendUserCheckList(JoinVO joinVO) throws Exception;

  }
