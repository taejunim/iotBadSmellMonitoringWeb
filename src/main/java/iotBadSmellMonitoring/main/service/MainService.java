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
     * PC 메인 목록
     * @param mainSearchVo     PC 공통 관련 VO.
     * @return           List<EgovMap>
     * @throws Exception
     */
    List<EgovMap> pcMainListSelect(MainSearchVo mainSearchVo) throws Exception;

    /**
     * PC 메인 목록
     * @param mainSearchVo     PC 공통 화면 검색 VO.
     * @return           List<EgovMap>
     * @throws Exception
     */
    List<EgovMap> pcMainListFindByMember(MainSearchVo mainSearchVo) throws Exception;

    /**
     * 모든 REGISTER 조회
     * @return List<EgovMap>
     * @throws Exception
     */
    List<EgovMap> pcMainListSelectAll(MainSearchVo mainSearchVo) throws Exception;

    /**
     * 코드 목록
     * @param mainVO     PC 공통 관련 VO.
     * @return           List<EgovMap>
     * @throws Exception
     */
     List<EgovMap> codeListSelect(MainVO mainVO) throws Exception;

    /**
     * 모바일 기상청 데이터를 위한 X,Y
     * @param userRegion    사용자 지역
     * @return              EgovMap
     * @throws Exception
     */
     EgovMap getUserWeather(String userRegion) throws Exception;

}
