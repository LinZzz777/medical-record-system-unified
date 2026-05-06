package com.medical.record.system.controller;

import com.medical.record.system.entity.AuditLog;
import com.medical.record.system.service.AuditLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/audit-logs")
public class AuditLogController {

    @Autowired
    private AuditLogService auditLogService;

    /**
     * 分页查询审计日志
     */
    @GetMapping
    public Map<String, Object> getAuditLogs(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String operationType,
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String endTime) {
        return auditLogService.selectAuditLogs(page, pageSize, username, operationType, startTime, endTime);
    }

    /**
     * 获取审计日志列表
     */
    @GetMapping("/list")
    public List<AuditLog> getAuditLogList() {
        return auditLogService.list();
    }

    /**
     * 根据用户查询审计日志
     */
    @GetMapping("/by-username/{username}")
    public List<AuditLog> getAuditLogsByUsername(@PathVariable String username) {
        return auditLogService.selectByUsername(username);
    }

    /**
     * 根据模块查询审计日志
     */
    @GetMapping("/by-module/{module}")
    public List<AuditLog> getAuditLogsByModule(@PathVariable String module) {
        return auditLogService.selectByModule(module);
    }

    /**
     * 根据时间范围查询审计日志
     */
    @GetMapping("/by-time-range")
    public List<AuditLog> getAuditLogsByTimeRange(@RequestParam String startTime, @RequestParam String endTime) {
        return auditLogService.selectByTimeRange(startTime, endTime);
    }

    /**
     * 根据操作类型查询审计日志
     */
    @GetMapping("/by-operation/{operation}")
    public List<AuditLog> getAuditLogsByOperation(@PathVariable String operation) {
        return auditLogService.selectByOperation(operation);
    }

    /**
     * 添加审计日志
     */
    @PostMapping("/create")
    public Map<String, Object> createAuditLog(@RequestBody AuditLog auditLog) {
        boolean success = auditLogService.addAuditLog(auditLog);
        return Map.of("success", success);
    }

    /**
     * 批量删除审计日志
     */
    @DeleteMapping("/batch")
    public Map<String, Object> batchDeleteAuditLogs(@RequestBody Map<String, List<Long>> params) {
        List<Long> ids = params.get("ids");
        boolean success = auditLogService.batchDeleteAuditLogs(ids);
        return Map.of("success", success);
    }

    /**
     * 清空审计日志
     */
    @DeleteMapping("/clear")
    public Map<String, Object> clearAuditLogs() {
        boolean success = auditLogService.clearAuditLogs();
        return Map.of("success", success);
    }

}