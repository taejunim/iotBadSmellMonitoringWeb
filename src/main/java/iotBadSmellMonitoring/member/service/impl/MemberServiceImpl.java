package iotBadSmellMonitoring.member.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.common.message.MessageVO;
import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.member.service.MemberService;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

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

    /**
     * 회원 탈퇴
     * @param   joinVO
     * @return
     * @throws Exception
     */
    @Override
    public int memberPasswordUpdate(JoinVO joinVO) throws Exception {

        MemberMapper mapper = sqlSession.getMapper(MemberMapper.class);

        return mapper.memberPasswordUpdate(joinVO);
    }

    @Override
    public void memberDelete(JoinVO joinVO) throws Exception {

        MemberMapper mapper = sqlSession.getMapper(MemberMapper.class);
        mapper.memberDelete(joinVO);
    }

    /**
     * 회원 승인
     * @param   joinVO
     * @return
     * @throws Exception
     */
    @Override
    public void memberConfirm(JoinVO joinVO) {
        MemberMapper mapper = sqlSession.getMapper(MemberMapper.class);
        mapper.memberConfirm(joinVO);
    }

    /**
     * 회원 거절
     * @param   joinVO
     * @return
     * @throws Exception
     */
    @Override
    public void memberRefuse(JoinVO joinVO) {
        MemberMapper mapper = sqlSession.getMapper(MemberMapper.class);
        mapper.memberRefuse(joinVO);
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

    /**
     * TODAY HISTORY 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    public List<Map<String, Object>> todayRegisterListSelect(Map<String, Object> dataList) throws Exception {

        MemberMapper memberMapper = sqlSession.getMapper(MemberMapper.class);

        return memberMapper.todayRegisterListSelect(dataList);
    }

    /**
     * USER PHONE CHECK
     * @param userPhone     휴대폰 번호
     * @return              EgovMap
     * @throws Exception
     */
    public EgovMap userPhoneCheck(String userPhone) throws Exception {

        MemberMapper memberMapper = sqlSession.getMapper(MemberMapper.class);

        return memberMapper.userPhoneCheck(userPhone);
    }

    /**
     * 메세지 전송될 사용자명, 번호 목록
     * @return List<MessageVO>
     * @throws Exception
     */
    public  List<MessageVO> userPhoneNumberListSelect() throws Exception {

        MemberMapper memberMapper = sqlSession.getMapper(MemberMapper.class);

        return memberMapper.userPhoneNumberListSelect();
    }

    /**
     * 메세지 전송될 관리자명, 번호 목록
     * @return List<MessageVO>
     * @throws Exception
     */
    public  List<MessageVO> adminPhoneNumberListSelect() throws Exception {

        MemberMapper memberMapper = sqlSession.getMapper(MemberMapper.class);

        return memberMapper.adminPhoneNumberListSelect();
    }

}
