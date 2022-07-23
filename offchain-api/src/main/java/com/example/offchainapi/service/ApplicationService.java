package com.example.offchainapi.service;

import com.example.offchainapi.models.Tree;
import com.example.offchainapi.repo.TreeRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * offchain computation logic + interaction with DB does here
 */
@Service
public class ApplicationService {

    @Autowired
    TreeRepo treeRepo;

    public boolean isTreeValid(Tree tree) {
        //do something ...
        return true;
    }

    public void addTree(Tree tree) {
            treeRepo.save(tree);
            System.out.println("tree added!");
    }

    public void test() {
    }
}
