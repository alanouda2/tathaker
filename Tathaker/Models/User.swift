//
//  User.swift
//  Tathaker
//
//  Created by Bullshit  on 15/03/2025.
//
import Foundation
import FirebaseFirestore

import Foundation

struct User: Identifiable {
    var id: String // Firestore document ID
    var name: String
    var email: String
    var phoneNumber: String
    var profileImage: String
}

