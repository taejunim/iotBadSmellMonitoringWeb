package iotBadSmellMonitoring.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Repository;

@Repository
public class UtProperty {

    static Environment environment;

    @Autowired
    public void setEnvironment(Environment env) {
        environment = env;
    }
    public static String getProperty(String key) {
        return environment.getProperty(key);
    }

}
