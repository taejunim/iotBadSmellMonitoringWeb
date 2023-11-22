package iotBadSmellMonitoring.statistic.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.statistic.service.StatisticService;
import iotBadSmellMonitoring.statistic.service.StatisticTableVO;
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
     * 통계 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    public List<EgovMap> statisticListSelect(StatisticVO statisticVO) throws Exception {

        StatisticMapper statisticMapper = sqlSession.getMapper(StatisticMapper.class);

        return statisticMapper.statisticListSelect(statisticVO);
    }

    /**
     * 통계 표 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    public EgovMap statisticTableSelect(StatisticTableVO statisticTableVO) throws Exception {

        StatisticMapper statisticMapper = sqlSession.getMapper(StatisticMapper.class);

        //전체 통계 추가
        EgovMap list = statisticMapper.statisticTableAllSelect(statisticTableVO);
        //지역별 통계 추가
        list.put("list", statisticMapper.statisticTableRegionListSelect(statisticTableVO));

        return list;
    }

    /**
     * 통계 표 지역별 (단건, API용)
     * @return EgovMap
     * @throws Exception
     */
    public EgovMap statisticTableRegionSelect(StatisticTableVO statisticTableVO) throws Exception {

        StatisticMapper statisticMapper = sqlSession.getMapper(StatisticMapper.class);

        return statisticMapper.statisticTableRegionSelect(statisticTableVO);
    }

    /**
     * 취기 통계 전체 조회
     * @return EgovMap
     * @throws Exception
     */
    @Override
    public EgovMap statisticSmellTableTotal(StatisticTableVO statisticTableVO) throws Exception {
        StatisticMapper statisticMapper = sqlSession.getMapper(StatisticMapper.class);
        return statisticMapper.statisticSmellTableTotal(statisticTableVO);
    }

    /**
     * 취기 통계 전체 조회 (Detail)
     * @return EgovMap
     * @throws Exception
     */
    @Override
    public List<EgovMap> statisticSmellTableDetail(StatisticTableVO statisticTableVO) throws Exception {
        StatisticMapper statisticMapper = sqlSession.getMapper(StatisticMapper.class);
        return statisticMapper.statisticSmellTableDetail(statisticTableVO);
    }
    /**
     * 취기 마을별 통계
     * @return EgovMap
     * @throws Exception
     */
    @Override
    public List<EgovMap> statisticSmellTableTotalByRegion(StatisticTableVO statisticTableVO) throws Exception {
        StatisticMapper statisticMapper = sqlSession.getMapper(StatisticMapper.class);
        return statisticMapper.statisticSmellTableTotalByRegion(statisticTableVO);
    }
    /**
     * 취기 마을별 통계 (Detail)
     * @return EgovMap
     * @throws Exception
     */
    @Override
    public List<EgovMap> statisticSmellTableDetailByRegion(StatisticTableVO statisticTableVO) throws Exception {
        StatisticMapper statisticMapper = sqlSession.getMapper(StatisticMapper.class);
        return statisticMapper.statisticSmellTableDetailByRegion(statisticTableVO);
    }

    @Override
    public EgovMap userRegionDetailCode(StatisticTableVO statisticTableVO) throws Exception {
        StatisticMapper statisticMapper = sqlSession.getMapper(StatisticMapper.class);
        return statisticMapper.userRegionDetailCode(statisticTableVO);
    }


}
