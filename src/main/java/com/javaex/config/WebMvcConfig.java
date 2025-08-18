package com.javaex.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.javaex.config.auth.AuthInterceptor;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
    	
    	String osName = System.getProperty("os.name").toLowerCase();
    	String resourceLocation = "";
    	
    	if(osName.contains("win")) {
    		resourceLocation = "file:///C:/javaStudy/upload/";
    	} else {
    		resourceLocation = "file:/data/upload/";
    	}
    	
        registry.addResourceHandler("/upload/**")
        	.addResourceLocations(resourceLocation);               // local x
        	//.addResourceLocations("file:///C:/javaStudy/upload/");   => local
    }
    
    /**
	 * 인터셉터를 등록하는 메소드입니다.
	 */
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		
		registry.addInterceptor(new AuthInterceptor()) // 1. 어떤 인터셉터를 사용할지 지정합니다.
				.addPathPatterns("/**") // 2. 모든 URL 경로("/**")에 이 인터셉터를 적용합니다.
				.excludePathPatterns(   // 3. 하지만 아래의 경로들은 인터셉터 검사에서 제외합니다.
						"/",            //    - 메인 페이지
						"/user/loginform", //    - 로그인 폼 페이지
						"/user/login",     //    - 로그인 처리			
						"/api/**",         //    - 데이터만 요청하는 API 주소들
						"/assets/**"       //    - css, js, image 같은 리소스 파일들
				);
	}
}
