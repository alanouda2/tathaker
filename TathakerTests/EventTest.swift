//
//  EventTests.swift
//  TathakerTests
//
//  Created by Bullshit on 16/03/2025.
//

import XCTest
@testable import Tathaker  // Ensure you're importing your main app module

final class EventTests: XCTestCase {

    func testEventInitialization_WithValidData() {
        // Arrange: Create sample event data
        let sampleData: [String: Any] = [
            "title": "Baladna Park",
            "date": "March 15, 2025",
            "location": "Al Khor",
            "time_estimate": "2 hours",
            "image_url": "baladna.jpg"
        ]
        
        // Act: Initialize Event with sample data
        let event = Event(id: "12345", data: sampleData)

        // Assert: Check if properties are correctly assigned
        XCTAssertEqual(event.id, "12345")
        XCTAssertEqual(event.title, "Baladna Park")
        XCTAssertEqual(event.date, "March 15, 2025")
        XCTAssertEqual(event.location, "Al Khor")
        XCTAssertEqual(event.timeEstimate, "2 hours")
        XCTAssertEqual(event.imageUrl, "baladna.jpg")
    }

    func testEventInitialization_WithMissingData_UsesDefaultValues() {
        // Arrange: Create event data with missing keys
        let sampleData: [String: Any] = [:]

        // Act: Initialize Event with missing data
        let event = Event(id: "67890", data: sampleData)

        // Assert: Check default values
        XCTAssertEqual(event.id, "67890")
        XCTAssertEqual(event.title, "No Title")
        XCTAssertEqual(event.date, "No Date")
        XCTAssertEqual(event.location, "No Location")
        XCTAssertEqual(event.timeEstimate, "N/A")
        XCTAssertEqual(event.imageUrl, "")
    }
    
    func testEventInitialization_WithPartialData() {
        // Arrange: Create event data with some missing fields
        let sampleData: [String: Any] = [
            "title": "Desert Safari",
            "location": "Doha"
        ]

        // Act: Initialize Event with partial data
        let event = Event(id: "99999", data: sampleData)

        // Assert: Check assigned values and defaults
        XCTAssertEqual(event.id, "99999")
        XCTAssertEqual(event.title, "Desert Safari")
        XCTAssertEqual(event.date, "No Date") // Default
        XCTAssertEqual(event.location, "Doha")
        XCTAssertEqual(event.timeEstimate, "N/A") // Default
        XCTAssertEqual(event.imageUrl, "") // Default
    }

}
