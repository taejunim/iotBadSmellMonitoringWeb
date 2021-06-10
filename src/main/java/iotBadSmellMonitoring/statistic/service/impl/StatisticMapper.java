package iotBadSmellMonitoring.statistic.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.statistic.service.StatisticVO;

import java.util.List;

/**
 * @ Class Name   : StatisticMapper.java
 * @ Modification : Statistic MAPPER.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.10.    고재훈
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/
public interface StatisticMapper {

    /**
     * 당일 통계 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    List<EgovMap> todayStatisticListSelect(StatisticVO statisticVO) throws Exception;

}
