package com.medical.record.system.config;

import com.medical.record.system.entity.AuditLog;
import com.medical.record.system.service.AuditLogService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.lang.reflect.Method;
import java.util.Map;
import java.util.Optional;

@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class OperationLogAspect {

    private final AuditLogService auditLogService;
    private final HttpServletRequest request;

    private final ExpressionParser parser = new SpelExpressionParser();

    @Around("@annotation(operationLog)")
    public Object recordOperation(ProceedingJoinPoint joinPoint, OperationLog operationLog) throws Throwable {
        AuditLog auditLog = new AuditLog();
        auditLog.setModule(operationLog.module());
        auditLog.setOperation(operationLog.operation());
        auditLog.setIp(resolveClientIp());
        auditLog.setUserAgent(Optional.ofNullable(request.getHeader("User-Agent")).orElse("unknown"));
        auditLog.setUsername(resolveUsername(joinPoint));
        auditLog.setDetails(resolveDetail(operationLog.detail(), joinPoint, operationLog));

        try {
            Object result = joinPoint.proceed();
            auditLog.setStatus(1);
            return result;
        } catch (Throwable ex) {
            auditLog.setStatus(0);
            auditLog.setDetails(auditLog.getDetails() + " | error: " + ex.getMessage());
            throw ex;
        } finally {
            try {
                auditLogService.addAuditLog(auditLog);
            } catch (Exception e) {
                log.error("审计日志记录失败: module={}, operation={}, username={}, error={}",
                        auditLog.getModule(), auditLog.getOperation(), auditLog.getUsername(), e.getMessage());
            }
        }
    }

    private String resolveDetail(String detail, ProceedingJoinPoint joinPoint, OperationLog op) {
        if (!StringUtils.hasText(detail)) {
            return op.module() + ":" + op.operation();
        }
        try {
            Method method = ((MethodSignature) joinPoint.getSignature()).getMethod();
            Object[] args = joinPoint.getArgs();
            String[] paramNames = ((MethodSignature) joinPoint.getSignature()).getParameterNames();

            StandardEvaluationContext context = new StandardEvaluationContext();
            if (paramNames != null) {
                for (int i = 0; i < paramNames.length; i++) {
                    context.setVariable(paramNames[i], args[i]);
                }
            }
            for (int i = 0; i < args.length; i++) {
                context.setVariable("p" + i, args[i]);
            }
            return parser.parseExpression(detail).getValue(context, String.class);
        } catch (Exception e) {
            return op.module() + ":" + op.operation();
        }
    }

    private String resolveUsername(ProceedingJoinPoint joinPoint) {
        // 优先取前端传入的 X-User 头
        String headerUser = request.getHeader("X-User");
        if (StringUtils.hasText(headerUser)) {
            return headerUser;
        }
        // 其次取请求参数
        String paramUser = request.getParameter("username");
        if (StringUtils.hasText(paramUser)) {
            return paramUser;
        }
        // 再尝试从方法参数中推断
        for (Object arg : joinPoint.getArgs()) {
            if (arg == null) continue;
            if (arg instanceof Map<?, ?> map) {
                Object val = map.get("username");
                if (val == null) val = map.get("userName");
                if (val != null) return val.toString();
            }
            try {
                Method getter = arg.getClass().getMethod("getUsername");
                Object val = getter.invoke(arg);
                if (val != null) return val.toString();
            } catch (Exception ignored) {}
            try {
                Method getter = arg.getClass().getMethod("getUserName");
                Object val = getter.invoke(arg);
                if (val != null) return val.toString();
            } catch (Exception ignored) {}
        }
        return "unknown";
    }

    private String resolveClientIp() {
        String xff = request.getHeader("X-Forwarded-For");
        if (StringUtils.hasText(xff)) {
            return xff.split(",")[0].trim();
        }
        String realIp = request.getHeader("X-Real-IP");
        if (StringUtils.hasText(realIp)) {
            return realIp;
        }
        return Optional.ofNullable(request.getRemoteAddr()).orElse("unknown");
    }
}
