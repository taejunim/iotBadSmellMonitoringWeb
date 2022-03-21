package iotBadSmellMonitoring.common.message;

import lombok.Data;

@SuppressWarnings("serial")
@Data
public class MessageVO {

    private String from;
    private String to;
    private String text;

}
