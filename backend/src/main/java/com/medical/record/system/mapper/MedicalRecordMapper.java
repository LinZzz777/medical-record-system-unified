package com.medical.record.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.medical.record.system.entity.MedicalRecord;

import java.util.List;

public interface MedicalRecordMapper extends BaseMapper<MedicalRecord> {

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

}