package com.medical.record.system.controller;

import com.medical.record.system.config.OperationLog;
import com.medical.record.system.entity.User;
import com.medical.record.system.service.BorrowApplicationService;
import com.medical.record.system.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private BorrowApplicationService borrowApplicationService;

    @PostMapping("/register")
    @OperationLog(module = "User", operation = "USER_REGISTER", detail = "'username=' + #p0.username")
    public Map<String, Object> register(@RequestBody User user) {
        boolean success = userService.register(user);
        return Map.of(
                "success", success,
                "message", success ? "\u7528\u6237\u521b\u5efa\u6210\u529f" : "\u7528\u6237\u521b\u5efa\u5931\u8d25"
        );
    }

    @PostMapping("/login")
    @OperationLog(module = "Auth", operation = "LOGIN", detail = "'username=' + #p0['username']")
    public Map<String, Object> login(@RequestBody Map<String, String> params) {
        String username = params.get("username");
        String password = params.get("password");
        User user = userService.login(username, password);
        if (user != null) {
            return Map.of(
                    "token", "token_" + System.currentTimeMillis(),
                    "user", user
            );
        }
        return Map.of("error", "\u7528\u6237\u540d\u6216\u5bc6\u7801\u9519\u8bef");
    }

    @PostMapping("/logout")
    @OperationLog(module = "Auth", operation = "LOGOUT", detail = "'username=' + #p0['username']")
    public Map<String, Object> logout(@RequestBody Map<String, String> params) {
        return Map.of(
                "success", true,
                "message", "\u767b\u51fa\u6210\u529f"
        );
    }

    @GetMapping("/current")
    public User getCurrentUser() {
        return userService.selectByUsername("admin");
    }

    @PutMapping("/update")
    @OperationLog(module = "User", operation = "USER_UPDATE", detail = "'username=' + #p0.username")
    public Map<String, Object> updateUser(@RequestBody User user) {
        boolean success = userService.updateUserInfo(user);
        return Map.of(
                "success", success,
                "message", success ? "\u7528\u6237\u66f4\u65b0\u6210\u529f" : "\u7528\u6237\u66f4\u65b0\u5931\u8d25"
        );
    }

    @PutMapping("/reset-password")
    @OperationLog(module = "User", operation = "USER_PASSWORD_RESET", detail = "'userId=' + #p0['userId']")
    public Map<String, Object> resetPassword(@RequestBody Map<String, Object> params) {
        Long userId = Long.valueOf(params.get("userId").toString());
        String newPassword = params.get("newPassword").toString();
        boolean success = userService.resetPassword(userId, newPassword);
        return Map.of(
                "success", success,
                "message", success ? "\u5bc6\u7801\u91cd\u7f6e\u6210\u529f" : "\u5bc6\u7801\u91cd\u7f6e\u5931\u8d25"
        );
    }

    @GetMapping("/list")
    public List<User> getUserList() {
        return userService.list();
    }

    @GetMapping("/by-role/{roleId}")
    public List<User> getUsersByRole(@PathVariable Long roleId) {
        return userService.selectByRoleId(roleId);
    }

    @PutMapping("/batch-status")
    @OperationLog(module = "User", operation = "USER_BATCH_STATUS", detail = "'ids=' + #p0['ids']")
    public Map<String, Object> batchUpdateStatus(@RequestBody Map<String, Object> params) {
        List<Long> ids = (List<Long>) params.get("ids");
        Integer status = (Integer) params.get("status");
        boolean success = userService.updateStatusBatch(ids, status);
        return Map.of(
                "success", success,
                "message", success ? "\u6279\u91cf\u66f4\u65b0\u6210\u529f" : "\u6279\u91cf\u66f4\u65b0\u5931\u8d25"
        );
    }

    @PutMapping("/{id}/status")
    @OperationLog(module = "User", operation = "USER_STATUS", detail = "'id=' + #p0 + ', status=' + #p1['status']")
    public Map<String, Object> updateUserStatus(@PathVariable Long id, @RequestBody Map<String, Integer> params) {
        Integer status = params.get("status");
        User user = userService.getById(id);
        if (user == null) {
            return Map.of(
                    "success", false,
                    "message", "\u7528\u6237\u4e0d\u5b58\u5728"
            );
        }
        if (status == null || (status != 0 && status != 1)) {
            return Map.of(
                    "success", false,
                    "message", "\u72b6\u6001\u503c\u65e0\u6548"
            );
        }

        boolean success = userService.updateUserStatus(id, status);
        return Map.of(
                "success", success,
                "message", success ? "\u72b6\u6001\u66f4\u65b0\u6210\u529f" : "\u72b6\u6001\u66f4\u65b0\u5931\u8d25"
        );
    }

    @DeleteMapping("/{id}")
    @OperationLog(module = "User", operation = "USER_DELETE", detail = "'id=' + #p0")
    public Map<String, Object> deleteUser(@PathVariable Long id) {
        User user = userService.getById(id);
        if (user == null) {
            return Map.of(
                    "success", false,
                    "message", "\u7528\u6237\u4e0d\u5b58\u5728"
            );
        }
        if (!borrowApplicationService.selectByUserId(id).isEmpty()) {
            return Map.of(
                    "success", false,
                    "message", "\u8be5\u7528\u6237\u5b58\u5728\u501f\u9605\u7533\u8bf7\u8bb0\u5f55\uff0c\u65e0\u6cd5\u76f4\u63a5\u5220\u9664\uff0c\u8bf7\u5148\u7981\u7528\u8d26\u53f7"
            );
        }

        boolean success = userService.deleteUser(id);
        return Map.of(
                "success", success,
                "message", success ? "\u5220\u9664\u6210\u529f" : "\u5220\u9664\u5931\u8d25"
        );
    }
}
