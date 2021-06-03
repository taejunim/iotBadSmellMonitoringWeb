package iotBadSmellMonitoring.api.web;

import iotBadSmellMonitoring.join.service.JoinService;
import iotBadSmellMonitoring.join.service.JoinVO;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

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

@RestController
public class ApiController {

    @Autowired
    private JoinService joinService;

    /**
     * 회원가입 API
     * @param joinVO     회원가입 / 아이디 찾기 관련 VO.
     * @return           RESPONSE MESSAGE.
     * @throws Exception
     */
    @RequestMapping(value = "/api/userJoinInsert", method = RequestMethod.POST, consumes="application/json;", produces = "application/json;")
    public @ResponseBody String userJoinInsert(@ModelAttribute("joinVO")JoinVO joinVO, HttpServletRequest request)  throws Exception {

        String message = "";

        try {

            BufferedReader  br 	        = new BufferedReader(new InputStreamReader(request.getInputStream(), StandardCharsets.UTF_8));
            String          postValue   = parseJSONData(br);                                                            //JSON OBJECT TO STRING CALL.
            JSONParser      jsonParser  = new JSONParser();
            JSONObject      jsonObject  = (JSONObject)jsonParser.parse(postValue);

            joinVO.setUserId(jsonObject.get("userId").toString());
            joinVO.setUserPassword(jsonObject.get("userPassword").toString());
            joinVO.setUserAge(jsonObject.get("userAge").toString());
            joinVO.setUserName(jsonObject.get("userName").toString());
            joinVO.setUserSex(jsonObject.get("userSex").toString());
            joinVO.setUserType(jsonObject.get("userType").toString());

            int result = joinService.userJoinInsert(joinVO);                                                            //회원가입 CALL.

            if(result == 1)
                message = "{result:\"success\"}";

            else
                message = "{result:\"fail\",message: no Insert.}";

        }catch (Exception e){

            message = "{result:\"fail\",message:"+e.getMessage()+"}";
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
