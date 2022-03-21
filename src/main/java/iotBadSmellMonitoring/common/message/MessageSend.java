package iotBadSmellMonitoring.common.message;

import iotBadSmellMonitoring.common.UtProperty;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;

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

    private String        apiKey         = UtProperty.getProperty("message.apiKey");
    private String        apiSecretKey   = UtProperty.getProperty("message.apiSecretKey");
    private static String domain         = UtProperty.getProperty("message.domain");

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
     * 단일 메시지 SET
     */
    public Message setMessage(MessageVO messageVO) {
        Message message = new Message();
        message.setFrom(messageVO.getFrom());
        message.setTo(messageVO.getTo());
        message.setText(messageVO.getText());

        return message;
    }

}