package com.example.offchainapi.service;

import com.example.offchainapi.models.CarbonCredit;
import com.example.offchainapi.models.Tree;
import com.example.offchainapi.repo.CarbonCreditRepo;
import com.example.offchainapi.repo.TreeRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * offchain computation logic + interaction with DB does here
 */
@Service
public class ApplicationService {

    @Autowired
    TreeRepo treeRepo;

    @Autowired
    CarbonCreditRepo carbonCreditRepo;

    public boolean isTreeValid(Tree tree) {
        //do something ...
        return true;
    }

    public void addTree(Tree tree) {
            treeRepo.save(tree);
            System.out.println("tree added!");
    }

    public void sellTree(String treeAddress) {
        Tree tree = treeRepo.getReferenceById(treeAddress);
        tree.setForSale(true);
        treeRepo.save(tree);
    }
    public void sellCredit(String creditAddress) {
        CarbonCredit credit = carbonCreditRepo.getReferenceById(creditAddress);
        credit.setForSale(true);
        carbonCreditRepo.save(credit);
    }


    public void buyTree(String treeAddress) {
        Tree tree = treeRepo.getReferenceById(treeAddress);
        tree.setForSale(false);
        treeRepo.save(tree);
    }

    public void buyCredit(String creditAddress) {
        CarbonCredit credit = carbonCreditRepo.getReferenceById(creditAddress);
        credit.setForSale(false);
        carbonCreditRepo.save(credit);
    }

    public List<String> getForSaleList() {
        return treeRepo.findAll().stream().filter(Tree::isForSale).map(Tree::getAddress).collect(Collectors.toList());
    }

    public List<String> getForSaleListCC() {
        return carbonCreditRepo.findAll().stream().filter(CarbonCredit::isForSale).map(CarbonCredit::getAddress).collect(Collectors.toList());
    }

    public void addCarbonCredit(CarbonCredit carbonCredit) {
        carbonCreditRepo.save(carbonCredit);
    }

    public void test() {
    }
}
