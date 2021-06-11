package iotBadSmellMonitoring.history.service;

import iotBadSmellMonitoring.common.PageVO;
import lombok.Data;

/**
 * @ Class Name   : HistoryVO.java
 * @ Modification : HISTORY MASTER / DETAIL VO.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.04.    고재훈
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/

@Data
public class HistoryVO extends PageVO {

    /*HISTORY MASTER START*/
    private String smellRegisterNo;                                                                                     //냄새_접수_번호(SR+YYYYMMDDHHMISS+SEQ(2자리))
    private String smellType;                                                                                           //냄새 타입(코드 테이블 참고)
    private String smellValue;                                                                                          //냄새 강도(코드 테이블 참고)
    private String weaterState;                                                                                         //날씨 상태(코드 테이블 참고)
    private String temperatureValue;                                                                                    //온도
    private String humidityValue;                                                                                       //습도
    private String windDirectionValue;                                                                                  //풍향
    private String windSpeedValue;                                                                                      //풍속
    private String gpsX;                                                                                                //좌표 X
    private String gpsY;                                                                                                //좌표 Y
    private String smellComment;                                                                                        //냄새 설명
    private String smellRegisterTime;                                                                                   //냄새 접수 시간대(코드 테이블 참조)
    private String regId;                                                                                               //사용자 아이디
    /*HISTORY MASTER END*/

    /*HISTORY DETAIL START*/
    private String smellImageNo;                                                                                        //냄새_이미지_번호(IM+YYYYMMDDHHMISS+SEQ(2자리))
    private String smellImagePath;                                                                                      //냄새 이미지 경로
    /*HISTORY DETAIL END*/

}