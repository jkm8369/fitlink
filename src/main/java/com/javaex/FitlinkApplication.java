package com.javaex;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.javaex.repository")
public class FitlinkApplication {

	public static void main(String[] args) {
		SpringApplication.run(FitlinkApplication.class, args);
	}

}
