package com.medical.record.system.config;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 标记需要审计的关键操作。
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface OperationLog {

    /**
     * 业务模块名称，例如：User、Borrow、Record。
     */
    String module();

    /**
     * 操作类型，例如：login、create、approve、delete。
     */
    String operation();

    /**
     * 详情描述，支持简单的 SpEL（如 #p0.username、#p1['approver']）。
     */
    String detail() default "";
}
