package com.example.offchainapi.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NonNull;

import javax.persistence.*;

@Data
@Entity
@Table
@AllArgsConstructor
public class Tree {
    @Id
    @NonNull
    String address;
    @NonNull
    String owner;
    @NonNull
    String location;

    public Tree() {
    }
}
