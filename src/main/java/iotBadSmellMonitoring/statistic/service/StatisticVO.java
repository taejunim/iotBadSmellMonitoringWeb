package iotBadSmellMonitoring.statistic.service;

import lombok.Data;

/**
 * @ Class Name   : StatisticVO.java
 * @ Modification : Statistic VO
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.10.    고재훈
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/
@Data
public class StatisticVO {

    private String regDt;                                                                                               //일자
    private String smellRegisterTime001 = "Y";                                                                          //냄새 접수 시간대(코드 테이블 참조) 07:00 ~ 09:00
    private String smellRegisterTime002 = "Y";                                                                          //냄새 접수 시간대(코드 테이블 참조) 12:00 ~ 14:00
    private String smellRegisterTime003 = "Y";                                                                          //냄새 접수 시간대(코드 테이블 참조) 18:00 ~ 20:00
    private String smellRegisterTime004 = "Y";                                                                          //냄새 접수 시간대(코드 테이블 참조) 22:00 ~ 00:00
    private String searchGbn;                                                                                           //조회 구분(당일:today,일:day,월:month,연:year)
    private String region;                                                                                              //지역
    private String searchStart;                                                                                         //조회 시작
    private String searchEnd;                                                                                           //조회 끝

}
