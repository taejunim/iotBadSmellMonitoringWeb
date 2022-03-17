package iotBadSmellMonitoring.member.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.join.service.JoinVO;

import java.util.List;
import java.util.Map;

/**
 * @ Class Name   : AttendMapper.java
 * @ Modification : 출석일지 MAPPER.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2022.03.17.    허지명
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/

public interface AttendMapper {

    /**
     * 회원 리스트 조회
     * @param joinVO
     * @return  list
     * @throws Exception
     */
    List<EgovMap> memberListSelect(JoinVO joinVO) throws Exception;

    /**
     * 회원 전체 리스트 조회
     * @param joinVO
     * @return
     * @throws Exception
     */
    List<EgovMap> memberListSelectTotal(JoinVO joinVO) throws Exception;


    /**
     * 회원 리스트 TOTAL COUNT 조회
     * @param joinVO
     * @return  int
     * @throws Exception
     */
    int memberListTotalCnt(JoinVO joinVO) throws Exception;

    /**
     * 날짜 데이터 , 접수 데이터 매칭
     * @param parameter
     * @return
     * @throws Exception
     */
    List<EgovMap> attendListSelect(Map<String, String> parameter) throws Exception;



    }
