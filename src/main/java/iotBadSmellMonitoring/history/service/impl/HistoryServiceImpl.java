package iotBadSmellMonitoring.history.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.history.service.HistoryService;
import iotBadSmellMonitoring.history.service.HistoryVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;
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

    @Value("${server.path}")
    private String serverPath;

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
    * REGISTER DETAIL 삭제
    * @throws Exception
    */
    @Override
    public int historyImgDelete(HistoryVO historyVo) throws Exception {

        HistoryMapper mapper = sqlSession.getMapper(HistoryMapper.class);

        int result = 0;

        result = mapper.historyImgDelete(historyVo);

        if(result == 1){

            File file = new File(historyVo.getSmellOriginalPath());

            if( file.exists() ){

                if(file.delete())
                    result = 1;

                else
                    result = 0;
            }
        }

        return result;
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

    /**
     * HISTORY 엑셀 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    public List<EgovMap> historyListExcelSelect(HistoryVO historyVO) throws Exception {

        HistoryMapper historyMapper = sqlSession.getMapper(HistoryMapper.class);

        return historyMapper.historyListExcelSelect(historyVO);
    }

}
