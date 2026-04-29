package com.medical.record.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.medical.record.system.entity.MedicalRecord;

import java.util.List;

public interface MedicalRecordService extends IService<MedicalRecord> {

    /**
     * 根据条件查询病案列表
     */
    List<MedicalRecord> selectByCondition(String recordNumber, String patientName, String department, String status);

    /**
     * 根据状态查询病案数量
     */
    int countByStatus(String status);

    /**
     * 根据科室查询病案数量
     */
    List<MedicalRecord> countByDepartment();

    /**
     * 添加病案
     */
    boolean addMedicalRecord(MedicalRecord medicalRecord);

    /**
     * 更新病案
     */
    boolean updateMedicalRecord(MedicalRecord medicalRecord);

    /**
     * 删除病案
     */
    boolean deleteMedicalRecord(Long id);

    /**
     * 批量删除病案
     */
    boolean batchDeleteMedicalRecords(List<Long> ids);

    /**
     * 更新病案状态
     */
    boolean updateStatus(Long id, String status);

}