package iotBadSmellMonitoring.common;

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

}
