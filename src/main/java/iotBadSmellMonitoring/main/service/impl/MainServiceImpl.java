package iotBadSmellMonitoring.main.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ Class Name   : MainServiceImpl.java
 * @ Modification : PC 공통 관련 SERVICE IMPL.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.04.    고재훈
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/
@Service
public class MainServiceImpl implements MainService {

    @Autowired
    SqlSession sqlSession;

    /**
     * PC 메인 목록
     * @param mainVO     PC 공통 관련 VO.
     * @return           List<EgovMap>
     * @throws Exception
     */
    public List<EgovMap> pcMainListSelect(MainVO mainVO) throws Exception {

        MainMapper mainMapper = sqlSession.getMapper(MainMapper.class);

        return mainMapper.pcMainListSelect(mainVO);
    }

    /**
     * 코드 목록
     * @param mainVO     PC 공통 관련 VO.
     * @return           List<EgovMap>
     * @throws Exception
     */
    @Override
    public List<EgovMap> codeListSelect(MainVO mainVO) throws Exception {

        MainMapper mainMapper = sqlSession.getMapper(MainMapper.class);

        return mainMapper.codeListSelect(mainVO);
    }

    /**
     * 모바일 기상청 데이터를 위한 X,Y
     * @param userRegion    사용자 지역
     * @return              EgovMap
     * @throws Exception
     */
    @Override
    public EgovMap getUserWeather(String userRegion) throws Exception {

        MainMapper mainMapper = sqlSession.getMapper(MainMapper.class);

        return mainMapper.getUserWeather(userRegion);
    }

}
