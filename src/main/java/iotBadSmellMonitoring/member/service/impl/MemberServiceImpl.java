package iotBadSmellMonitoring.member.service.impl;

import iotBadSmellMonitoring.member.service.MemberService;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

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

public class MemberServiceImpl implements MemberService {

    @Autowired
    SqlSession sqlSession;

}
