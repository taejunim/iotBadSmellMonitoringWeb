package iotBadSmellMonitoring.statistic.common;

import egovframework.rte.psl.dataaccess.util.EgovMap;

import java.util.List;
import java.util.Map;

public class StatisticUtils {
    public static void addSelectByRegion(List<EgovMap> list, Map<String, Object> regionCountMap, String regionMaster, int regionMasterCount) { // 엑셀 다운로드 시 중복 지역 셀 병합 함수
        for(int i = 0 ;i < list.size() ; i ++){

            if(i == 0) regionMaster = list.get(i).get("userRegionMaster").toString();

            if(list.get(i).get("userRegionMaster").equals(regionMaster)){
                regionMasterCount ++;
            } else {
                regionCountMap.put(regionMaster,regionMasterCount);
                regionMaster = list.get(i).get("userRegionMaster").toString();
                regionMasterCount = 1;
            }
        }
    }
}
