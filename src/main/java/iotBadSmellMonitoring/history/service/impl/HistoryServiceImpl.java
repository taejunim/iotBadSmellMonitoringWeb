package iotBadSmellMonitoring.history.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.history.service.HistoryService;
import iotBadSmellMonitoring.history.service.HistoryVO;
import iotBadSmellMonitoring.member.service.MemberService;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ Class Name   : HistoryServiceImpl.java
 * @ Modification : HISTORY MASTER / DETAIL SERVICE IMPL
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.09.    고재훈
 * @
 * @   수정일         수정자
 * @ ---------    ---------
 * @
 **/

@Service
public class HistoryServiceImpl implements HistoryService {

    @Autowired
    SqlSession sqlSession;

    @Autowired
    private MemberService memberService;

    /**
     * HISTORY 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    public List<EgovMap> historyListSelect(HistoryVO historyVO) throws Exception {

        HistoryMapper historyMapper = sqlSession.getMapper(HistoryMapper.class);

        return historyMapper.historyListSelect(historyVO);
    }
    /**
     * 회원 리스트 TOTAL COUNT 조회
     * @param   historyVO
     * @return  int
     * @throws Exception
     */
    @Override
    public int historyListTotalCnt(HistoryVO historyVO) throws Exception {

        HistoryMapper mapper = sqlSession.getMapper(HistoryMapper.class);

        return mapper.historyListTotalCnt(historyVO);
    }
    /**
     * HISTORY IMG 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    public List<EgovMap> historyImgListSelect(HistoryVO historyVO) throws Exception {

        HistoryMapper historyMapper = sqlSession.getMapper(HistoryMapper.class);

        return historyMapper.historyImgListSelect(historyVO);
    }
    /**
    * USER_ID / USER_NAME GET
    * @throws Exception
    */
    @Override
    public void historyImgDelete(HistoryVO historyVo) throws Exception {

        HistoryMapper mapper = sqlSession.getMapper(HistoryMapper.class);

        mapper.historyImgDelete(historyVo);
    }
    /**
     * TODAY HISTORY 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    public EgovMap todayHistoryListSelect(String userId) throws Exception {

        HistoryMapper historyMapper = sqlSession.getMapper(HistoryMapper.class);

        return historyMapper.todayHistoryListSelect(userId);
    }

}
