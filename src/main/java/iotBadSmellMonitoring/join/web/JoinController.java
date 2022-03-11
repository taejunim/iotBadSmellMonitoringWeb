package iotBadSmellMonitoring.join.web;

import iotBadSmellMonitoring.join.service.JoinService;
import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.KakaoOption;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.MultipleMessageSendingRequest;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.MultipleMessageSentResponse;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

/**
 * @ Class Name   : JoinController.java
 * @ Modification : 회원가입 / 아이디 찾기 관련 CONTROLLER
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.03.    고재훈
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/
@Controller
public class JoinController {

    private final DefaultMessageService messageService;

    /**
     * 발급받은 API KEY와 API Secret Key를 사용해주세요.
     */
    public JoinController() {
        this.messageService = NurigoApp.INSTANCE.initialize("NCSIBRLPU8MXHJSZ", "WNIG3XTACTIFD1QIIEYN4RIBQU6O1LFE", "https://api.solapi.com");
    }

    @Autowired
    private MainService mainService;

    @Autowired
    private JoinService joinService;

    //회원가입 화면
    @RequestMapping("/join")
    public String join(HttpSession session, ModelMap model) throws Exception{

        /*성별, 구분 SETTING START*/
            // 처음 한번만 값을 가져와서 세션에 저장
            if(session.getAttribute("CG_UST") == null){

                MainVO mainVO = new MainVO();

                mainVO.setCodeGroup("SEX");
                session.setAttribute("CG_SEX",mainService.codeListSelect(mainVO));
                model.addAttribute("CG_SEX",session.getAttribute("CG_SEX"));

                mainVO.setCodeGroup("UST");
                session.setAttribute("CG_UST",mainService.codeListSelect(mainVO));
                model.addAttribute("CG_UST",session.getAttribute("CG_UST"));

                mainVO.setCodeGroup("RGD");
                session.setAttribute("CG_RGN",mainService.codeListSelect(mainVO));
                model.addAttribute("CG_RGN",session.getAttribute("CG_RGN"));

            }
            // 세션에 값을 저장했을 경우 세션값을  model에 넘겨줌
            else{
                model.addAttribute("CG_UST",session.getAttribute("CG_UST"));
                model.addAttribute("CG_SEX",session.getAttribute("CG_SEX"));
                model.addAttribute("CG_RGN",session.getAttribute("CG_RGN"));
            }
        /*성별, 구분 SETTING END*/

        return "join";
    }


    //회원 가입 요청
    @RequestMapping(value = "/join/userJoinInsert", method = RequestMethod.POST)
    public @ResponseBody String userJoinInsert(@ModelAttribute JoinVO joinVO) throws Exception {
        System.out.println("JoinVO  --->  " + joinVO);
        String result = "";

        //예외처리
        try {
            joinService.userJoinInsert(joinVO);
            result = "success";
        }catch (Exception e) {
            result = "fail";
        }
        return result;
    }

    //아이디 중복 체크
    @RequestMapping(value = "/join/userFindIdSelect", method = RequestMethod.POST)
    public @ResponseBody String userFindIdSelect(@RequestParam String userId) throws Exception {

        String result = "";
        result = joinService.userFindIdSelect(userId);

        /*Message message = new Message();
        message.setFrom("01050541386");
        message.setTo("01033591522");
        message.setText("한글 45자, 영자 90자 이하 입력되면 자동으로 SMS타입의 메시지가 추가됩니다.");

        SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));
        System.out.println(response);*/

        /*ArrayList<Message> messageList = new ArrayList<>();

        String[] a = new String[]{"01033591522", "01068936803" , "01037288621"};

        for (int i = 0; i < 3; i++) {
            Message message = new Message();
            message.setFrom("01050541386");
            message.setTo(a[i]);
            message.setText("문자 테스트"+i);

            messageList.add(message);
        }
        MultipleMessageSendingRequest request = new MultipleMessageSendingRequest(messageList);
        // allowDuplicates를 true로 설정하실 경우 중복으로 수신번호를 입력해도 각각 발송됩니다.
        // request.setAllowDuplicates(true);

        MultipleMessageSentResponse response = this.messageService.sendMany(request);
        System.out.println(response);*/




        /*KakaoOption kakaoOption = new KakaoOption();
        // disableSms를 true로 설정하실 경우 문자로 대체발송 되지 않습니다.
        // kakaoOption.setDisableSms(true);

        // 등록하신 카카오 비즈니스 채널의 pfId를 입력해주세요.
        kakaoOption.setPfId("KA01PF190227072057634pRBhbpAw1w1");
        // 등록하신 카카오 알림톡 템플릿의 templateId를 입력해주세요.
        kakaoOption.setTemplateId("test_2019030716320324334488000");

        // 알림톡 템플릿 내에 #{변수} 형태가 존재할 경우 variables를 설정해주세요.
        *//*
        HashMap<String, String> variables = new HashMap<>();
        variables.put("#{변수명1}", "테스트");
        variables.put("#{변수명2}", "치환문구 테스트2");
        kakaoOption.setVariables(variables);
        *//*

        Message message = new Message();
        message.setFrom("029302266");
        message.setTo("01050541386");
        message.setKakaoOptions(kakaoOption);

        SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));
        System.out.println(response);*/


        String targetUrl = "http://api.solapi.com/messages/v4/send";
        String parameters = "{\"message\":{\"to\":\"01050541386\",\"from\":\"029302266\",\"text\":\"#{홍길동}님이 요청하신 출금 요청 처리가 완료되어 아래 정보로 입금 처리되었습니다. #{입금정보} 관련하여 문의 있으시다면'1:1문의하기'를이용부탁드립니다. 감사합니다.\",\"type\":\"ATA\",\"kakaoOptions\":{\"pfId\":\"KA01PF190227072057634pRBhbpAw1w1\",\"templateId\":\"test_2019030716320324334488000\",\"buttons\":[{\"buttonType\":\"WL\",\"buttonName\":\"1:1문의\",\"linkMo\":\"https://www.example.com\"}]}}}";

        URL url = new URL(targetUrl);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();

        con.setRequestMethod("POST");

        con.setRequestProperty("Authorization", "HMAC-SHA256 apiKey=NCSAYU7YDBXYORXC, date=2019-07-01T00:41:48Z, salt=jqsba2jxjnrjor, signature=1779eac71a24cbeeadfa7263cb84b7ea0af1714f5c0270aa30ffd34600e363b4");
        con.setRequestProperty("Content-Type", "application/json");

        con.setDoOutput(true);
        DataOutputStream wr = new DataOutputStream(con.getOutputStream());
        wr.writeBytes(parameters);
        wr.flush();
        wr.close();

        int responseCode = con.getResponseCode();
        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String line;
        StringBuffer response = new StringBuffer();
        while ((line = in.readLine()) != null) {
            response.append(line);
        }
        in.close();

        System.out.println("HTTP response code : " + responseCode);
        System.out.println("HTTP body : " + response.toString());

        return result;
    }

}
