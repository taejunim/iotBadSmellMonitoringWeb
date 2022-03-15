package iotBadSmellMonitoring.notice.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.notice.service.NoticeVO;

import java.util.List;
/**
 * @ Class Name   : NoticeMapper.java
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2022.03.14.    김재연
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/
public interface NoticeMapper {

    /**
     * 공지사항 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    List<EgovMap> noticeListSelect(NoticeVO noticeVO) throws Exception;

    /**
     * 공지사항 목록 TOTAL COUNT
     * @param   noticeVO
     * @return  int
     * @throws Exception
     */
    int noticeListTotalCnt(NoticeVO noticeVO) throws Exception;

    /**
     * 공지사항 등록/수정
     * @param   noticeVO
     * @return
     * @throws Exception
     */
    int noticeInsertUpdate(NoticeVO noticeVO)throws Exception;

    /**
     * 공지사항 삭제
     * @param   noticeVO
     * @return
     * @throws Exception
     */
    void noticeDelete(NoticeVO noticeVO) throws Exception;

}
