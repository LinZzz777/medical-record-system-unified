package com.medical.record.system.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SpaForwardController {

    @GetMapping({"/", "/login", "/dashboard", "/borrow", "/borrow-history", "/review", "/users", "/audit", "/test"})
    public String forwardToIndex() {
        return "forward:/index.html";
    }
}
