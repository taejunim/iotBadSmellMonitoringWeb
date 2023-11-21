package iotBadSmellMonitoring.history.service.impl;

import iotBadSmellMonitoring.history.service.RegisterVO;

/**
 * @ Class Name   : RegisterMapper.java
 * @ Modification : REGISTER MASTER / DETAIL MAPPER.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.04.    고재훈
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/

public interface RegisterMapper {

    /**
     * 접수 마스터 번호
     * @return           string
     * @throws Exception
     */
    String registerSmellRegisterNoSelect() throws Exception;

    /**
     * 접수 마스터 등록
     * @param registerVO REGISTER MASTER / DETAIL VO.
     * @return           int
     * @throws Exception
     */
    int registerMasterInsert(RegisterVO registerVO) throws Exception;

    /**
     * 접수 디테일 등록
     * @param registerVO REGISTER DETAIL / DETAIL VO.
     * @return           int
     * @throws Exception
     */
    int registerDetailInsert(RegisterVO registerVO) throws Exception;

    /**
     * 중복 데이터 검사
     * @param registerVO REGISTER DETAIL / DETAIL VO.
     * @return           String
     * @throws Exception
     */
    String registerCheckDuplicate(RegisterVO registerVO) throws Exception;

    /**
     * 중복 데이터 검사 후처리
     * @param registerVO REGISTER DETAIL / DETAIL VO.
     * @return           int
     * @throws Exception
     */
    int registerDuplicateUpdate(RegisterVO registerVO) throws Exception;

    /**
     * 중복 데이터 검사 후처리 (이미지 삭제)
     * @param registerVO REGISTER DETAIL / DETAIL VO.
     * @return           int
     * @throws Exception
     */
    void deleteBySmellRegisterNo(RegisterVO registerVO);
}
