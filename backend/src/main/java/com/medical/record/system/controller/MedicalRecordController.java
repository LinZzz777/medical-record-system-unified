package com.medical.record.system.controller;

import com.medical.record.system.config.OperationLog;
import com.medical.record.system.entity.MedicalRecord;
import com.medical.record.system.service.MedicalRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/medical-records")
public class MedicalRecordController {

    @Autowired
    private MedicalRecordService medicalRecordService;

    /**
     * 获取病案列表
     */
    @GetMapping("/list")
    public List<MedicalRecord> getMedicalRecordList() {
        return medicalRecordService.list();
    }

    /**
     * 根据条件查询病案列表
     */
    @PostMapping("/search")
    public List<MedicalRecord> searchMedicalRecords(@RequestBody Map<String, String> params) {
        String recordNumber = params.get("recordNumber");
        String patientName = params.get("patientName");
        String department = params.get("department");
        String status = params.get("status");
        return medicalRecordService.selectByCondition(recordNumber, patientName, department, status);
    }

    /**
     * 根据ID获取病案详情
     */
    @GetMapping("/{id}")
    public MedicalRecord getMedicalRecordById(@PathVariable Long id) {
        return medicalRecordService.getById(id);
    }

    /**
     * 添加病案
     */
    @PostMapping("/create")
    @OperationLog(module = "Record", operation = "RECORD_CREATE", detail = "'recordNumber=' + #p0.recordNumber + ', patient=' + #p0.patientName")
    public Map<String, Object> createMedicalRecord(@RequestBody MedicalRecord medicalRecord) {
        boolean success = medicalRecordService.addMedicalRecord(medicalRecord);
        return Map.of("success", success);
    }

    /**
     * 更新病案
     */
    @PutMapping("/update")
    @OperationLog(module = "Record", operation = "RECORD_UPDATE", detail = "'id=' + #p0.id")
    public Map<String, Object> updateMedicalRecord(@RequestBody MedicalRecord medicalRecord) {
        boolean success = medicalRecordService.updateMedicalRecord(medicalRecord);
        return Map.of("success", success);
    }

    /**
     * 删除病案
     */
    @DeleteMapping("/{id}")
    @OperationLog(module = "Record", operation = "RECORD_DELETE", detail = "'id=' + #p0")
    public Map<String, Object> deleteMedicalRecord(@PathVariable Long id) {
        boolean success = medicalRecordService.deleteMedicalRecord(id);
        return Map.of("success", success);
    }

    /**
     * 批量删除病案
     */
    @DeleteMapping("/batch")
    @OperationLog(module = "Record", operation = "RECORD_BATCH_DELETE", detail = "'ids=' + #p0['ids']")
    public Map<String, Object> batchDeleteMedicalRecords(@RequestBody Map<String, List<Long>> params) {
        List<Long> ids = params.get("ids");
        boolean success = medicalRecordService.batchDeleteMedicalRecords(ids);
        return Map.of("success", success);
    }

    /**
     * 更新病案状态
     */
    @PutMapping("/{id}/status")
    @OperationLog(module = "Record", operation = "RECORD_STATUS", detail = "'id=' + #p0 + ', status=' + #p1['status']")
    public Map<String, Object> updateStatus(@PathVariable Long id, @RequestBody Map<String, String> params) {
        String status = params.get("status");
        boolean success = medicalRecordService.updateStatus(id, status);
        return Map.of("success", success);
    }

    /**
     * 获取病案状态统计
     */
    @GetMapping("/stats/status")
    public Map<String, Integer> getStatusStats() {
        return Map.of(
                "total", medicalRecordService.countByStatus("可借阅") + medicalRecordService.countByStatus("已借出") + medicalRecordService.countByStatus("已归档"),
                "available", medicalRecordService.countByStatus("可借阅"),
                "borrowed", medicalRecordService.countByStatus("已借出"),
                "archived", medicalRecordService.countByStatus("已归档")
        );
    }

    /**
     * 获取科室病案统计
     */
    @GetMapping("/stats/department")
    public List<MedicalRecord> getDepartmentStats() {
        return medicalRecordService.countByDepartment();
    }

}
