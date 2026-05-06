package com.medical.record.system.service;

import java.util.Map;

public interface StatisticsService {

    /**
     * 获取用户统计数据
     */
    Map<String, Object> getUserStats(Long userId, String role);

    /**
     * 获取完整的图表统计数据
     */
    Map<String, Object> getChartStats();

    /**
     * 获取按用户角色过滤后的图表统计数据
     */
    Map<String, Object> getChartStats(Long userId, String role);

    /**
     * 获取病案状态统计
     */
    Map<String, Integer> getMedicalRecordStatusStats();

    /**
     * 获取借阅申请状态统计
     */
    Map<String, Integer> getBorrowApplicationStatusStats();

    /**
     * 获取科室借阅统计
     */
    Map<String, Integer> getDepartmentBorrowStats();

    /**
     * 获取借阅趋势分析数据
     */
    Map<String, Object> getBorrowTrendStats();

    /**
     * 获取借阅类型分布
     */
    Map<String, Integer> getBorrowTypeStats();

    /**
     * 获取审批效率分析数据
     */
    Map<String, Integer> getApprovalEfficiencyStats();

    /**
     * 获取逾期趋势分析数据
     */
    Map<String, Object> getOverdueTrendStats();

    /**
     * 获取归还及时率分析数据
     */
    Map<String, Integer> getReturnTimelinessStats();

}
