package iotBadSmellMonitoring.statistic.service;

import egovframework.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface StatisticService {

    /**
     * 당일 통계 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    List<EgovMap> todayStatisticListSelect(StatisticVO statisticVO) throws Exception;

}