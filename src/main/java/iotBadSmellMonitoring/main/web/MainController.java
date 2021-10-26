package iotBadSmellMonitoring.main.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.history.service.RegisterService;
import iotBadSmellMonitoring.history.service.RegisterVO;
import iotBadSmellMonitoring.join.service.JoinService;
import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * @ Class Name   : MainController.java
 * @ Modification : MAIN CONTROLLER (로그인 , 메뉴, 메인화면)
 * @
 * @ 최초 생성일  최초 생성자
 * @ ---------    ---------
 * @ 2021.06.01.    조유영
 * @
 * @ 수정일        수정자
 * @ ---------    ---------
 * @
 **/

@Controller
public class MainController {

    @Autowired
    private MainService mainService;       //메인화면 관련 SERVICE.
    @Autowired
    private JoinService joinService;       //회원가입 / 로그인 / 아이디 찾기 관련 SERVICE.
    @Autowired
    private RegisterService registerService;       //미세먼저 데이터 가져오기 위한 SERVICE.

    /**
     * 로그인 정보 확인후, 있으면 메인화면 없으면 로그인화면
     **/
    @RequestMapping("/")
    public void MainIndex(HttpServletResponse response, HttpServletRequest request) throws Exception {

        PrintWriter writer = response.getWriter();
        HttpSession session = request.getSession();
        Object result = session.getAttribute("userId");

        if (result == null) {
            writer.println("<script>location.href=\"login.do\";</script>");
        }
        //로그인 세션정보 있을 시 바로 메인으로 이동
        else {
            writer.println("<script>location.href=\"main.do\";</script>");
        }
    }

    //메뉴
    @RequestMapping("/menu")
    public String menu(){
        return "menu";
    }

    //메인
    @RequestMapping("/main")
    public String main(HttpSession session, ModelMap model) throws Exception{
        MainVO mainVO = new MainVO();
        /*냄새 강도 SETTING START*/
        // 처음 한번만 값을 가져와서 세션에 저장
        if(session.getAttribute("CG_SMT") == null){
            mainVO.setCodeGroup("SMT");
            session.setAttribute("CG_SMT",mainService.codeListSelect(mainVO));
            model.addAttribute("CG_SMT",session.getAttribute("CG_SMT"));
        }
        // 세션에 값을 저장했을 경우 세션값을  model에 넘겨줌
        else{
            model.addAttribute("CG_SMT",session.getAttribute("CG_SMT"));
        }

        RegisterVO registerVO = new RegisterVO();
        registerVO = registerService.getFineDustInformation(registerVO);

        String airSensingDate = "-";

        //KT API 결과 조회 못 할시에 예외 처리 실패시엔 화면에 - 표출
        if(registerVO.getAirSensingDate() != null && registerVO.getAirSensingDate() != "") {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
            Date date = dateFormat.parse(registerVO.getAirSensingDate());
            dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            airSensingDate = dateFormat.format(date);
        }

        String airSensorName = (registerVO.getAirSensorName() != null && registerVO.getAirSensorName() != "" )? registerVO.getAirSensorName() : "-";
        String pm10Avg = (registerVO.getPm10Avg() != null )? registerVO.getPm10Avg().toString() : "-";

        model.addAttribute("airSensorName",airSensorName);
        model.addAttribute("pm10Avg", pm10Avg);
        model.addAttribute("airSensingDate" ,airSensingDate);

        System.out.println(mainService.pcMainListSelect(mainVO));
        return "main";
    }

    //로그인
    @RequestMapping("/login")
    public String login(HttpSession session){
        session.invalidate();
        return "login";
    }

    //로그인 요청
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public @ResponseBody String getLogin(@ModelAttribute("joinVO") JoinVO joinVO, HttpServletRequest request) throws Exception {

        EgovMap egovMap = joinService.userLoginSelect(joinVO);     //로그인 CALL.
        String result = "";

        if (egovMap != null) {
            //일반 사용자 로그인 시도시 authFail
            if(egovMap.get("userType").equals("001"))  return "authFail";

            //로그인 성공시 user정보 session에 저장
            HttpSession session = request.getSession();
            session.setAttribute("userId", egovMap.get("userId"));                  //아이디
            session.setAttribute("userPassword", joinVO.getUserPassword());         //사용자_비밀번호(mysql password 함수 쓰면 무조건 41자리 나와서 char41로 FIX)
            session.setAttribute("userName", egovMap.get("userName"));              //이름
            session.setAttribute("userRegionName", egovMap.get("userRegionName"));  //지역
            session.setAttribute("userAge", egovMap.get("userAge"));                //나이
            session.setAttribute("userSexName", egovMap.get("userSexName"));        //성별 이름(코드 테이블 참조)
            session.setAttribute("userTypeName", egovMap.get("userTypeName"));      //사용자 구분 이름(코드 테이블 참조)

        } else {
            //로그인 정보 잘못되면 authFail
            result = "wrongFail";
        }

        return result;
    }

    //PC 메인 , 사용자별 가장 최근 접수 데이터 가져오기
    @RequestMapping(value = "/pcMainListSelect")
    public @ResponseBody List<EgovMap> pcMainListSelect() throws Exception {
        MainVO mainVO = new MainVO();
        return mainService.pcMainListSelect(mainVO);
    }
}
