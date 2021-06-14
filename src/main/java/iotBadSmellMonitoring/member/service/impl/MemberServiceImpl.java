package iotBadSmellMonitoring.member.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.member.service.MemberService;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ Class Name   : MemberServiceImpl.java
 * @ Modification : 회원관리 SERVICE IMPL
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.04.    양유정
 * @
 * @   수정일         수정자
 * @ ---------    ---------
 * @
 **/
@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    SqlSession sqlSession;

    /**
     * 회원 리스트 조회
     * @param   joinVO
     * @return  list
     * @throws Exception
     */
    @Override
    public List<EgovMap> memberListSelect(JoinVO joinVO) throws Exception {

        MemberMapper mapper = sqlSession.getMapper(MemberMapper.class);

        return mapper.memberListSelect(joinVO);
    }

    /**
     * 회원 리스트 TOTAL COUNT 조회
     * @param   joinVO
     * @return  int
     * @throws Exception
     */
    @Override
    public int memberListTotalCnt(JoinVO joinVO) throws Exception {

        MemberMapper mapper = sqlSession.getMapper(MemberMapper.class);

        return mapper.memberListTotalCnt(joinVO);
    }

    @Override
    public void memberPasswordUpdate(JoinVO joinVO) throws Exception {

        MemberMapper mapper = sqlSession.getMapper(MemberMapper.class);
        mapper.memberPasswordUpdate(joinVO);
    }

    @Override
    public void memberDelete(JoinVO joinVO) throws Exception {

        MemberMapper mapper = sqlSession.getMapper(MemberMapper.class);
        mapper.memberDelete(joinVO);
    }

    /**
     * USER_ID / USER_NAME GET
     * @param  userId
     * @return
     * @throws Exception
     */
    @Override
    public EgovMap memberGetInfoSelect(String userId) throws Exception {

        MemberMapper mapper = sqlSession.getMapper(MemberMapper.class);

        return mapper.memberGetInfoSelect(userId);
    }

}
