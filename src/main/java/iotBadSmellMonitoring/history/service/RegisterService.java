package iotBadSmellMonitoring.history.service;

/**
 * @ Class Name   : RegisterService.java
 * @ Modification : REGISTER MASTER / DETAIL SERVICE
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.04.    고재훈
 * @
 * @    수정일        수정자
 * @ ---------    ---------
 * @
 **/

public interface RegisterService {

    /**
     * 접수 마스터||디테일 등록
     * @param registerVO REGISTER MASTER / DETAIL VO.
     * @return           int
     * @throws Exception
     */
    int registerInsert(RegisterVO registerVO) throws Exception;

    /**
     * KT API 를 활용하여 미세먼지 데이터 SET
     * @param registerVO
     * @return           registerVO
     * @throws Exception
     */
    RegisterVO getFineDustInformation(RegisterVO registerVO) throws Exception;

}
