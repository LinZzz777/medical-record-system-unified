package com.medical.record.system.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medical.record.system.entity.MedicalRecord;
import com.medical.record.system.mapper.MedicalRecordMapper;
import com.medical.record.system.service.MedicalRecordService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class MedicalRecordServiceImpl extends ServiceImpl<MedicalRecordMapper, MedicalRecord> implements MedicalRecordService {

    @Override
    public List<MedicalRecord> selectByCondition(String recordNumber, String patientName, String department, String status) {
        return baseMapper.selectByCondition(recordNumber, patientName, department, status);
    }

    @Override
    public int countByStatus(String status) {
        List<MedicalRecord> records = baseMapper.selectByCondition(null, null, null, status);
        return records.size();
    }

    @Override
    public List<MedicalRecord> countByDepartment() {
        return baseMapper.countByDepartment();
    }

    @Override
    public boolean addMedicalRecord(MedicalRecord medicalRecord) {
        medicalRecord.setCreatedAt(LocalDateTime.now());
        medicalRecord.setUpdatedTime(LocalDateTime.now());
        medicalRecord.setStatus("可借阅");
        medicalRecord.setDeleted(0);
        return save(medicalRecord);
    }

    @Override
    public boolean updateMedicalRecord(MedicalRecord medicalRecord) {
        medicalRecord.setUpdatedTime(LocalDateTime.now());
        return updateById(medicalRecord);
    }

    @Override
    public boolean deleteMedicalRecord(Long id) {
        return removeById(id);
    }

    @Override
    public boolean batchDeleteMedicalRecords(List<Long> ids) {
        return removeByIds(ids);
    }

    @Override
    public boolean updateStatus(Long id, String status) {
        MedicalRecord medicalRecord = getById(id);
        if (medicalRecord != null) {
            medicalRecord.setStatus(status);
            medicalRecord.setUpdatedTime(LocalDateTime.now());
            return updateById(medicalRecord);
        }
        return false;
    }

}