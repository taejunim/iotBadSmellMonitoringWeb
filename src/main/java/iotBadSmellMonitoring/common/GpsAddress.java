package iotBadSmellMonitoring.common;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RestController;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

public class GpsAddress {

    //@Value("${${environment}.kakaoLocationKey}")

    private String        kakaoLocationKey  = UtProperty.getProperty(""+UtProperty.getProperty("environment")+".kakaoLocationKey");
    private static String GEOCODE_URL       = "https://dapi.kakao.com/v2/local/geo/coord2address.json?";

    public String getAddressCheck(String gpsX, String gpsY) {

        URL     obj     = null;
        String  result  = "";

        try {

            System.out.println("KEY2: "+kakaoLocationKey);
            String x = "126.316408";
            String y = "33.352024";

            String coordinatesystem = "WGS84";
            obj                     = new URL(GEOCODE_URL + "x=" + x + "&y=" + y + "&input_coord=" + coordinatesystem);
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
            JSONArray      jsonArray   = new JSONArray();

            System.out.println("주소 변환: "+getAddress);
            jsonObject                 = (JSONObject)jsonParser.parse(getAddress);

            if(!getAddress.equals("")){

                jsonArray = (JSONArray) jsonObject.get("documents");
                jsonObject = (JSONObject) jsonArray.get(0);
                jsonObject = (JSONObject) jsonObject.get("address");

            }

        } catch (Exception e) { // TODO Auto-generated catch block e.printStackTrace();

            e.printStackTrace();
        }

        return "true";
    }
}
