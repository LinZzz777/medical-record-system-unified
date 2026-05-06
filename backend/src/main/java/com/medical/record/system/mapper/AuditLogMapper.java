package com.medical.record.system.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.medical.record.system.entity.AuditLog;

import java.util.List;

public interface AuditLogMapper extends BaseMapper<AuditLog> {

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
     * 分页查询审计日志
     */
    IPage<AuditLog> selectAuditLogs(IPage<AuditLog> page, String username, String operationType, String startTime, String endTime);

}