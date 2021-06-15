package iotBadSmellMonitoring.api.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.history.service.HistoryService;
import iotBadSmellMonitoring.history.service.RegisterService;
import iotBadSmellMonitoring.history.service.RegisterVO;
import iotBadSmellMonitoring.join.service.JoinService;
import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import iotBadSmellMonitoring.member.service.MemberService;
import org.json.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
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
    private RegisterService registerService;                                                                            //REGISTER MASTER / DETAIL SERVICE.
    @Autowired
    private JoinService     joinService;                                                                                //회원가입 / 로그인 / 아이디 찾기 관련 SERVICE.
    @Autowired
    private MainService     mainService;                                                                                //PC 공통 관련 SERVICE.
    @Autowired
    private HistoryService  historyService;                                                                             //HISTORY MASTER / DETAIL SERVICE.
    @Autowired
    private MemberService   memberService;                                                                              //회원관리 SERVICE.

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
            joinVO.setUserRegion(jsonObject.get("userRegion").toString());

            if(joinVO.getUserId().equals("") || joinVO.getUserPassword().equals("") || joinVO.getUserAge().equals("") || joinVO.getUserName().equals("") || joinVO.getUserSex().equals("")|| joinVO.getUserType().equals(""))
                message = "{\"result\":\"fail\",\"message\":\"NO DB INSERT.\"}";

            else {

                int result = joinService.userJoinInsert(joinVO);                                                        //회원가입 CALL.

                if(result == 1)
                    message = "{\"result\":\"success\"}";

                else
                    message = "{\"result\":\"fail\",\"message\":\"NO DB INSERT.\"}";
            }

        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\":\"ERR DB INSERT.\"}";
       }

        return message;
    }

    /**
     * 로그인 API
     * @param joinVO     회원가입 / 로그인 / 아이디 찾기 관련 VO.
     * @return           RESPONSE MESSAGE.
     * @throws Exception
     */
    @RequestMapping(value = "/api/userLogin", method = RequestMethod.POST, consumes="application/json;", produces = "application/json; charset=utf8")
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

            if(result != null && !result.isEmpty()) {                                                                   //null CHECK.

                JSONObject json =  new JSONObject(result);                                                              //map을 json으로 변환.
                json = (JSONObject) jsonParser.parse(String.valueOf(json).replace("null", "\"\""));   //null시 KEY 누락을 막기 위하여.

                message = "{\"result\":\"success\",\"data\":" + json + "}";
            }
            else
                message = "{\"result\":\"fail\",\"message\": \"NO ID/PASSWORD.\"}";

        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\": \"ERR ID/PASSWORD.\"}";
        }

        return message;
    }

    /**
     * USER ID CHECK API
     * @param joinVO     회원가입 / 로그인 / 아이디 찾기 관련 VO.
     * @return           RESPONSE MESSAGE.
     * @throws Exception
     */
    @RequestMapping(value = "/api/userFindId", method = RequestMethod.GET, consumes="application/json;", produces = "application/json; charset=utf8")
    public String userFindIdSelect(@ModelAttribute("joinVO")JoinVO joinVO, HttpServletRequest request)  throws Exception {

        String message = "";
        String userId  = "";
        String result  = "";

        try {

            userId = request.getParameter("userId");
            result = joinService.userFindIdSelect(userId);                                                              //USER ID CHECK CALL.

            if(userId.equals("null"))
                message = "{\"result\":\"fail\",\"message\":\"NO CEHCK USER ID.\"}";

            else if(result == null)                                                                                     //null CHECK.
                message = "{\"result\":\"fail\",\"message\":\"NO CEHCK USER ID.\"}";

            else
                message = "{\"result\":\"success\"}";

        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\": \"ERR USER ID CHECK.\"}";
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

            JSONParser      jsonParser  = new JSONParser();

            mainVO.setCodeGroup(request.getParameter("codeGroup"));

            List<EgovMap> resultList = mainService.codeListSelect(mainVO);                                              //코드 목록 CALL.

            if(resultList != null && !resultList.isEmpty()) {                                                           //null CHECK.

                JSONArray jsonArray = new JSONArray();

                for (EgovMap egovMap : resultList) {

                    JSONObject json = new JSONObject(egovMap);
                    json = (JSONObject) jsonParser.parse(String.valueOf(json).replace("null", "\"\""));//null시 KEY 누락을 막기 위하여.
                    jsonArray.put(json);
                }

                message = "{\"result\":\"success\",\"data\":" + jsonArray + "}";
            }
            else
                message = "{\"result\":\"fail\",\"message\":\"NO FIND SEARCH CODE.\"}";

        }catch (Exception e){

           //System.out.println("Exception: "+e);
           message = "{\"result\":\"fail\",\"message\":\"ERR FIND SEARCH CODE.\"}";
        }

        return message;
    }

    /**
     * 접수 마스터||디테일 등록 API
     * @param registerVO     REGISTER MASTER / DETAIL VO.
     * @return               RESPONSE MESSAGE.
     * @throws Exception
     */
    @RequestMapping(value = "/api/registerInsert", method = RequestMethod.POST, consumes="application/json;", produces = "application/json; charset=utf8")
    public String registerInsert(@ModelAttribute("registerVO")RegisterVO registerVO, HttpServletRequest request)  throws Exception {

        String message = "";

        try {

            BufferedReader  br 	        = new BufferedReader(new InputStreamReader(request.getInputStream(), StandardCharsets.UTF_8));
            String          paramValue  = parseJSONData(br);                                                            //JSON OBJECT TO STRING CALL.
            JSONParser      jsonParser  = new JSONParser();
            JSONObject      jsonObject  = (JSONObject)jsonParser.parse(paramValue);

            registerVO.setSmellType(jsonObject.get("smellType").toString());
            registerVO.setSmellValue(jsonObject.get("smellValue").toString());
            registerVO.setWeaterState(jsonObject.get("weaterState").toString());
            registerVO.setTemperatureValue(jsonObject.get("temperatureValue").toString());
            registerVO.setHumidityValue(jsonObject.get("humidityValue").toString());
            registerVO.setWindDirectionValue(jsonObject.get("windDirectionValue").toString());
            registerVO.setWindSpeedValue(jsonObject.get("windSpeedValue").toString());
            registerVO.setGpsX(jsonObject.get("gpsX").toString());
            registerVO.setGpsY(jsonObject.get("gpsY").toString());
            registerVO.setSmellComment(jsonObject.get("smellComment").toString());
            registerVO.setSmellRegisterTime(jsonObject.get("smellRegisterTime").toString());
            registerVO.setRegId(jsonObject.get("regId").toString());

            int result = registerService.registerInsert(registerVO);                                                    //접수 마스터||디테일 등록 CALL.

            if(result == 1)
                message = "{\"result\":\"success\"}";

            else
                message = "{\"result\":\"fail\",\"message\":\"NO DB INSERT.\"}";

        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\":\"ERR DB INSERT.\"}";
        }

        return message;
    }

    /**
     * USER INFO API
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/api/userInfo", method = RequestMethod.GET, consumes="application/json;", produces = "application/json; charset=utf8")
    public String userInfo(HttpServletRequest request)  throws Exception {

        String message = "";

        try {

            EgovMap userInfo = memberService.memberGetInfoSelect(request.getParameter("userId"));                    //USER_ID / USER_NAME GET CALL.

            if(userInfo != null && !userInfo.isEmpty()){

                JSONObject  json        = new JSONObject(userInfo);                                                     //map을 json으로 변환.
                JSONParser  jsonParser  = new JSONParser();

                json    = (JSONObject) jsonParser.parse(String.valueOf(json).replace("null", "\"\"")); //null시 KEY 누락을 막기 위하여.
                message = "{\"result\":\"success\",\"data\":" + json + "}";

            }else
                message = "{\"result\":\"fail\",\"message\":\"NO SEARCH USER INFO.\"}";

       }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\":\"ERR SEARCH USER INFO.\"}";
       }

        return message;
    }

    /**
     * USER TODAY REGISTER INFO API
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/api/userTodayRegisterInfo", method = RequestMethod.GET, consumes="application/json;", produces = "application/json; charset=utf8")
    public String userTodayRegisterInfo(HttpServletRequest request)  throws Exception {

        String        message    = "";
        String        userId     = request.getParameter("userId");

       try {

            if(userId.equals(""))
                message = "{\"result\":\"fail\",\"message\":\"NO SEARCH USER REGISTER INFO.\"}";

            else{

                EgovMap         egovMap     = historyService.todayHistoryListSelect(userId);                                //TODAY HISTORY 목록 CALL.
                EgovMap         resultMap   = new EgovMap();
                JSONParser      jsonParser  = new JSONParser();
                List<EgovMap>   resultList  = new ArrayList<>();

                /*USER TODAY REGISTER DATA MAKE START*/
                resultMap.put("smellRegisterTime","001");
                resultMap.put("smellRegisterTimeName","08:00 ~ 10:00");
                resultMap.put("resultCode",egovMap.getValue(0).toString());
                if(egovMap.getValue(1) != null)
                    resultMap.put("regDt",egovMap.getValue(1).toString());

                else
                    resultMap.put("regDt",null);

                resultList.add(resultMap);

                resultMap = new EgovMap();

                resultMap.put("smellRegisterTime","002");
                resultMap.put("smellRegisterTimeName","12:00 ~ 14:00");
                resultMap.put("resultCode",egovMap.getValue(2).toString());
                if(egovMap.getValue(3) != null)
                    resultMap.put("regDt",egovMap.getValue(3).toString());

                else
                    resultMap.put("regDt",null);

                resultList.add(resultMap);

                resultMap = new EgovMap();

                resultMap.put("smellRegisterTime","003");
                resultMap.put("smellRegisterTimeName","18:00 ~ 20:00");
                resultMap.put("resultCode",egovMap.getValue(4).toString());

                if(egovMap.getValue(5) != null)
                    resultMap.put("regDt",egovMap.getValue(5).toString());

                else
                    resultMap.put("regDt",null);

                resultList.add(resultMap);

                resultMap = new EgovMap();

                resultMap.put("smellRegisterTime","004");
                resultMap.put("smellRegisterTimeName","22:00 ~ 00:00");
                resultMap.put("resultCode",egovMap.getValue(6).toString());

                if(egovMap.getValue(7) != null)
                    resultMap.put("regDt",egovMap.getValue(7).toString());

                else
                    resultMap.put("regDt",null);

                resultList.add(resultMap);

                JSONArray jsonArray = new JSONArray();

                for (EgovMap egovMap2 : resultList) {

                    JSONObject json = new JSONObject(egovMap2);
                    json = (JSONObject) jsonParser.parse(String.valueOf(json).replace("null", "\"\""));//null시 KEY 누락을 막기 위하여.
                    jsonArray.put(json);
                }
                /*USER TODAY REGISTER DATA MAKE END*/

                message = "{\"result\":\"success\",\"data\":" + jsonArray + "}";
            }

        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\":\"ERR SEARCH USER REGISTER INFO.\"}";
        }

        return message;
    }

    /**
     * USER PASSWORD CHANGE.
     * @param joinVO         회원가입 / 로그인 / 아이디 찾기 관련 VO
     * @return               RESPONSE MESSAGE.
     * @throws Exception
     */
    @RequestMapping(value = "/api/userPasswordChange", method = RequestMethod.POST, consumes="application/json;", produces = "application/json; charset=utf8")
    public String userPasswordChange(JoinVO joinVO, HttpServletRequest request)  throws Exception {

        String message = "";

        try {

            BufferedReader  br 	        = new BufferedReader(new InputStreamReader(request.getInputStream(), StandardCharsets.UTF_8));
            String          paramValue  = parseJSONData(br);                                                            //JSON OBJECT TO STRING CALL.
            JSONParser      jsonParser  = new JSONParser();
            JSONObject      jsonObject  = (JSONObject)jsonParser.parse(paramValue);

            joinVO.setUserId(jsonObject.get("userId").toString());
            joinVO.setUserPassword(jsonObject.get("userPassword").toString());

            int result = memberService.memberPasswordUpdate(joinVO);

            if(result == 1)
                message = "{\"result\":\"success\"}";

            else
                message = "{\"result\":\"fail\",\"message\":\"NO PASSWORD CHANGE.\"}";

        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\":\"ERR PASSWORD CHANGE.\"}";
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
            resultSet 			  = jsonObject.toJSONString();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return resultSet;
    }

}
