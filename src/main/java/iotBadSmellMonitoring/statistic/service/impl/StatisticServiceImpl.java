package iotBadSmellMonitoring.statistic.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.statistic.service.StatisticService;
import iotBadSmellMonitoring.statistic.service.StatisticVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ Class Name   : StatisticServiceImpl.java
 * @ Modification : Statistic SERVICE IMPL
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.10.    고재훈
 * @
 * @   수정일         수정자
 * @ ---------    ---------
 * @
 **/
@Service
public class StatisticServiceImpl implements StatisticService {

    @Autowired
    SqlSession sqlSession;

    /**
     * 당일 통계 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    public List<EgovMap> todayStatisticListSelect(StatisticVO statisticVO) throws Exception {

        StatisticMapper statisticMapper = sqlSession.getMapper(StatisticMapper.class);

        return statisticMapper.todayStatisticListSelect(statisticVO);
    }

}
