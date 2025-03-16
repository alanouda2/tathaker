//
//  CategoryTests.swift
//  TathakerTests
//
//  Created by [Your Name] on 16/03/2025.
//

import XCTest
@testable import Tathaker

final class CategoryTests: XCTestCase {

    func testCategoryInitialization() {
        // Arrange
        let categoryName = "Sports"
        let categoryIcon = "sport_icon"

        // Act
        let category = Category(name: categoryName, iconName: categoryIcon)

        // Assert
        XCTAssertEqual(category.name, categoryName, "Category name should be initialized correctly")
        XCTAssertEqual(category.iconName, categoryIcon, "Category iconName should be initialized correctly")
    }

    func testCategoryHasUniqueID() {
        // Arrange
        let category1 = Category(name: "Music", iconName: "music_icon")
        let category2 = Category(name: "Concerts", iconName: "concert_icon")

        // Assert
        XCTAssertNotEqual(category1.id, category2.id, "Each category should have a unique UUID")
    }

    func testPerformanceOfCategoryInitialization() {
        self.measure {
            _ = Category(name: "Performance Test", iconName: "test_icon")
        }
    }
}
