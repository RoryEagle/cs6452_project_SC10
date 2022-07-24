package com.example.offchainapi.models;

import lombok.*;

import javax.persistence.*;

@Data
@Entity
@Table
@AllArgsConstructor
@RequiredArgsConstructor
public class Tree {
    @Id
    @NonNull
    String address;
    @NonNull
    String owner;
    @NonNull
    String location;
    boolean forSale;
    boolean bought;

    public Tree() {
    }
}
