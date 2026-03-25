package com.medical.record.system.config;

import com.medical.record.system.entity.BorrowApplication;
import com.medical.record.system.entity.MedicalRecord;
import com.medical.record.system.entity.User;
import com.medical.record.system.service.BorrowApplicationService;
import com.medical.record.system.service.MedicalRecordService;
import com.medical.record.system.service.UserService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Component
public class DemoDataInitializer implements CommandLineRunner {

    private static final String DEMO_RECORD_PREFIX = "DEMO-MR-";
    private static final String STATUS_AVAILABLE = "\u53ef\u501f\u9605";
    private static final String STATUS_BORROWED = "\u5df2\u501f\u51fa";
    private static final String STATUS_ARCHIVED = "\u5df2\u5f52\u6863";

    private final MedicalRecordService medicalRecordService;
    private final BorrowApplicationService borrowApplicationService;
    private final UserService userService;

    public DemoDataInitializer(MedicalRecordService medicalRecordService,
                               BorrowApplicationService borrowApplicationService,
                               UserService userService) {
        this.medicalRecordService = medicalRecordService;
        this.borrowApplicationService = borrowApplicationService;
        this.userService = userService;
    }

    @Override
    public void run(String... args) {
        boolean hasDemoRecords = medicalRecordService.list().stream()
                .anyMatch(record -> record.getRecordNumber() != null && record.getRecordNumber().startsWith(DEMO_RECORD_PREFIX));
        if (hasDemoRecords) {
            return;
        }

        List<User> users = userService.list();
        long defaultUserId = users.isEmpty() ? 1L : users.get(0).getId();
        String defaultUserName = users.isEmpty() ? "\u6f14\u793a\u7528\u6237" : users.get(0).getName();
        long secondUserId = users.size() > 1 ? users.get(1).getId() : defaultUserId;
        String secondUserName = users.size() > 1 ? users.get(1).getName() : defaultUserName;
        long thirdUserId = users.size() > 2 ? users.get(2).getId() : defaultUserId;
        String thirdUserName = users.size() > 2 ? users.get(2).getName() : defaultUserName;

        MedicalRecord r1 = createRecord("001", "\u5f20\u67d0", "\u5987\u4ea7\u79d1", "\u4ea7\u540e\u590d\u67e5", STATUS_BORROWED, 25);
        MedicalRecord r2 = createRecord("002", "\u674e\u67d0", "\u5987\u4ea7\u79d1", "\u5987\u79d1\u624b\u672f", STATUS_BORROWED, 21);
        MedicalRecord r3 = createRecord("003", "\u738b\u67d0", "\u5185\u79d1", "\u7cd6\u5c3f\u75c5", STATUS_ARCHIVED, 18);
        MedicalRecord r4 = createRecord("004", "\u8d75\u67d0", "\u5916\u79d1", "\u9611\u5c3e\u708e", STATUS_ARCHIVED, 15);
        MedicalRecord r5 = createRecord("005", "\u9648\u67d0", "\u513f\u79d1", "\u80ba\u708e", STATUS_AVAILABLE, 12);
        MedicalRecord r6 = createRecord("006", "\u5468\u67d0", "\u9aa8\u79d1", "\u9aa8\u6298", STATUS_AVAILABLE, 10);
        MedicalRecord r7 = createRecord("007", "\u5434\u67d0", "\u773c\u79d1", "\u767d\u5185\u969c", STATUS_BORROWED, 8);
        MedicalRecord r8 = createRecord("008", "\u90d1\u67d0", "\u8033\u9f3b\u5589\u79d1", "\u9f3b\u7aa6\u708e", STATUS_AVAILABLE, 6);
        MedicalRecord r9 = createRecord("009", "\u51af\u67d0", "\u53e3\u8154\u79d1", "\u667a\u9f7f\u62d4\u9664", STATUS_ARCHIVED, 4);
        MedicalRecord r10 = createRecord("010", "\u5b59\u67d0", "\u5185\u79d1", "\u9ad8\u8840\u538b", STATUS_BORROWED, 2);

        saveRecord(r1);
        saveRecord(r2);
        saveRecord(r3);
        saveRecord(r4);
        saveRecord(r5);
        saveRecord(r6);
        saveRecord(r7);
        saveRecord(r8);
        saveRecord(r9);
        saveRecord(r10);

        saveApplication(createApplication(r1, defaultUserId, defaultUserName, "\u9662\u5185\u501f\u9605", "\u79d1\u5ba4\u4f1a\u8bca\u8c03\u9605", "approved", 24, -3, 23, 24));
        saveApplication(createApplication(r2, secondUserId, secondUserName, "\u9662\u5916\u501f\u9605", "\u533b\u4fdd\u7a3d\u6838\u67e5\u6863", "picked", 20, -5, 19, 20));
        saveApplication(createApplication(r3, defaultUserId, defaultUserName, "\u9662\u5185\u501f\u9605", "\u6559\u5b66\u67e5\u623f\u4f7f\u7528", "completed", 17, 1, 16, 17));
        saveApplication(createApplication(r4, thirdUserId, thirdUserName, "\u9662\u5916\u501f\u9605", "\u75c5\u6848\u8d28\u63a7\u590d\u76d8", "completed", 14, -2, 13, 11));
        saveApplication(createApplication(r5, defaultUserId, defaultUserName, "\u9662\u5185\u501f\u9605", "\u5f85\u4e3b\u4efb\u5ba1\u6279", "pending", 9, 15, 9, 9));
        saveApplication(createApplication(r6, secondUserId, secondUserName, "\u9662\u5916\u501f\u9605", "\u7533\u8bf7\u4e0d\u7b26\u5408\u89c4\u8303", "rejected", 8, 12, 8, 7));
        saveApplication(createApplication(r7, thirdUserId, thirdUserName, "\u9662\u5185\u501f\u9605", "\u7533\u8bf7\u4eba\u4e3b\u52a8\u53d6\u6d88", "cancelled", 7, 10, 7, 7));
        saveApplication(createApplication(r8, defaultUserId, defaultUserName, "\u9662\u5916\u501f\u9605", "\u9662\u5916\u4f1a\u8bca\u8c03\u9605", "approved", 5, 7, 5, 5));
        saveApplication(createApplication(r9, secondUserId, secondUserName, "\u9662\u5185\u501f\u9605", "\u79d1\u7814\u8bfe\u9898\u67e5\u9605", "completed", 4, 0, 4, 4));
        saveApplication(createApplication(r10, thirdUserId, thirdUserName, "\u9662\u5916\u501f\u9605", "\u533b\u7597\u7ea0\u7eb7\u6750\u6599\u8c03\u53d6", "approved", 2, 10, 2, 2));
    }

    private MedicalRecord createRecord(String suffix,
                                       String patientName,
                                       String department,
                                       String diagnosis,
                                       String status,
                                       int daysAgo) {
        MedicalRecord record = new MedicalRecord();
        LocalDateTime createdAt = LocalDateTime.now().minusDays(daysAgo);
        record.setRecordNumber(DEMO_RECORD_PREFIX + suffix);
        record.setPatientName(patientName);
        record.setPatientId("PID-" + suffix);
        record.setDepartment(department);
        record.setDiagnosis(diagnosis);
        record.setStatus(status);
        record.setAdmissionDate(LocalDate.now().minusDays(daysAgo + 5).toString());
        record.setDischargeDate(LocalDate.now().minusDays(Math.max(daysAgo, 1)).toString());
        record.setCreatedAt(createdAt);
        record.setUpdatedTime(createdAt.plusHours(2));
        record.setDeleted(0);
        return record;
    }

    private BorrowApplication createApplication(MedicalRecord record,
                                                Long userId,
                                                String userName,
                                                String borrowType,
                                                String reason,
                                                String status,
                                                int submitDaysAgo,
                                                int expectedOffsetDays,
                                                int approveDaysAgo,
                                                int updatedDaysAgo) {
        BorrowApplication application = new BorrowApplication();
        LocalDateTime submitTime = LocalDateTime.now().minusDays(submitDaysAgo).withHour(10).withMinute(0).withSecond(0).withNano(0);
        LocalDateTime approveTime = LocalDateTime.now().minusDays(approveDaysAgo).withHour(14).withMinute(30).withSecond(0).withNano(0);
        LocalDateTime updatedTime = LocalDateTime.now().minusDays(updatedDaysAgo).withHour(16).withMinute(0).withSecond(0).withNano(0);

        application.setRecordIds(String.valueOf(record.getId()));
        application.setReason(reason);
        application.setBorrowType(borrowType);
        application.setExpectedReturnDate(submitTime.toLocalDate().plusDays(expectedOffsetDays).toString());
        application.setStatus(status);
        application.setSubmitTime(submitTime);
        application.setUserId(userId);
        application.setUserName(userName);
        application.setCreatedTime(submitTime);
        application.setUpdatedTime(updatedTime);
        application.setDeleted(0);

        if ("approved".equals(status) || "picked".equals(status) || "completed".equals(status) || "rejected".equals(status)) {
            application.setApprover("\u7cfb\u7edf\u7ba1\u7406\u5458");
            application.setApproveTime(approveTime);
        }
        if ("rejected".equals(status)) {
            application.setRejectionReason("\u6f14\u793a\u6570\u636e\uff1a\u6750\u6599\u4e0d\u5b8c\u6574");
        }
        return application;
    }

    private void saveRecord(MedicalRecord record) {
        medicalRecordService.save(record);
    }

    private void saveApplication(BorrowApplication application) {
        borrowApplicationService.save(application);
    }
}
