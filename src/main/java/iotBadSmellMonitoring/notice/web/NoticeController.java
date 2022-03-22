package iotBadSmellMonitoring.notice.web;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import iotBadSmellMonitoring.common.message.MessageSend;
import iotBadSmellMonitoring.common.message.MessageVO;
import iotBadSmellMonitoring.member.service.MemberService;
import iotBadSmellMonitoring.notice.service.NoticeService;
import iotBadSmellMonitoring.notice.service.NoticeVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ Class Name   : NoticeController.java
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2022.03.14.    김재연
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/

@Controller
public class NoticeController {

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private MemberService memberService;

    //공지사항 조회
    @RequestMapping("/notice")
    public String notice(@ModelAttribute("noticeVO") NoticeVO noticeVO, ModelMap model) throws Exception {

        /*페이징 SETTING START*/
        PaginationInfo paginationInfo = new PaginationInfo();

        paginationInfo.setCurrentPageNo(noticeVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(noticeVO.getPageUnit());
        paginationInfo.setPageSize(noticeVO.getPageSize());

        noticeVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        noticeVO.setLastIndex(paginationInfo.getLastRecordIndex());
        noticeVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
        noticeVO.setDeviceGbn("web");                                                                                   //web default

        if(noticeVO.getPageIndex() != 1){
            noticeVO.setPageRowIndex(noticeVO.getPageIndex()*10-10);
        }

        paginationInfo.setTotalRecordCount(noticeService.noticeListTotalCnt(noticeVO));

        model.addAttribute("resultList", noticeService.noticeListSelect(noticeVO));
        model.addAttribute("paginationInfo", paginationInfo);
        /*페이징 SETTING END*/

        return "notice";
    }

    //공지사항 등록/수정
    @RequestMapping(value = "/noticeInsertUpdate", method = RequestMethod.POST)
    public @ResponseBody void noticeInsertUpdate(@ModelAttribute NoticeVO noticeVO, HttpSession session) throws Exception {
        noticeVO.setRegId((String)session.getAttribute("userName"));            //등록자
        noticeVO.setModId((String)session.getAttribute("userName"));            //수정자
        noticeService.noticeInsertUpdate(noticeVO);
    }

    //공지사항 삭제
    @RequestMapping(value = "/noticeDelete", method = RequestMethod.POST)
    public @ResponseBody void memberDelete(@ModelAttribute NoticeVO noticeVO) throws Exception {

        noticeService.noticeDelete(noticeVO);
    }

    //악취 접수 독려 메세지 전송
    @RequestMapping(value = "/sendEncourageMessage", method = RequestMethod.POST)
    public @ResponseBody Map<String,Object> sendEncourageMessage() throws Exception {

        List<MessageVO> memberList = memberService.userPhoneNumberListSelect();
        Map<String, Object> result = new HashMap<>();
        try {
            MessageSend messageSend = new MessageSend();
            messageSend.sendManyKakaoMessage(memberList);
            result.put("result","success");
        } catch (Exception e){
            result.put("result","error");
            result.put("errorMessage",e.getMessage());
        }
        return result;
    }

    //공지사항 메세지 전송
    @RequestMapping(value = "/sendNotice", method = RequestMethod.POST)
    public @ResponseBody Map<String,Object> sendNotice(@ModelAttribute NoticeVO noticeVO) throws Exception {

        List<MessageVO> memberList = memberService.userPhoneNumberListSelect();
        Map<String, Object> result = new HashMap<>();

        for (MessageVO messageVO : memberList) {
            messageVO.setText(noticeVO.getNoticeContents());
        }
        try {
            MessageSend messageSend = new MessageSend();
            messageSend.sendMany(memberList);
            result.put("result","success");
        } catch (Exception e){
            result.put("result","error");
            result.put("errorMessage",e.getMessage());
        }

        return result;
    }
}
