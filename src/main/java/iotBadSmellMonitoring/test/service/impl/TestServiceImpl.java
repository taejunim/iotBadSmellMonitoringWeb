package iotBadSmellMonitoring.test.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.test.service.TestService;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TestServiceImpl implements TestService {

    @Autowired
    SqlSession sqlSession;

    public List<EgovMap> selectTest() {

        TestMapper testMapper = sqlSession.getMapper(TestMapper.class);

        return testMapper.selectTest();
    }
}
