package iotBadSmellMonitoring.notice.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.notice.service.NoticeService;
import iotBadSmellMonitoring.notice.service.NoticeVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
/**
 * @ Class Name   : NoticeServiceImpl.java
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2022.03.14.    김재연
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/
@Service
public class NoticeServiceImpl implements NoticeService {


    @Autowired
    SqlSession sqlSession;

    /**
     * 공지사항 목록
     * @return List<EgovMap>
     * @throws Exception
     */
    @Override
    public List<EgovMap> noticeListSelect(NoticeVO noticeVO) throws Exception {

        NoticeMapper mapper = sqlSession.getMapper(NoticeMapper.class);

        return mapper.noticeListSelect(noticeVO);
    }

    /**
     * 공지사항 TOTAL COUNT
     * @param   noticeVO
     * @return  int
     * @throws Exception
     */
    @Override
    public int noticeListTotalCnt(NoticeVO noticeVO) throws Exception {

        NoticeMapper mapper = sqlSession.getMapper(NoticeMapper.class);

        return mapper.noticeListTotalCnt(noticeVO);
    }

    /**
     * 공지사항 등록/수정
     * @param   noticeVO
     * @return
     * @throws Exception
     */
    @Override
    public int noticeInsertUpdate(NoticeVO noticeVO) throws Exception {

        NoticeMapper mapper = sqlSession.getMapper(NoticeMapper.class);

        return mapper.noticeInsertUpdate(noticeVO);
    }

    /**
     * 공지사항 삭제
     * @param   noticeVO
     * @return  void
     * @throws Exception
     */
    @Override
    public void noticeDelete(NoticeVO noticeVO) throws Exception {

        NoticeMapper mapper = sqlSession.getMapper(NoticeMapper.class);

        mapper.noticeDelete(noticeVO);
    }


}
