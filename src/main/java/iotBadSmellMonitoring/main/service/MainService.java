package iotBadSmellMonitoring.main.service;

import egovframework.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

/**
 * @ Class Name   : MainService.java
 * @ Modification : PC 공통 관련 SERVICE.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.04.    고재훈
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/
public interface MainService {

    /**
     * 코드 목록
     * @param mainVO     PC 공통 관련 VO.
     * @return           List<EgovMap>
     * @throws Exception
     */
     List<EgovMap> codeListSelect(MainVO mainVO) throws Exception;

}
