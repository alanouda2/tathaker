//
//  NavigationCoordinator.swift
//  Tathaker
//
//  Created by Muhammad Zakir on 14/04/2025.
//
import Foundation
import SwiftUI

class NavigationCoordinator: ObservableObject {
    
    
    static let shared = NavigationCoordinator()

    @Published var selectedTab: Int = 0
    @Published var ticketConfirmationData: Event? = nil
    
    
    @Published var resetHomeNavigation: Bool = false

}
