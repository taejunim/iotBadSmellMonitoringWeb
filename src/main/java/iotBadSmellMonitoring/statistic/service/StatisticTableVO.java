package iotBadSmellMonitoring.statistic.service;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import lombok.Data;

import java.util.List;

/**
 * @ Class Name   : StatisticTableVO.java
 * @ Modification : Statistic Table VO
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2022.03.14.    조유영
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @ 2023.11.22     김우성
 **/
@Data
public class StatisticTableVO {

    private String userRegionMaster;            //지역 코드
    private String userRegionMasterName;        //지역 명
    private String userRegionDetail;            //지역 상세 코드
    private String userRegionDetailName;        //지역 상세명
    private String userTotalCount;              //총 입력 횟수
    private String userRegisterCount;           //감지 횟수
    private String userRegisterPercentage;      //감지 비율
    private String mainSmellValue;              //주요 감지 악취 강도 코드
    private String mainSmellType;               //주요 냄새 코드
    private String mainSmellValueName;          //주요 감지 악취 강도 명
    private String mainSmellTypeName;           //주요 냄새 명
    private String smellRegisterTime;           //냄새 접수 시간대
    private String smellRegisterTimeName;       //냄새 접수 시간대 명

    private List<EgovMap> list;                 //지역별 리스트

    /* 조회용 */
    private String searchStart;                 //조회 시작
    private String searchEnd;                   //조회 끝
    private String smellType;                   //취기
}
