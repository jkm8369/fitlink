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
		}else {
			resourceLocation = "file:/data/upload/";
		}
		
		registry.addResourceHandler("/upload/**")
				.addResourceLocations(resourceLocation);
	}

    /**
     * 인터셉터 등록
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new AuthInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/",                 // 메인
                        "/user/loginform",  // 로그인 폼
                        "/user/login",      // 로그인 처리
                        "/user/login/mobile", //로그인(모바일)
                        "/user/loginform/mobile", // 로그인 폼-모바일
                        "/api/**",          // 공개 API
                        "/assets/**",       // 정적 리소스
                        "/upload/**",       // 업로드 리소스 (리소스핸들러와 일치)
                        "/favicon.ico",     // 파비콘
                        "/error"            // 에러 페이지

                );
    }
	
}
