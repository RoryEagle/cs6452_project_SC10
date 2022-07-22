package com.example.offchainapi.repo;

import com.example.offchainapi.models.Tree;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

public interface TreeRepo extends JpaRepository<Tree, String> {
}
