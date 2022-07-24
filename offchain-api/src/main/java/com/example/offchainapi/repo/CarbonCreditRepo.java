package com.example.offchainapi.repo;

import com.example.offchainapi.models.CarbonCredit;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CarbonCreditRepo extends JpaRepository<CarbonCredit, String> {
}
