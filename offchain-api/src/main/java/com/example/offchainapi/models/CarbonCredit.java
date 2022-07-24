package com.example.offchainapi.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Data
@Entity
@Table
@AllArgsConstructor
public class CarbonCredit {
    @Id
    String owner;
    String address;

    public CarbonCredit() {

    }
}
