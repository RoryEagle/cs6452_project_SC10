package com.example.offchainapi.controller;

import com.example.offchainapi.models.Tree;
import com.example.offchainapi.service.ApplicationService;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
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

    @PostMapping("/addTree")
    public ResponseEntity<String> addTree(@RequestBody Tree tree) {
        try {
            System.out.println("received! " + tree.getLocation() + tree.getAddress() + tree.getOwner());
            service.addTree(tree);
            return ResponseEntity.status(HttpStatus.CREATED).build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("invalid inputs");
        }
    }

    @PostMapping("/sellTree")
    public ResponseEntity<String> sellTree(@RequestBody Tree tree) {

    }
}
