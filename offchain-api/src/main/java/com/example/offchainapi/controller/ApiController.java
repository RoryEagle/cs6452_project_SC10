package com.example.offchainapi.controller;

import com.example.offchainapi.models.Tree;
import com.example.offchainapi.service.ApplicationService;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin
public class ApiController {

    @Autowired
    ApplicationService service;

    @GetMapping("/authenticate")
    public ResponseEntity<Boolean> validate(@RequestParam Tree tree) {
        return ResponseEntity.ok(service.isTreeValid(tree));
    }

    @GetMapping("/test")
    public ResponseEntity<JSONObject> test() {
        System.out.println("hello");
        JSONObject object = new JSONObject();
        object.put("temperature", "10");
        return ResponseEntity.ok(object);
    }
}
