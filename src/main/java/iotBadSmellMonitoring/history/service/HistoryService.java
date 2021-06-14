package iotBadSmellMonitoring.history.service;

import egovframework.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

/**
 * @ Class Name   : HistoryService.java
 * @ Modification : HISTORY MASTER / DETAIL SERVICE
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.09.    고재훈
 * @
 * @    수정일        수정자
 * @ ---------    ---------
 * @
 **/

public interface HistoryService {

    /**
     * HISTORY 목록
     * @return           List<EgovMap>
     * @throws Exception
     */
    List<EgovMap> historyListSelect(HistoryVO historyVO) throws Exception;

    /**
     * HISTORY IMG 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    List<EgovMap> historyImgListSelect(HistoryVO historyVO) throws Exception;

    /**
     * TODAY HISTORY 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    EgovMap todayHistoryListSelect(String userId) throws Exception;

}
