package iotBadSmellMonitoring.history.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.common.message.MessageSend;
import iotBadSmellMonitoring.common.message.MessageVO;
import iotBadSmellMonitoring.history.service.RegisterService;
import iotBadSmellMonitoring.history.service.RegisterVO;
import iotBadSmellMonitoring.member.service.MemberService;
import org.apache.ibatis.session.SqlSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.List;

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

    @Value("${${environment}.server.ip}")
    private String serverIp;

    @Value("${${environment}.server.port}")
    private String serverPort;

    @Value("${${environment}.server.path}")
    private String serverPath;

    @Autowired
    private MemberService memberService;

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

        int masterResult = registerMapper.registerMasterInsert(registerVO);                                             //접수 마스터 등록 CALL.
        int allResult    = 0;                                                                                           //마스터||디테일 등록 결과

        if(masterResult == 1){
            if (!registerVO.getSmellValue().equals("001") && !registerVO.getSmellValue().equals("002") && !registerVO.getSmellValue().equals("003")) {                           //악취 강도가 3이상일시

                List<MessageVO> memberList = memberService.adminPhoneNumberListSelect();
                EgovMap userInfo = memberService.memberGetInfoSelect(registerVO.getRegId());

                for (MessageVO messageVO : memberList) {
                    messageVO.setText(userInfo.get("userRegionMasterName").toString() + " " + userInfo.get("userRegionDetailName").toString()  + " " + userInfo.get("userName").toString() + "님이 3도이상 접수를 하셨습니다." );
                }

                MessageSend messageSend = new MessageSend();
                messageSend.sendMany(memberList);                                                                       //관리자에게 문자 전송
            }

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

                    registerVO.setSmellImagePath("http://"+serverIp+":"+serverPort+"/iotBadSmellMonitoringWebImg/"+registerVO.getSmellRegisterNo()+"/"+registerVO.getSmellRegisterNo()+"_"+fileSeq+"."+extension);
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

}
