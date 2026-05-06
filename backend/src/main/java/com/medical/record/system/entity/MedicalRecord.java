package com.medical.record.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("MedicalRecords")
public class MedicalRecord {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String recordNumber;

    private String patientName;

    private String patientId;

    private String department;

    private String diagnosis;

    private String status;

    private String admissionDate;

    private String dischargeDate;

    private LocalDateTime createdAt;

    private LocalDateTime updatedTime;

    @TableLogic
    private Integer deleted;

}