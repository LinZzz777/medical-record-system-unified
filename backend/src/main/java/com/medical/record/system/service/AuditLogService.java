package com.medical.record.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.medical.record.system.entity.AuditLog;

import java.util.List;
import java.util.Map;

public interface AuditLogService extends IService<AuditLog> {

    /**
     * 添加审计日志
     */
    boolean addAuditLog(AuditLog auditLog);

    /**
     * 根据用户查询审计日志
     */
    List<AuditLog> selectByUsername(String username);

    /**
     * 根据模块查询审计日志
     */
    List<AuditLog> selectByModule(String module);

    /**
     * 根据时间范围查询审计日志
     */
    List<AuditLog> selectByTimeRange(String startTime, String endTime);

    /**
     * 根据操作类型查询审计日志
     */
    List<AuditLog> selectByOperation(String operation);

    /**
     * 批量删除审计日志
     */
    boolean batchDeleteAuditLogs(List<Long> ids);

    /**
     * 清空审计日志
     */
    boolean clearAuditLogs();

    /**
     * 分页查询审计日志
     */
    Map<String, Object> selectAuditLogs(Integer page, Integer pageSize, String username, String operationType, String startTime, String endTime);

}