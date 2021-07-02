package iotBadSmellMonitoring.myPage;

import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import iotBadSmellMonitoring.member.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

@Controller
public class MyPageController {

    @Autowired
    private MemberService memberService;


    //마이페이지 화면
    @RequestMapping("/myPage")
    public String menu(){

        return "myPage";
    }

    //회원 비밀번호 변경
    @RequestMapping(value = "/myPagePasswordUpdate", method = RequestMethod.POST)
    public @ResponseBody
    void memberPasswordUpdate(@ModelAttribute JoinVO joinVO) throws Exception {

        memberService.memberPasswordUpdate(joinVO);
    }

    //회원 탈퇴
    @RequestMapping(value = "/myPageDelete", method = RequestMethod.POST)
    public @ResponseBody void memberDelete(@ModelAttribute JoinVO joinVO) throws Exception {

      memberService.memberDelete(joinVO);

    }
}
