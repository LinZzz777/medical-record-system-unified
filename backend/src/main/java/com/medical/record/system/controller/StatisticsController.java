package com.medical.record.system.controller;

import com.medical.record.system.service.StatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/statistics")
public class StatisticsController {

    @Autowired
    private StatisticsService statisticsService;

    /**
     * 获取用户统计数据
     */
    @GetMapping("/user-stats")
    public Map<String, Object> getUserStats(@RequestParam Long userId, @RequestParam String role) {
        return statisticsService.getUserStats(userId, role);
    }

    /**
     * 获取完整的图表统计数据
     */
    @GetMapping("/chart-stats")
    public Map<String, Object> getChartStats(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) String role
    ) {
        if (role == null || role.trim().isEmpty()) {
            return statisticsService.getChartStats();
        }
        return statisticsService.getChartStats(userId, role);
    }

    /**
     * 获取病案状态统计
     */
    @GetMapping("/medical-record-status")
    public Map<String, Integer> getMedicalRecordStatusStats() {
        return statisticsService.getMedicalRecordStatusStats();
    }

    /**
     * 获取借阅申请状态统计
     */
    @GetMapping("/borrow-application-status")
    public Map<String, Integer> getBorrowApplicationStatusStats() {
        return statisticsService.getBorrowApplicationStatusStats();
    }

    /**
     * 获取科室借阅统计
     */
    @GetMapping("/department-borrow")
    public Map<String, Integer> getDepartmentBorrowStats() {
        return statisticsService.getDepartmentBorrowStats();
    }

    /**
     * 获取借阅趋势分析数据
     */
    @GetMapping("/borrow-trend")
    public Map<String, Object> getBorrowTrendStats() {
        return statisticsService.getBorrowTrendStats();
    }

    /**
     * 获取借阅类型分布
     */
    @GetMapping("/borrow-type")
    public Map<String, Integer> getBorrowTypeStats() {
        return statisticsService.getBorrowTypeStats();
    }

    /**
     * 获取审批效率分析数据
     */
    @GetMapping("/approval-efficiency")
    public Map<String, Integer> getApprovalEfficiencyStats() {
        return statisticsService.getApprovalEfficiencyStats();
    }

}
