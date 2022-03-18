package iotBadSmellMonitoring.member.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.member.service.AttendService;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @ Class Name   : AttendServiceImpl.java
 * @ Modification : USER ATTEND SERVICEIMPL.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2022.03.17.    허지명
 * @
 * @  수정일           수정자
 * @ ---------    ---------
 * @ 2022.03.18     고재훈
 **/
@Service
public class AttendServiceImpl implements AttendService {
    @Autowired
    SqlSession sqlSession;

    /**
     * 출석 회원 리스트 목록
     * @param joinVO
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> attendUserList(JoinVO joinVO) throws Exception {

        AttendMapper mapper = sqlSession.getMapper(AttendMapper.class);

        return mapper.attendUserList(joinVO);
    }

    /**
     * 출석 여부 확인 리스트 목록
     * @param joinVO
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> attendUserCheckList(JoinVO joinVO) throws Exception {

        AttendMapper mapper = sqlSession.getMapper(AttendMapper.class);

        return mapper.attendUserCheckList(joinVO);
    }

}
