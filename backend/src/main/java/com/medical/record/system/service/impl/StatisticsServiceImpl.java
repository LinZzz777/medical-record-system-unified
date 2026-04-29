package com.medical.record.system.service.impl;

import com.medical.record.system.entity.BorrowApplication;
import com.medical.record.system.entity.MedicalRecord;
import com.medical.record.system.entity.User;
import com.medical.record.system.service.BorrowApplicationService;
import com.medical.record.system.service.MedicalRecordService;
import com.medical.record.system.service.StatisticsService;
import com.medical.record.system.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class StatisticsServiceImpl implements StatisticsService {

    private static final String RECORD_STATUS_AVAILABLE = "\u53ef\u501f\u9605";
    private static final String RECORD_STATUS_BORROWED = "\u5df2\u501f\u51fa";
    private static final String RECORD_STATUS_ARCHIVED = "\u5df2\u5f52\u6863";

    private static final String APP_STATUS_PENDING = "pending";
    private static final String APP_STATUS_APPROVED = "approved";
    private static final String APP_STATUS_REJECTED = "rejected";
    private static final String APP_STATUS_PICKED = "picked";
    private static final String APP_STATUS_COMPLETED = "completed";
    private static final String APP_STATUS_CANCELLED = "cancelled";

    private static final String LABEL_UNKNOWN_DEPARTMENT = "\u672a\u77e5\u79d1\u5ba4";
    private static final String LABEL_UNKNOWN_TYPE = "\u672a\u77e5\u7c7b\u578b";
    private static final String LABEL_UNKNOWN_REASON = "\u672a\u586b\u5199";

    private static final String LABEL_ON_TIME_RETURN = "\u6309\u65f6\u5f52\u8fd8";
    private static final String LABEL_OVERDUE_RETURN = "\u903e\u671f\u5f52\u8fd8";
    private static final String LABEL_UNRETURNED = "\u672a\u5f52\u8fd8";

    private static final DateTimeFormatter TREND_LABEL_FORMAT = DateTimeFormatter.ofPattern("M\u6708d\u65e5");
    private static final DateTimeFormatter[] DATE_FORMATTERS = new DateTimeFormatter[]{
            DateTimeFormatter.ofPattern("yyyy-MM-dd"),
            DateTimeFormatter.ofPattern("yyyy/M/d"),
            DateTimeFormatter.ofPattern("yyyy/M/dd"),
            DateTimeFormatter.ofPattern("yyyy/MM/d"),
            DateTimeFormatter.ofPattern("yyyy/MM/dd")
    };

    @Autowired
    private MedicalRecordService medicalRecordService;

    @Autowired
    private BorrowApplicationService borrowApplicationService;

    @Autowired
    private UserService userService;

    @Override
    public Map<String, Object> getUserStats(Long userId, String role) {
        Map<String, Object> stats = new LinkedHashMap<>();
        int totalRecords = medicalRecordService.countByStatus(RECORD_STATUS_AVAILABLE)
                + medicalRecordService.countByStatus(RECORD_STATUS_BORROWED)
                + medicalRecordService.countByStatus(RECORD_STATUS_ARCHIVED);

        if ("admin".equals(role)) {
            stats.put("totalRecords", totalRecords);
            stats.put("borrowedCount", medicalRecordService.countByStatus(RECORD_STATUS_BORROWED));
            stats.put("pendingCount", borrowApplicationService.selectPendingApplications().size());
            stats.put("overdueCount", borrowApplicationService.selectOverdueApplications().size());
        } else if ("dept_director".equals(role)) {
            User director = userService.getById(userId);
            String dept = director != null ? director.getDepartment() : null;
            List<BorrowApplication> allApps = borrowApplicationService.selectAllApplications();
            List<BorrowApplication> overdueApps = borrowApplicationService.selectOverdueApplications();

            long borrowedCount = allApps.stream()
                .filter(app -> dept != null && dept.equals(app.getUserDepartment())
                    && (APP_STATUS_APPROVED.equals(app.getStatus()) || APP_STATUS_PICKED.equals(app.getStatus())))
                .count();
            long pendingCount = allApps.stream()
                .filter(app -> APP_STATUS_PENDING.equals(app.getStatus())
                    && dept != null && dept.equals(app.getUserDepartment()))
                .count();
            long overdueCount = overdueApps.stream()
                .filter(app -> dept != null && dept.equals(app.getUserDepartment()))
                .count();

            stats.put("totalRecords", totalRecords);
            stats.put("borrowedCount", borrowedCount);
            stats.put("pendingCount", pendingCount);
            stats.put("overdueCount", overdueCount);
        } else {
            List<BorrowApplication> userApplications = borrowApplicationService.selectByUserId(userId);
            List<BorrowApplication> overdueApplications = borrowApplicationService.selectOverdueApplications();
            stats.put("totalRecords", totalRecords);
            stats.put("borrowedCount", userApplications.stream().filter(app -> APP_STATUS_APPROVED.equals(app.getStatus())).count());
            stats.put("pendingCount", userApplications.stream().filter(app -> APP_STATUS_PENDING.equals(app.getStatus())).count());
            stats.put("overdueCount", overdueApplications.stream().filter(app -> Objects.equals(app.getUserId(), userId)).count());
        }

        return stats;
    }

    @Override
    public Map<String, Object> getChartStats() {
        return getChartStats(null, "admin");
    }

    @Override
    public Map<String, Object> getChartStats(Long userId, String role) {
        List<BorrowApplication> applications = getApplicationsByRole(userId, role);
        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("statusData", getMedicalRecordStatusStats());
        stats.put("departmentStats", getDepartmentBorrowStats(applications));
        stats.put("borrowTrend", getBorrowTrendStats(applications));
        stats.put("borrowTypeStats", getBorrowTypeStats(applications));
        stats.put("approvalEfficiency", getApprovalEfficiencyStats(applications));
        stats.put("overdueTrend", getOverdueTrendStats(applications));
        stats.put("returnTimeliness", getReturnTimelinessStats(applications));
        return stats;
    }

    @Override
    public Map<String, Integer> getMedicalRecordStatusStats() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        stats.put(RECORD_STATUS_AVAILABLE, medicalRecordService.countByStatus(RECORD_STATUS_AVAILABLE));
        stats.put(RECORD_STATUS_BORROWED, medicalRecordService.countByStatus(RECORD_STATUS_BORROWED));
        stats.put(RECORD_STATUS_ARCHIVED, medicalRecordService.countByStatus(RECORD_STATUS_ARCHIVED));
        return stats;
    }

    @Override
    public Map<String, Integer> getBorrowApplicationStatusStats() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        stats.put(APP_STATUS_PENDING, borrowApplicationService.selectByStatus(APP_STATUS_PENDING).size());
        stats.put(APP_STATUS_APPROVED, borrowApplicationService.selectByStatus(APP_STATUS_APPROVED).size());
        stats.put(APP_STATUS_REJECTED, borrowApplicationService.selectByStatus(APP_STATUS_REJECTED).size());
        stats.put(APP_STATUS_COMPLETED, borrowApplicationService.selectByStatus(APP_STATUS_COMPLETED).size());
        stats.put(APP_STATUS_CANCELLED, borrowApplicationService.selectByStatus(APP_STATUS_CANCELLED).size());
        return stats;
    }

    @Override
    public Map<String, Integer> getDepartmentBorrowStats() {
        return getDepartmentBorrowStats(getAllApplications());
    }

    private Map<String, Integer> getDepartmentBorrowStats(List<BorrowApplication> applications) {
        Map<String, Integer> stats = new LinkedHashMap<>();
        for (BorrowApplication application : applications) {
            for (Long recordId : parseRecordIds(application.getRecordIds())) {
                MedicalRecord record = medicalRecordService.getById(recordId);
                if (record == null) {
                    continue;
                }
                String department = isBlank(record.getDepartment()) ? LABEL_UNKNOWN_DEPARTMENT : record.getDepartment();
                stats.put(department, stats.getOrDefault(department, 0) + 1);
            }
        }
        return stats;
    }

    @Override
    public Map<String, Object> getBorrowTrendStats() {
        return getBorrowTrendStats(getAllApplications());
    }

    private Map<String, Object> getBorrowTrendStats(List<BorrowApplication> applications) {
        List<String> dates = new ArrayList<>();
        List<Integer> borrowData = new ArrayList<>();

        LocalDate today = LocalDate.now();
        for (int i = 29; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            int count = 0;
            for (BorrowApplication application : applications) {
                if (application.getSubmitTime() != null && application.getSubmitTime().toLocalDate().equals(date)) {
                    count++;
                }
            }
            dates.add(date.format(TREND_LABEL_FORMAT));
            borrowData.add(count);
        }

        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("months", dates);
        stats.put("borrowData", borrowData);
        return stats;
    }

    @Override
    public Map<String, Integer> getBorrowTypeStats() {
        return getBorrowTypeStats(getAllApplications());
    }

    private Map<String, Integer> getBorrowTypeStats(List<BorrowApplication> applications) {
        Map<String, Integer> stats = new LinkedHashMap<>();
        for (BorrowApplication application : applications) {
            String borrowType = isBlank(application.getBorrowType()) ? LABEL_UNKNOWN_TYPE : application.getBorrowType();
            stats.put(borrowType, stats.getOrDefault(borrowType, 0) + 1);
        }
        return stats;
    }

    @Override
    public Map<String, Integer> getApprovalEfficiencyStats() {
        return getApprovalEfficiencyStats(getAllApplications());
    }

    private Map<String, Integer> getApprovalEfficiencyStats(List<BorrowApplication> applications) {
        Map<String, Integer> stats = new LinkedHashMap<>();
        stats.put("\u5c0f\u4e8e4\u5c0f\u65f6", 0);
        stats.put("4-24\u5c0f\u65f6", 0);
        stats.put("1-3\u5929", 0);
        stats.put("3\u5929\u4ee5\u4e0a", 0);

        for (BorrowApplication application : applications) {
            if (APP_STATUS_PENDING.equals(application.getStatus())) {
                continue;
            }

            LocalDateTime startTime = application.getSubmitTime();
            LocalDateTime endTime = resolveProcessedTime(application);
            if (startTime == null || endTime == null || endTime.isBefore(startTime)) {
                continue;
            }

            long hours = Duration.between(startTime, endTime).toHours();
            if (hours < 4) {
                increment(stats, "\u5c0f\u4e8e4\u5c0f\u65f6");
            } else if (hours < 24) {
                increment(stats, "4-24\u5c0f\u65f6");
            } else if (hours < 72) {
                increment(stats, "1-3\u5929");
            } else {
                increment(stats, "3\u5929\u4ee5\u4e0a");
            }
        }

        return stats;
    }

    @Override
    public Map<String, Object> getOverdueTrendStats() {
        return getOverdueTrendStats(getAllApplications());
    }

    private Map<String, Object> getOverdueTrendStats(List<BorrowApplication> applications) {
        List<String> dates = new ArrayList<>();
        List<Integer> overdueData = new ArrayList<>();

        LocalDate today = LocalDate.now();
        for (int i = 29; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            int count = 0;
            for (BorrowApplication application : applications) {
                LocalDate expectedDate = parseExpectedDate(application.getExpectedReturnDate());
                if (expectedDate != null && expectedDate.equals(date) && isCurrentlyOverdue(application, today)) {
                    count++;
                }
            }
            dates.add(date.format(TREND_LABEL_FORMAT));
            overdueData.add(count);
        }

        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("dates", dates);
        stats.put("overdueData", overdueData);
        return stats;
    }

    @Override
    public Map<String, Integer> getReturnTimelinessStats() {
        return getReturnTimelinessStats(getAllApplications());
    }

    private Map<String, Integer> getReturnTimelinessStats(List<BorrowApplication> applications) {
        Map<String, Integer> stats = new LinkedHashMap<>();
        stats.put(LABEL_ON_TIME_RETURN, 0);
        stats.put(LABEL_OVERDUE_RETURN, 0);
        stats.put(LABEL_UNRETURNED, 0);

        LocalDate today = LocalDate.now();
        for (BorrowApplication application : applications) {
            LocalDate expectedDate = parseExpectedDate(application.getExpectedReturnDate());
            if (expectedDate == null) {
                continue;
            }

            if (APP_STATUS_COMPLETED.equals(application.getStatus())) {
                LocalDateTime processedTime = resolveProcessedTime(application);
                LocalDate completedDate = processedTime != null ? processedTime.toLocalDate() : null;
                if (completedDate != null && !completedDate.isAfter(expectedDate)) {
                    increment(stats, LABEL_ON_TIME_RETURN);
                } else {
                    increment(stats, LABEL_OVERDUE_RETURN);
                }
            } else if (isCurrentlyOverdue(application, today)) {
                increment(stats, LABEL_UNRETURNED);
            }
        }

        return stats;
    }

    private List<BorrowApplication> getApplicationsByRole(Long userId, String role) {
        if ("admin".equals(role)) {
            return getAllApplications();
        }
        if (userId == null) {
            return new ArrayList<>();
        }
        List<BorrowApplication> applications = borrowApplicationService.selectByUserId(userId);
        return applications != null ? applications : new ArrayList<>();
    }

    private List<BorrowApplication> getAllApplications() {
        List<BorrowApplication> applications = borrowApplicationService.selectAllApplications();
        return applications != null ? applications : new ArrayList<>();
    }

    private List<Long> parseRecordIds(String rawRecordIds) {
        List<Long> ids = new ArrayList<>();
        if (isBlank(rawRecordIds)) {
            return ids;
        }

        String cleanIds = rawRecordIds.trim();
        if (cleanIds.startsWith("[") && cleanIds.endsWith("]")) {
            cleanIds = cleanIds.substring(1, cleanIds.length() - 1).trim();
        }
        if (cleanIds.isEmpty()) {
            return ids;
        }

        for (String value : cleanIds.split(",")) {
            try {
                ids.add(Long.valueOf(value.trim()));
            } catch (NumberFormatException ignored) {
                // Ignore malformed ids so one bad value does not break the chart.
            }
        }
        return ids;
    }

    private LocalDate parseExpectedDate(String value) {
        if (isBlank(value)) {
            return null;
        }

        for (DateTimeFormatter formatter : DATE_FORMATTERS) {
            try {
                return LocalDate.parse(value.trim(), formatter);
            } catch (DateTimeParseException ignored) {
                // Try the next supported format.
            }
        }
        return null;
    }

    private LocalDateTime resolveProcessedTime(BorrowApplication application) {
        if (APP_STATUS_COMPLETED.equals(application.getStatus()) && application.getReturnTime() != null) {
            return application.getReturnTime();
        }
        if (application.getApproveTime() != null) {
            return application.getApproveTime();
        }
        if (APP_STATUS_CANCELLED.equals(application.getStatus()) || APP_STATUS_REJECTED.equals(application.getStatus())) {
            return application.getUpdatedTime();
        }
        return application.getUpdatedTime();
    }

    private boolean isCurrentlyOverdue(BorrowApplication application, LocalDate today) {
        if (application == null) {
            return false;
        }
        if (APP_STATUS_COMPLETED.equals(application.getStatus())
                || APP_STATUS_CANCELLED.equals(application.getStatus())
                || APP_STATUS_REJECTED.equals(application.getStatus())) {
            return false;
        }
        LocalDate expectedDate = parseExpectedDate(application.getExpectedReturnDate());
        return expectedDate != null && expectedDate.isBefore(today);
    }

    private void increment(Map<String, Integer> stats, String key) {
        stats.put(key, stats.getOrDefault(key, 0) + 1);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
