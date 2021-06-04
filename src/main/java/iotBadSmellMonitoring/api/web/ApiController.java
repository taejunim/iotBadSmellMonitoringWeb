package iotBadSmellMonitoring.api.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.join.service.JoinService;
import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import org.json.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * @ Class Name   : ApiController.java
 * @ Modification : API SERVICE COTROLLER
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.03.    고재훈
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/


@RestController                 // spring 3.2부터 RestController 추가됨..@ResponseBody / Controller 기능을 포함하므로 따로 @ResponseBody를 안써도 됨.
public class ApiController {

    @Autowired
    private JoinService joinService;

    @Autowired
    private MainService mainService;

    /**
     * 회원가입 API
     * @param joinVO     회원가입 / 로그인 / 아이디 찾기 관련 VO.
     * @return           RESPONSE MESSAGE.
     * @throws Exception
     */
    @RequestMapping(value = "/api/userJoinInsert", method = RequestMethod.POST, consumes="application/json;", produces = "application/json;")
    public String userJoinInsert(@ModelAttribute("joinVO")JoinVO joinVO, HttpServletRequest request)  throws Exception {

        String message = "";

        try {

            BufferedReader  br 	        = new BufferedReader(new InputStreamReader(request.getInputStream(), StandardCharsets.UTF_8));
            String          paramValue  = parseJSONData(br);                                                            //JSON OBJECT TO STRING CALL.
            JSONParser      jsonParser  = new JSONParser();
            JSONObject      jsonObject  = (JSONObject)jsonParser.parse(paramValue);

            joinVO.setUserId(jsonObject.get("userId").toString());
            joinVO.setUserPassword(jsonObject.get("userPassword").toString());
            joinVO.setUserAge(jsonObject.get("userAge").toString());
            joinVO.setUserName(jsonObject.get("userName").toString());
            joinVO.setUserSex(jsonObject.get("userSex").toString());
            joinVO.setUserType(jsonObject.get("userType").toString());

            int result = joinService.userJoinInsert(joinVO);                                                            //회원가입 CALL.

            if(result == 1)
                message = "{\"result\":\"success\"}";

            else
                message = "{\"result\":\"fail\",\"message\": \"no Insert.\"}";

        }catch (Exception e){

            message = "{\"result\":\"fail\",\"message\":\""+e.getMessage()+"\"}";
       }

        return message;
    }

    /**
     * 로그인 API
     * @param joinVO     회원가입 / 로그인 / 아이디 찾기 관련 VO.
     * @return           RESPONSE MESSAGE.
     * @throws Exception
     */
    @RequestMapping(value = "/api/userLogin", method = RequestMethod.GET, consumes="application/json;", produces = "application/json; charset=utf8")
    public String userLoginSelect(@ModelAttribute("joinVO")JoinVO joinVO, HttpServletRequest request)  throws Exception {

        String message = "";

        try {

            BufferedReader  br 	        = new BufferedReader(new InputStreamReader(request.getInputStream(), StandardCharsets.UTF_8));
            String          paramValue  = parseJSONData(br);                                                            //JSON OBJECT TO STRING CALL.
            JSONParser      jsonParser  = new JSONParser();
            JSONObject      jsonObject  = (JSONObject)jsonParser.parse(paramValue);

            joinVO.setUserId(jsonObject.get("userId").toString());
            joinVO.setUserPassword(jsonObject.get("userPassword").toString());

            EgovMap result = joinService.userLoginSelect(joinVO);                                                       //로그인 CALL.

            if(!result.isEmpty()) {

                JSONObject json =  new JSONObject(result);                                                              //map을 json으로 변환.

                message = "{\"result\":\"success\",\"data\":" + json + "}";
            }
            else {

                message = "{\"result\":\"fail\",\"message\": \"no ID/PASSWORD.\"}";
            }
        }catch (Exception e){

            System.out.println("Exception: ");
            message = "{\"result\":\"fail\",\"message\": \"no ID/PASSWORD.\"}";
        }

        return message;
    }

    /**
     * 코드 목록 API
     * @param mainVO     PC 공통 관련 VO.
     * @return           RESPONSE MESSAGE.
     * @throws Exception
     */
    @RequestMapping(value = "/api/codeListSelect", method = RequestMethod.GET, consumes="application/json;", produces = "application/json; charset=utf8")
    public String codeListSelect(@ModelAttribute("mianVO") MainVO mainVO, HttpServletRequest request)  throws Exception {

        String message = "";

       try {

            BufferedReader  br 	        = new BufferedReader(new InputStreamReader(request.getInputStream(), StandardCharsets.UTF_8));
            String          paramValue  = parseJSONData(br);                                                            //JSON OBJECT TO STRING CALL.
            JSONParser      jsonParser  = new JSONParser();
            JSONObject      jsonObject  = (JSONObject)jsonParser.parse(paramValue);

            mainVO.setCodeGroup(jsonObject.get("codeGroup").toString());

            List<EgovMap> resultList = mainService.codeListSelect(mainVO);                                              //코드 목록 CALL.

            if(!resultList.isEmpty()) {

                JSONArray jsonArray = new JSONArray();

                for (int i = 0; i < resultList.size(); i++) {

                    JSONObject json =  new JSONObject(resultList.get(i));

                    jsonArray.put(json);
                }

                //JSONObject json =  new JSONObject(resultList);                                                        //map을 json으로 변환.

                message = "{\"result\":\"success\",\"data\":" + jsonArray + "}";
            }
            else {

                message = "{\"result\":\"fail\",\"message\": \"NO FIND SEARCH CODE.\"}";
            }
        }catch (Exception e){

           System.out.println("Exception: ");
           message = "{\"result\":\"fail\",\"message\": \"ERR FIND SEARCH CODE.\"}";
        }

        return message;
    }

    /**
     * JSON OBJECT TO STRING
     * @param 	bufferedReader
     * @return	string
     */
    public String parseJSONData(BufferedReader bufferedReader) {

        String resultSet = null;

        try {

            JSONParser jsonParser = new JSONParser();
            JSONObject jsonObject = (JSONObject)jsonParser.parse(bufferedReader);
            resultSet 			 = jsonObject.toJSONString();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return resultSet;
    }

}
