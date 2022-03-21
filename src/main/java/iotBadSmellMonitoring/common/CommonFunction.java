package iotBadSmellMonitoring.common;

import java.util.Random;

/**
 * @ Class Name   : CommonFunction.java
 * @ Notification : PMS WEB COMMON FUNCTION CLASS
 * @
 * @ 최초 생성일      최초 생성자
 * @ ---------    ---------
 * @ 2021.10.08.    고재훈
 * @
 * @  수정일          수정자
 * @ ---------    ---------
 * @
 **/
public class CommonFunction {

    /**
     * 현재 날짜 관련 공통 함수.
     * 원하는 CASE 없을 시, 추가 하기.
     * @param gbn : yyyy
     *            : mm
     *            : dd
     *            : hh
     *            : mi
     *            : ss
     *            : sss
     * @return    yyyy
     *            mm
     *            dd
     *            hh
     *            mi
     *            ss
     *            sss
     *            no date/time format. format add plz. 시, format 추가하기.
     */
    public String getRealDate(String gbn){

        String date     = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
        String time     = new java.text.SimpleDateFormat("HHmmss").format(new java.util.Date());
        String milleSec = new java.text.SimpleDateFormat("SSS").format(new java.util.Date());

        switch (gbn) {

            case "yyyy":
                return date.substring(0, 4);
            case "mm":
                return date.substring(4, 6);
            case "dd":
                return date.substring(6, 8);
            case "hh":
                return time.substring(0, 2);
            case "mi":
                return time.substring(2, 4);
            case "ss":
                return time.substring(4, 6);
            case "sss":
                return milleSec;
            default:
                return "no date/time format. format add plz.";
        }
    }

    /**
     * 난수 생성(6자리)
     * @return 6자리 난수
     */
    public String getNumberGen() {

        Random rand     = new Random();
        String numStr   = ""; //난수가 저장될 변수

        for(int i=0;i<6;i++) {

            //0~9 까지 난수 생성
            String ran = Integer.toString(rand.nextInt(10));
            //중복을 허용하지 않을시 중복된 값이 있는지 검사한다
            if(!numStr.contains(ran)) {
                //중복된 값이 없으면 numStr에 append
                numStr += ran;
            }else {
                //생성된 난수가 중복되면 루틴을 다시 실행한다
                i-=1;
            }
        }
        return numStr;
    }
}
