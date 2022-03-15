package iotBadSmellMonitoring.statistic.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.statistic.service.StatisticTableVO;
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
     * 통계 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    List<EgovMap> statisticListSelect(StatisticVO statisticVO) throws Exception;

    /**
     * 통계 표 전체
     * @return EgovMap
     * @throws Exception
     */
    EgovMap statisticTableAllSelect(StatisticTableVO statisticTableVO) throws Exception;

    /**
     * 통계 표 지역별
     * @return List<EgovMap>
     * @throws Exception
     */
    List<EgovMap> statisticTableRegionListSelect(StatisticTableVO statisticTableVO) throws Exception;

    /**
     * 통계 표 지역별 (단건, API용)
     * @return EgovMap
     * @throws Exception
     */
    EgovMap statisticTableRegionSelect(StatisticTableVO statisticTableVO) throws Exception;

}
