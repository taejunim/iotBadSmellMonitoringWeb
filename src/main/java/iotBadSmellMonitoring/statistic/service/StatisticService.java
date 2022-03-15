package iotBadSmellMonitoring.statistic.service;

import egovframework.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface StatisticService {

    /**
     * 통계 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    List<EgovMap> statisticListSelect(StatisticVO statisticVO) throws Exception;

    /**
     * 통계 표 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    EgovMap statisticTableSelect(StatisticTableVO statisticTableVO) throws Exception;

    /**
     * 통계 표 지역별 (단건, API용)
     * @return EgovMap
     * @throws Exception
     */
    EgovMap statisticTableRegionSelect(StatisticTableVO statisticTableVO) throws Exception;
}
