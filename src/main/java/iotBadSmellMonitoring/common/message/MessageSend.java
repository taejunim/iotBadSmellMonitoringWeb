package iotBadSmellMonitoring.common.message;

import iotBadSmellMonitoring.common.UtProperty;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.KakaoOption;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.MultipleMessageSendingRequest;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.MultipleMessageSentResponse;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * @ Class Name   : MessageSend.java
 * @ Notification : MESSAGE SEND CLASS.
 * @
 * @ 최초 생성일      최초 생성자
 * @ ---------    ---------
 * @ 2022.03.21.    조유영
 * @
 * @  수정일          수정자
 * @ ---------    ---------
 * @
 **/
public class MessageSend {

    private final DefaultMessageService messageService;

    private static String apiKey         = UtProperty.getProperty("message.apiKey");                                    //API 키
    private static String apiSecretKey   = UtProperty.getProperty("message.apiSecretKey");                              //API Secret 키
    private static String domain         = UtProperty.getProperty("message.domain");                                    //api 호출 domain
    private static String pfId           = UtProperty.getProperty("message.pfId");                                      //카카오 채널 pf ID
    private static String temperateId    = UtProperty.getProperty("message.temperateId");                               //카카오 알림톡 템플릿 ID
    private static String from           = UtProperty.getProperty("message.from");                                      //알림 발신 번호

    /**
     * 발급받은 API KEY와 API Secret Key를 사용해주세요.
     */
    public MessageSend() {
        this.messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecretKey, domain);
    }

    /**
     * 단일 메시지 발송 (SMS)
     */
    public SingleMessageSentResponse sendOne(MessageVO messageVO) {

        SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(setMessage(messageVO)));
        System.out.println(response);

        return response;
    }

    /**
     * param - List<MessageVO> userList - 메세지를 수신할 사용자 이름/전화번호 목록
     * 여러 알림톡 발송
     * 한 번 실행으로 최대 10,000건 까지의 메시지가 발송 가능합니다.
     */
    public MultipleMessageSentResponse sendManyKakaoMessage(List<MessageVO> userList) {

        ArrayList<Message> messageList = new ArrayList<>();

        for (MessageVO messageVO : userList) {

            //메세지 생성
            Message message = setMessage(messageVO);
            //메세지에 담아줄 카카오 옵션 생성
            KakaoOption kakaoOption = setKakaoOption(messageVO);
            //메세지 카카오 옵션 Set
            message.setKakaoOptions(kakaoOption);
            messageList.add(message);
        }

        MultipleMessageSendingRequest request = new MultipleMessageSendingRequest(messageList);
        //알림톡 전송
        MultipleMessageSentResponse response = this.messageService.sendMany(request);
        //전송 실패했을때 예외처리 하기 위해 남겨놓음
        System.out.println(response);

        return response;
    }

    /**
     * 메시지 SET from/to/text
     */
    public Message setMessage(MessageVO messageVO) {
        Message message = new Message();
        message.setFrom(from);
        message.setTo(messageVO.getTo());
        message.setText(messageVO.getText());

        return message;
    }

    /**
     * 카카오 옵션 SET
     */
    public KakaoOption setKakaoOption(MessageVO messageVO) {
        KakaoOption kakaoOption = new KakaoOption();
        kakaoOption.setPfId(pfId);                          // 등록된 카카오 비즈니스 채널의 pfId
        kakaoOption.setTemplateId(temperateId);             // 등록된 카카오 알림톡 템플릿의 templateId

        // 알림톡 템플릿 내에 #{변수} 형태에 관한 variables를 설정.
        HashMap<String, String> variables = new HashMap<>();
        variables.put("#{사용자명}", messageVO.getUserName());
        kakaoOption.setVariables(variables);

        return kakaoOption;
    }
}
