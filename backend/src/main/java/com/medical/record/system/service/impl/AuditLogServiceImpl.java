package com.medical.record.system.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medical.record.system.entity.AuditLog;
import com.medical.record.system.mapper.AuditLogMapper;
import com.medical.record.system.service.AuditLogService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AuditLogServiceImpl extends ServiceImpl<AuditLogMapper, AuditLog> implements AuditLogService {

    @Override
    public boolean addAuditLog(AuditLog auditLog) {
        auditLog.setCreatedTime(LocalDateTime.now());
        auditLog.setDeleted(0);
        return save(auditLog);
    }

    @Override
    public List<AuditLog> selectByUsername(String username) {
        return baseMapper.selectByUsername(username);
    }

    @Override
    public List<AuditLog> selectByModule(String module) {
        return baseMapper.selectByModule(module);
    }

    @Override
    public List<AuditLog> selectByTimeRange(String startTime, String endTime) {
        return baseMapper.selectByTimeRange(startTime, endTime);
    }

    @Override
    public List<AuditLog> selectByOperation(String operation) {
        return baseMapper.selectByOperation(operation);
    }

    @Override
    public boolean batchDeleteAuditLogs(List<Long> ids) {
        return removeByIds(ids);
    }

    @Override
    public boolean clearAuditLogs() {
        // 这里可以实现清空审计日志的逻辑
        // 注意：实际操作中应该考虑保留一定时间的日志
        return true;
    }

    @Override
    public Map<String, Object> selectAuditLogs(Integer page, Integer pageSize, String username, String operationType, String startTime, String endTime) {
        IPage<AuditLog> auditLogPage = new Page<>(page, pageSize);
        IPage<AuditLog> result = baseMapper.selectAuditLogs(auditLogPage, username, operationType, startTime, endTime);
        
        Map<String, Object> map = new HashMap<>();
        map.put("records", result.getRecords());
        map.put("total", result.getTotal());
        map.put("current", result.getCurrent());
        map.put("size", result.getSize());
        map.put("pages", result.getPages());
        
        return map;
    }

}