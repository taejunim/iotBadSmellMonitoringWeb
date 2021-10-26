package iotBadSmellMonitoring.common;


import lombok.Data;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.stereotype.Controller;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport;

/**
 * @ Class Name   : PropertyConfig.java
 * @ Modification : APPLICATION PROPERTY ACCESS CLASS.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.07.14.    고재훈
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/

@Configuration
@ComponentScan(basePackages= "iotBadSmellMonitoring.common", includeFilters = @ComponentScan.Filter({Controller.class, Data.class}), useDefaultFilters = false)
@PropertySource(value = {"classpath:application.properties"}, encoding = "UTF-8")
public class PropertyConfig extends WebMvcConfigurationSupport {

    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        PropertySourcesPlaceholderConfigurer pspc = new PropertySourcesPlaceholderConfigurer();
        pspc.setIgnoreUnresolvablePlaceholders(true);
        return pspc;
    }

}
