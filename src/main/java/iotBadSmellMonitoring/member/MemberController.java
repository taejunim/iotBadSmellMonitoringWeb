package iotBadSmellMonitoring.member;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MemberController {
    //회원관리
    @RequestMapping("/member")
    public String memberManagement(ModelMap model) {

        /*페이징 SETTING START*/
        PaginationInfo paginationInfo = new PaginationInfo();

        paginationInfo.setCurrentPageNo(1);
        paginationInfo.setRecordCountPerPage(10);
        paginationInfo.setPageSize(10);


        paginationInfo.setTotalRecordCount(100);

        System.out.println("========================");
        System.out.println(paginationInfo);
        model.addAttribute("paginationInfo", paginationInfo);
        /*페이징 SETTING END*/

        return "memberManagement";
    }
}
