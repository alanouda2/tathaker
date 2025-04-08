//
//  Category.swift
//  Tathaker
//
//  Created by Aisha Al-Subaie on 15/03/2025.
//
import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String

    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
    }
}

