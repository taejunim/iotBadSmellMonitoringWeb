package iotBadSmellMonitoring.join.service;

import iotBadSmellMonitoring.common.PageVO;
import lombok.Data;

/**
 * @ Class Name   : JoinVO.java
 * @ Modification : 회원가입 / 로그인 / 아이디 찾기 관련 VO.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.03.    고재훈
 * @
 * @   수정일         수정자
 * @ ---------    ---------
 * @
 **/

@Data
public class JoinVO extends PageVO {

    private String userId;                                                                                              //아이디
    private String userPassword;                                                                                        //사용자_비밀번호(mysql password 함수 쓰면 무조건 41자리 나와서 char41로 FIX)
    private String userType;                                                                                            //사용자 구분(코드 테이블 참조)
    private String userName;                                                                                            //이름
    private String userSex;                                                                                             //성별(코드 테이블 참조)
    private String userAge;                                                                                             //나이
    private String userRegionMaster;                                                                                    //사용자 지역
    private String userRegionDetail;                                                                                    //사용자 지역 상세
    private String userPhone;                                                                                           //사용자 휴대폰
    private String signInStatus;                                                                                        //관리자 승인 상태
    private String regDt;

}
