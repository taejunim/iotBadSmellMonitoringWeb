package iotBadSmellMonitoring.history.service.impl;

import iotBadSmellMonitoring.history.service.RegisterService;
import iotBadSmellMonitoring.history.service.RegisterVO;
import org.apache.ibatis.session.SqlSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Base64;

/**
 * @ Class Name   : RegisterServiceImpl.java
 * @ Modification : REGISTER MASTER / DETAIL SERVICE IMPL
 * @
 * @ 최초 생성일     최초 생성자
 * @ ————    ————
 * @ 2021.06.04.    고재훈
 * @
 * @   수정일         수정자
 * @ ————    ————
 * @
 **/

@Service
public class RegisterServiceImpl implements RegisterService {

    @Autowired
    SqlSession sqlSession;

    @Value("${server.ip}")
    private String serverIp;

    @Value("${server.path}")
    private String serverPath;

    @Value("${ktApiLink.host}")
    private String ktApiLinkHost;

    @Value("${ktApiLink.id}")
    private String ktApiLinkId;

    @Value("${ktApiLink.password}")
    private String ktApiLinkPassword;

    @Value("${ktApiLink.period}")
    private String period;

    @Value("${ktApiLink.airSensorCode}")
    private String ktApiLinkAirSensorCode;

    /**
     * 접수 마스터||디테일 등록
     * @param registerVO REGISTER MASTER / DETAIL VO.
     * @return           int
     * @throws Exception
     */
    public int registerInsert(RegisterVO registerVO) throws Exception {

        RegisterMapper registerMapper = sqlSession.getMapper(RegisterMapper.class);

        registerVO.setSmellRegisterNo(registerMapper.registerSmellRegisterNoSelect());                                  //접수 마스터 번호 CALL.

        /** 앱에서 smellType 없으면
         * smellValue(악취 강도) - 001(무취) 이면 smellType(악취 타입) - 008(취기 없음)
         * 그 외 강도는 002(기타 냄새) 로 바꿔서 업데이트
         */
        if (registerVO.getSmellType().trim().equals("") || registerVO.getSmellType() == null) {

            if (registerVO.getSmellValue().equals("001")) {
                registerVO.setSmellType("008");
            } else {
                registerVO.setSmellType("002");
            }
        }

        getFineDustInformation(registerVO);

        int masterResult = registerMapper.registerMasterInsert(registerVO);                                             //접수 마스터 등록 CALL.
        int allResult    = 0;                                                                                           //마스터||디테일 등록 결과

        if(masterResult == 1){

            allResult = 1;

            if(registerVO.getFileList().size() != 0) {                                                                  //접수 디테일이 있으면,

                File Folder = new File(serverPath+registerVO.getSmellRegisterNo());

                // 해당 디렉토리가 없을경우 디렉토리를 생성합니다.
                if (!Folder.exists()) {

                    Folder.mkdir();     //폴더 생성합니다.
                }

                for(int i = 0; i < registerVO.getFileList().size(); i++){

                    /*API에서 전송되는 MULTIPART FILE을 FILE / NAME / DIR 등의 관리를 위한 로직 START*/
                    File oFile = new File(registerVO.getFileList().get(i).getOriginalFilename());                       //MULTIPART FILE을 FILE로 변경.
                    FileOutputStream fos = new FileOutputStream( oFile );
                    fos.write( registerVO.getFileList().get(i).getBytes() );
                    fos.close();

                    String oFileName = oFile.getName();                                                                 //ORIGINAL FILE NAME.
                    String extension = oFileName.substring(oFileName.lastIndexOf(".") + 1);                         //NEW FILE NAME을 위한 확장자 분리.
                    String fileSeq   = String.valueOf(i+1);                                                             //FILE 관리를 위한 시퀀스.

                    registerVO.setSmellImagePath("http://"+serverIp+":8080/iotBadSmellMonitoringWebImg/"+registerVO.getSmellRegisterNo()+"/"+registerVO.getSmellRegisterNo()+"_"+fileSeq+"."+extension);
                    /*API에서 전송되는 MULTIPART FILE을 FILE / NAME / DIR 등의 관리를 위한 로직 END*/

                    registerVO.setSmellOriginalPath(serverPath+registerVO.getSmellRegisterNo()+"/"+registerVO.getSmellRegisterNo()+"_"+fileSeq+"."+extension);
                    int detailResult = registerMapper.registerDetailInsert(registerVO);                                 //접수 디테일 등록 CALL.

                    if(detailResult == 0) {                                                                             //접수 마스터&&디테일 결과,
                        allResult = 0;
                        break;

                    }else{

                        File nFile = new File(serverPath+registerVO.getSmellRegisterNo()+"/"+registerVO.getSmellRegisterNo()+"_"+fileSeq+"."+extension);
                        oFile.renameTo(nFile);
                    }
                }
            }
        }

        return allResult;
    }

    /**
     * KT API 를 활용하여 미세먼지 데이터 SET
     * @param            registerVO
     * @return           registerVO
     * @throws Exception
     */
    public RegisterVO getFineDustInformation(RegisterVO registerVO) throws Exception {

        HttpURLConnection conn = null;

        try {
            //URL 설정
            URL url = new URL(ktApiLinkHost + "?ccomTypeCode=0003&period=" + period +"&airSensorCode=" + ktApiLinkAirSensorCode);

            String encryptAuthorizationKey = getEncryptAuthorizationKey();

            conn = (HttpURLConnection) url.openConnection();
            //Request 형식 설정
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", encryptAuthorizationKey);
            conn.setRequestProperty("Content-Type", "application/json");

            //request에 JSON data 준비
            conn.setDoOutput(true);

            //보내고 결과값 받기
            int responseCode = conn.getResponseCode();

            // 통신 성공 후 응답 JSON 데이터받기
            if (responseCode == 200 ) {
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder sb = new StringBuilder();
                String line = "";
                while ((line = br.readLine()) != null) {
                    sb.append(line);
                }

                JSONParser parser = new JSONParser();
                Object obj = parser.parse(sb.toString());
                JSONObject jsonObj = (JSONObject) obj;
                System.out.println("KT API LINK DATA ==> ");
                System.out.println(jsonObj);
                if(!jsonObj.get("returncode").equals("1")) System.out.println("KT API Error >> " + jsonObj.get("errordescription"));

                if(jsonObj.get("data") != null ) {
                    JSONArray jsonObject2 = (JSONArray) jsonObj.get("data");
                    //kt api 응답 결과 Result
                    JSONObject ktApiResult = (JSONObject) jsonObject2.get(0);
                    if(ktApiResult.get("airSensorName") != null)                                            //측정소명
                        registerVO.setAirSensorName(ktApiResult.get("airSensorName").toString());
                    if(ktApiResult.get("pm10Avg") != null)                                                  //pm10 미세먼지 농도
                        registerVO.setPm10Avg(Double.parseDouble(ktApiResult.get("pm10Avg").toString()));
                    if(ktApiResult.get("airSensingDate") != null)                                           //미세먼지 측정 일자
                        registerVO.setAirSensingDate(ktApiResult.get("airSensingDate").toString());
                }
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return registerVO;
    }

    /**
     * KT API 호출시 인증 정보 암호화 (ID/PW)
     * @param
     * @return
     * @throws Exception
     */
    String getEncryptAuthorizationKey(){

        String authorization = ktApiLinkId + ":" + ktApiLinkPassword;
        String encryptAuthorizationKey = "";

        byte[] targetBytes = authorization.getBytes();
        Base64.Encoder encoder = Base64.getEncoder();
        byte[] encodedBytes = encoder.encode(targetBytes);

        encryptAuthorizationKey = "Basic " + new String(encodedBytes);

        return encryptAuthorizationKey;

    }
}
