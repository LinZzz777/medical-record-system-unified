package com.medical.record.system;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.medical.record.system.mapper")
public class MedicalRecordSystemApplication {

    public static void main(String[] args) {
        SpringApplication.run(MedicalRecordSystemApplication.class, args);
    }

}