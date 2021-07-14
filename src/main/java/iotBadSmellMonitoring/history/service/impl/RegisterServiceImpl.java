package iotBadSmellMonitoring.history.service.impl;

import iotBadSmellMonitoring.history.service.RegisterService;
import iotBadSmellMonitoring.history.service.RegisterVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileOutputStream;

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

    /**
     * 접수 마스터||디테일 등록
     * @param registerVO REGISTER MASTER / DETAIL VO.
     * @return           int
     * @throws Exception
     */
    public int registerInsert(RegisterVO registerVO) throws Exception {

        RegisterMapper registerMapper = sqlSession.getMapper(RegisterMapper.class);

        registerVO.setSmellRegisterNo(registerMapper.registerSmellRegisterNoSelect());                                  //접수 마스터 번호 CALL.

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
