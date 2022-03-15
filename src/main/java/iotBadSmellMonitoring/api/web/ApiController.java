package iotBadSmellMonitoring.api.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.common.CommonFunction;
import iotBadSmellMonitoring.history.service.HistoryService;
import iotBadSmellMonitoring.history.service.HistoryVO;
import iotBadSmellMonitoring.history.service.RegisterService;
import iotBadSmellMonitoring.history.service.RegisterVO;
import iotBadSmellMonitoring.join.service.JoinService;
import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import iotBadSmellMonitoring.member.service.MemberService;
import iotBadSmellMonitoring.notice.service.NoticeService;
import iotBadSmellMonitoring.notice.service.NoticeVO;
import iotBadSmellMonitoring.statistic.service.StatisticService;
import iotBadSmellMonitoring.statistic.service.StatisticTableVO;
import org.json.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartResolver;

import javax.servlet.MultipartConfigElement;
import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static iotBadSmellMonitoring.common.Constants.dateFormatter;

/**
 * @ Class Name   : ApiController.java
 * @ Notification : API SERVICE COTROLLER
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
    private RegisterService     registerService;                                                                        //REGISTER MASTER / DETAIL SERVICE.
    @Autowired
    private JoinService         joinService;                                                                            //회원가입 / 로그인 / 아이디 찾기 관련 SERVICE.
    @Autowired
    private MainService         mainService;                                                                            //PC 공통 관련 SERVICE.
    @Autowired
    private HistoryService      historyService;                                                                         //HISTORY MASTER / DETAIL SERVICE.
    @Autowired
    private MemberService       memberService;                                                                          //회원관리 SERVICE.
    @Autowired
    private NoticeService       noticeService;                                                                          //공지사항 SERVICE.
    @Autowired
    private StatisticService    statisticService;                                                                       //통계 SERVICE.

    @Value("${${environment}.kakaoLocationKey}")
    private String          kakaoLocationKey;
    private static String   GEOCODE_URL       = "https://dapi.kakao.com/v2/local/geo/coord2address.json?";

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
            joinVO.setUserRegionMaster(jsonObject.get("userRegionMaster").toString());
            joinVO.setUserRegionDetail(jsonObject.get("userRegionDetail").toString());
            joinVO.setUserPhone(jsonObject.get("userPhone").toString());

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

    @Bean
    public MultipartConfigElement multipartConfigElement() {
        return new MultipartConfigElement("");
    }

    @Bean
    public MultipartResolver multipartResolver() {
        org.springframework.web.multipart.commons.CommonsMultipartResolver multipartResolver = new org.springframework.web.multipart.commons.CommonsMultipartResolver();
        multipartResolver.setMaxUploadSize(4000000);
        return multipartResolver;
    }

    /**
     * 접수 마스터||디테일 등록 API
     * @param registerVO     REGISTER MASTER / DETAIL VO.
     * @return               RESPONSE MESSAGE.
     * @throws Exception
     */
    @RequestMapping(value = "/api/registerInsert", method = RequestMethod.POST, produces = "application/json; charset=utf8")
    public @ResponseBody String registerInsert(@ModelAttribute("registerVO")RegisterVO registerVO)  throws Exception {

        String strTime     = new java.text.SimpleDateFormat("HHmm").format(new java.util.Date());
        int    intTime     = Integer.parseInt(strTime);
        String message     = "";

        if(!getAddressCheck(registerVO.getGpsX(),registerVO.getGpsY(),registerVO.getRegId())){

            message = "{\"result\":\"fail\",\"message\":\"NO REGIST REGION.\"}";
            return message;
        }

        else if(559 < intTime && 900 > intTime){

            message = registMakeMsg(registerVO);
            return message;
        }

        else if(1059 < intTime && 1700 > intTime) {
            message = registMakeMsg(registerVO);
            return message;
        }
        else if(1859 < intTime && 2300 > intTime) {
            message = registMakeMsg(registerVO);
            return message;
        }
        else {
            message = "{\"result\":\"fail\",\"message\":\"NO REGIST TIME.\"}";
            return message;
        }
    }

    /**
     * 접수 시간대 체크
     * @param registerVO    접수 시간대
     * @return              접수 시간대 체크 결과
     */
    public String registMakeMsg(RegisterVO registerVO){

        String message = "";

        if(registerVO.getImg1() != null) {
            //System.out.println("img1: " + registerVO.getImg1().getOriginalFilename());

            registerVO.getFileList().add(registerVO.getImg1());
        }
        if(registerVO.getImg2() != null && !registerVO.getImg2().isEmpty()) {
            //System.out.println("img2: " + registerVO.getImg2().getOriginalFilename());

            registerVO.getFileList().add(registerVO.getImg2());
        }
        if(registerVO.getImg3() != null && !registerVO.getImg3().isEmpty()) {
            //System.out.println("img3: " + registerVO.getImg3().getOriginalFilename());

            registerVO.getFileList().add(registerVO.getImg3());
        }
        if(registerVO.getImg4() != null && !registerVO.getImg4().isEmpty()) {
            //System.out.println("img4: " + registerVO.getImg4().getOriginalFilename());

            registerVO.getFileList().add(registerVO.getImg4());
        }
        if(registerVO.getImg5() != null && !registerVO.getImg5().isEmpty()) {
            //System.out.println("img5: " + registerVO.getImg5().getOriginalFilename());

            registerVO.getFileList().add(registerVO.getImg5());
        }

        try {

            int result = registerService.registerInsert(registerVO);                                                  //접수 마스터||디테일 등록 CALL.

            if(result == 1)
                message = "{\"result\":\"success\"}";

            else
                message = "{\"result\":\"fail\",\"message\":\"NO DB INSERT / FILE UPLOAD.\"}";

        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\":\"ERR DB INSERT / FILE UPLOAD.\"}";
        }

        return message;
    }

    /**
     * 지역 체크
     * @param gpsX      X 좌표
     * @param gpsY      Y 좌표
     * @return          지역 체크 결과
     */
    public boolean getAddressCheck(String gpsX, String gpsY, String uerId) {

        URL      obj         = null;
        boolean  result      = false;

        try {

            String coordinatesystem = "WGS84";
            obj                     = new URL(GEOCODE_URL + "x=" + gpsX + "&y=" + gpsY + "&input_coord=" + coordinatesystem);
            HttpURLConnection con   = (HttpURLConnection) obj.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("Authorization", kakaoLocationKey);
            con.setRequestProperty("content-type", "application/json");
            con.setDoOutput(true);
            con.setUseCaches(false);

            Charset        charset   = StandardCharsets.UTF_8;
            BufferedReader in        = new BufferedReader(new InputStreamReader(con.getInputStream(), charset));
            StringBuilder  response  = new StringBuilder();
            String         inputLine = null;

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }

            String         getAddress  = "";
            getAddress                 = response.toString();
            JSONObject     jsonObject  = new JSONObject();
            JSONParser     jsonParser  = new JSONParser();
            org.json.simple.JSONArray jsonArray   = new org.json.simple.JSONArray();

            System.out.println("주소 변환: "+getAddress);
            jsonObject                 = (JSONObject)jsonParser.parse(getAddress);

            jsonArray = (org.json.simple.JSONArray) jsonObject.get("documents");
            jsonObject = (JSONObject) jsonArray.get(0);
            jsonObject = (JSONObject) jsonObject.get("address");

            String  regRegion    = jsonObject.get("region_3depth_name").toString();
            EgovMap regRegionMap = memberService.memberGetInfoSelect(uerId);
            String  dbRegion     = regRegionMap.get("userRegionDetailName").toString();

            if(regRegion.matches("(.*)"+dbRegion+"(.*)"))
                result = true;

        } catch (Exception e) { // TODO Auto-generated catch block e.printStackTrace();

            e.printStackTrace();
        }

        return result;
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
                resultMap.put("smellRegisterTimeName","07:00 ~ 09:00");
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
     * USER REGISTER MASTER HISTORY API
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/api/registerMasterHistory", method = RequestMethod.GET, consumes="application/json;", produces = "application/json; charset=utf8")
    public String registerMasterHistory(HttpServletRequest request, HistoryVO historyVO)  throws Exception {

        String message = "";

        try {

            JSONParser      jsonParser  = new JSONParser();

            historyVO.setFirstIndex(Integer.parseInt(request.getParameter("firstIndex")));
            historyVO.setRecordCountPerPage(Integer.parseInt(request.getParameter("recordCountPerPage")));

            List<EgovMap> resultList = historyService.historyListSelect(historyVO);                                     //HISTORY 목록 CALL.

            if(resultList != null && !resultList.isEmpty() && !historyVO.getRegId().equals("")) {                       //null CHECK.

                JSONArray jsonArray = new JSONArray();

                for (EgovMap egovMap : resultList) {

                    JSONObject json = new JSONObject(egovMap);
                    json = (JSONObject) jsonParser.parse(String.valueOf(json).replace("null", "\"\""));//null시 KEY 누락을 막기 위하여.
                    jsonArray.put(json);
                }

                message = "{\"result\":\"success\",\"data\":" + jsonArray + "}";
            }
            else
                message = "{\"result\":\"fail\",\"message\":\"NO SEARCH MASTER HISTORY DATA.\"}";


        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\":\"ERR SEARCH MASTER HISTORY DATA.\"}";
        }

        return message;
    }

    /**
     * USER REGISTER DETAIL HISTORY API
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/api/registerDetailHistory", method = RequestMethod.GET, consumes="application/json;", produces = "application/json; charset=utf8")
    public String registerDetailHistory(HttpServletRequest request, HistoryVO historyVO)  throws Exception {

        String message = "";

        try {

            JSONParser      jsonParser  = new JSONParser();

            historyVO.setSmellRegisterNo(request.getParameter("smellRegisterNo"));

            List<EgovMap> resultList = historyService.historyImgListSelect(historyVO);                                  //HISTORY IMG 목록 CALL.

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
                message = "{\"result\":\"fail\",\"message\":\"NO SEARCH DETAIL HISTORY DATA.\"}";


        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\":\"ERR SEARCH DETAIL HISTORY DATA.\"}";
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
     * CURRENT DATE API
     * @return           RESPONSE MESSAGE.
     * @throws Exception
     */
    @RequestMapping(value = "/api/currentDate", method = RequestMethod.GET, consumes="application/json;", produces = "application/json; charset=utf8")
    public String currentDate()  throws Exception {

        String message     = "";
        String currentDate = "";

        try {

            Date date   = new Date();
            currentDate = dateFormatter.format(date);
            message = "{\"result\":\"success\",\"data\":\""+currentDate+"\"}";

        } catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\": \"GET DATE TIME ERR.\"}";
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

    /**
     * REGION LIST API
     * @param mainVO
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/api/getRegionList", method = RequestMethod.GET, consumes="application/json;", produces = "application/json; charset=utf8")
    public String getRegionList(MainVO mainVO)  throws Exception {

        String message = "";

        JSONParser      jsonParser  = new JSONParser();
        mainVO.setCodeGroup("REM");

        try {

            List<EgovMap> resulMtList = mainService.codeListSelect(mainVO);                                                  //코드 목록 CALL.

            if(resulMtList != null && !resulMtList.isEmpty()) {                                                               //null CHECK.

                JSONArray     jsonArray        = new JSONArray();
                List<EgovMap> regionMList      = new ArrayList<>();

                int i = 0;

                for (EgovMap egovMap : resulMtList) {

                    EgovMap mapM = new EgovMap();

                    System.out.println("resultList.get(2).getValue(i).toString(): "+resulMtList.get(i).getValue(3).toString());
                    mapM.put("M_CODE_ID",resulMtList.get(i).getValue(2).toString());
                    mapM.put("M_CODE_ID_NAME",resulMtList.get(i).getValue(3).toString());

                    mainVO.setCodeGroup("RGD");
                    mainVO.setReferenceCodeGroup("REM");
                    mainVO.setReferenceCodeId(resulMtList.get(i).getValue(2).toString());

                    List<EgovMap> resultDList = mainService.codeListSelect(mainVO);                                         //코드 목록 CALL.
                    List<EgovMap> regionDList = new ArrayList<>();

                    int j = 0;

                    for(EgovMap dEgovMap : resultDList){

                        EgovMap mapD = new EgovMap();

                        mapD.put("D_CODE_ID",resultDList.get(j).getValue(2).toString());
                        mapD.put("D_CODE_ID_NAME",resultDList.get(j).getValue(3).toString());

                        regionDList.add(mapD);

                        mapM.put("DETAIL",regionDList);

                        j++;
                    }

                    regionMList.add(mapM);

                    i++;
                }

                for (EgovMap egovMap : regionMList) {

                    JSONObject json = new JSONObject(egovMap);
                    json = (JSONObject) jsonParser.parse(String.valueOf(json).replace("null", "\"\""));//null시 KEY 누락을 막기 위하여.
                    jsonArray.put(json);
                }

                //message = "{\"result\":\"success\",\"data\":" + jsonArray + "}";
                message = "{\"result\":\"success\",\"data\":{\"region\":{\"master\":"+ jsonArray +"}}}";

            }
            else
                message = "{\"result\":\"fail\",\"message\":\"NO SEARCH DETAIL HISTORY DATA.\"}";

        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\":\"ERR SEARCH DETAIL HISTORY DATA.\"}";
        }

        return message;
    }

    /**
     * USER WEATHER GET API.
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/api/userWeather", method = RequestMethod.GET, consumes="application/json;", produces = "application/json; charset=utf8")
    public String userWeather(HttpServletRequest request)  throws Exception {

        String message = "";

        try {

            EgovMap egovMap = mainService.getUserWeather(request.getParameter("userRegion"));                        //모바일 기상청 데이터를 위한 X,Y CALL.

            if(egovMap != null && !egovMap.isEmpty()){

                JSONObject  json        = new JSONObject(egovMap);                                                      //map을 json으로 변환.
                JSONParser  jsonParser  = new JSONParser();

                json    = (JSONObject) jsonParser.parse(String.valueOf(json).replace("null", "\"\"")); //null시 KEY 누락을 막기 위하여.
                message = "{\"result\":\"success\",\"data\":" + json + "}";

            }else
                message = "{\"result\":\"fail\",\"message\":\"NO SEARCH USER WEATHER.\"}";

        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\":\"ERR SEARCH USER WEATHER.\"}";
        }

        return message;
    }

    /**
     * NOTICE INFO API.
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/api/noticeInfo", method = RequestMethod.GET, consumes="application/json;", produces = "application/json; charset=utf8")
    public String noticeInfo(HttpServletRequest request, NoticeVO noticeVO)  throws Exception {

        String message = "";
        noticeVO.setDeviceGbn("mobile");                                                                                //모바일 default

        try {

            List<EgovMap> resultList = noticeService.noticeListSelect(noticeVO);                                        //공지사항 목록 CALL.

            if(resultList != null && !resultList.isEmpty()){

                EgovMap egovMap = new EgovMap();

                egovMap.put("NOTICE_TITLE",resultList.get(0).getValue(1));
                egovMap.put("NOTICE_CONTENTS",resultList.get(0).getValue(2));

                JSONObject  json        = new JSONObject(egovMap);                                                      //map을 json으로 변환.
                JSONParser  jsonParser  = new JSONParser();

                json    = (JSONObject) jsonParser.parse(String.valueOf(json).replace("null", "\"\"")); //null시 KEY 누락을 막기 위하여.
                message = "{\"result\":\"success\",\"data\":" + json + "}";
            }
            else
                message = "{\"result\":\"fail\",\"message\":\"NO SEARCH NOTICE.\"}";

        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\":\"ERR SEARCH NOTICE.\"}";
        }

        return message;
    }

    /**
     * MY TOWN SMELL INFO API.
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/api/myTownSmellInfo", method = RequestMethod.GET, consumes="application/json;", produces = "application/json; charset=utf8")
    public String myTownSmellInfo(HttpServletRequest request, StatisticTableVO statisticTableVO)  throws Exception {

        CommonFunction cf = new CommonFunction();

        statisticTableVO.setSearchStart(cf.getRealDate("yyyy")+"-"+cf.getRealDate("mm"));                     //시작 월
        statisticTableVO.setSearchEnd(cf.getRealDate("yyyy")+"-"+cf.getRealDate("mm"));                       //끝  월
        statisticTableVO.setUserRegionMaster(request.getParameter("regionMaster"));                                  //지역  코드
        statisticTableVO.setUserRegionDetail(request.getParameter("regionDetail"));                                  //지역 상세 코드

        String message = "";

        try {

            EgovMap egovMap = statisticService.statisticTableRegionSelect(statisticTableVO);                            //통계 표 지역별 (단건, API용) CALL.

            if(egovMap != null && !egovMap.isEmpty()){

                JSONObject  json        = new JSONObject(egovMap);                                                      //map을 json으로 변환.
                JSONParser  jsonParser  = new JSONParser();

                json    = (JSONObject) jsonParser.parse(String.valueOf(json).replace("null", "\"\"")); //null시 KEY 누락을 막기 위하여.
                message = "{\"result\":\"success\",\"data\":" + json + "}";
            }
            else
                message = "{\"result\":\"fail\",\"message\":\"NO SEARCH NOTICE.\"}";

        }catch (Exception e){

            //System.out.println("Exception: "+e);
            message = "{\"result\":\"fail\",\"message\":\"ERR SEARCH NOTICE.\"}";
        }

        return message;
    }

}
