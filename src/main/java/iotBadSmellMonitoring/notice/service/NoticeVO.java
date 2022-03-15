package iotBadSmellMonitoring.notice.service;

import iotBadSmellMonitoring.common.PageVO;
import lombok.Data;
/**
 * @ Class Name   : NoticeVO.java
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2022.03.14.   김재연
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/
@Data
public class NoticeVO  extends PageVO{
    private String noticeId;               //noticeId_pk
    private String noticeTitle;            //제목
    private String noticeContents;         //내용
    private String regId;                  //등록자
    private String regDt;                  //등록일자
    private String modId;                  //수정자
    private String modDt;                  //수정일자
    private String startDate;              //등록일자_시작
    private String endDate;                //등록일자_종료
    private String deviceGbn;              //web or mobile 구분
}
