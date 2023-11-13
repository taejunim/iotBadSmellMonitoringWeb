package iotBadSmellMonitoring.main.service;

import iotBadSmellMonitoring.common.PageVO;
import lombok.Data;

@Data
public class MainSearchVo extends PageVO {
    private String userRegionMaster;                                                                                    //사용자 지역
    private String userRegionDetail;                                                                                    //사용자 지역 상세
    private String smellType;                                                                                           //냄새 타입
    private String smellValue;                                                                                           //냄새 타입
    private String startDate;              //등록일자_시작
    private String endDate;                //등록일자_종료
}
