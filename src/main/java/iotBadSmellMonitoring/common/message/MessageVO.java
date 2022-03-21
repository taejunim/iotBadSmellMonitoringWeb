package iotBadSmellMonitoring.common.message;

import lombok.Data;

/**
 * @ Class Name   : MessageVO.java
 * @ Notification : MESSAGE SEND VO CLASS.
 * @
 * @ 최초 생성일      최초 생성자
 * @ ---------    ---------
 * @ 2022.03.21.    조유영
 * @
 * @  수정일          수정자
 * @ ---------    ---------
 * @
 **/

@SuppressWarnings("serial")
@Data
public class MessageVO {

    private String from;                                                                                                // 메시지 수신 대상
    private String to;                                                                                                  // 메시지 발신 대상
    private String text;                                                                                                // 메시니 내용

}