package com.example.offchainapi.controller;

import com.example.offchainapi.models.CarbonCredit;
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
    public ResponseEntity<String> sellTree(@RequestBody JSONObject tree) {
        try {
            System.out.println("received sell request");
            service.sellTree(tree.getAsString("address"));
            System.out.println("tree sold");
            return ResponseEntity.ok("success");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("given tree address does not exist");
        }
    }

    @PostMapping("/addCarbonCredit")
    public ResponseEntity<String> addCarbonCredit(@RequestBody CarbonCredit carbonCredit) {
        try {
            System.out.println("received carbon credit add! " + carbonCredit.getAddress() + carbonCredit.getOwner());
            service.addCarbonCredit(carbonCredit);
            return ResponseEntity.status(HttpStatus.CREATED).build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("invalid inputs");
        }
    }
    @PostMapping("/buyTree")
    public ResponseEntity<String> buyTree(@RequestBody JSONObject tree) {
        try {
            System.out.println("received tree bought request");
            service.buyTree(tree.getAsString("address"));
            System.out.println("tree bought");
            return ResponseEntity.ok("success");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("given tree address does not exist");
        }
    }

}
