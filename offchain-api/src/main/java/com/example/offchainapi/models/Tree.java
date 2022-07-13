package com.example.offchainapi.models;

import lombok.Data;

import javax.persistence.*;

@Data
@Entity
@Table
public class Tree {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    String id;
}
