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
 * @ Modification : 출석일지 SERVICE IMPL
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2022.03.17.    허지명
 * @
 * @   수정일         수정자
 * @ ---------    ---------
 * @
 **/
@Service
public class AttendServiceImpl implements AttendService {
    @Autowired
    SqlSession sqlSession;

    /**
     * 회원 리스트 조회
     * @param joinVO
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> memberListSelect(JoinVO joinVO) throws Exception {

        AttendMapper mapper = sqlSession.getMapper(AttendMapper.class);

        return mapper.memberListSelect(joinVO);
    }

    /**
     * 회원 전체 리스트 조회
     * @param joinVO
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> memberListSelectTotal(JoinVO joinVO) throws Exception {

        AttendMapper mapper = sqlSession.getMapper(AttendMapper.class);

        return mapper.memberListSelectTotal(joinVO);
    }

    /**
     * 회원 리스트 TOTAL COUNT 조회
     * @param joinVO
     * @return
     * @throws Exception
     */
    @Override
    public int memberListTotalCnt(JoinVO joinVO) throws Exception {

        AttendMapper mapper = sqlSession.getMapper(AttendMapper.class);

        return mapper.memberListTotalCnt(joinVO);
    }

    /**
     * 날짜 데이터, 접수 데이터 매칭
     * @param parameter
     * @return
     * @throws Exception
     */
    public List<EgovMap> attendListSelect(Map<String, String> parameter) throws Exception {

        AttendMapper AttendMapper = sqlSession.getMapper(AttendMapper.class);

        return AttendMapper.attendListSelect(parameter);
    }
}
