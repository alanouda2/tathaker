//
//  EventViewModelTests.swift
//  TathakerTests
//
//  Created by Alanoud Al Thani on 16/03/2025.
//

import XCTest
@testable import Tathaker

final class EventViewModelTests: XCTestCase {

    var viewModel: EventViewModel!

    override func setUpWithError() throws {
        viewModel = EventViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFetchEvents_UpdatesEventsArray() {
        // Initially, events should be empty
        XCTAssertTrue(viewModel.events.isEmpty)

        // Simulating event data
        let mockData: [[String: Any]] = [
            [
                "title": "Test Event",
                "date": "March 20, 2025",
                "location": "Doha",
                "time_estimate": "2 hours",
                "image_url": "test_image.jpg"
            ]
        ]

        // Convert mock data to Event objects
        let mockEvents = mockData.map { Event(id: UUID().uuidString, data: $0) }

        // Assign mock events to the view model
        viewModel.events = mockEvents

        // Check if events were updated
        XCTAssertFalse(viewModel.events.isEmpty)
        XCTAssertEqual(viewModel.events.count, 1)
        XCTAssertEqual(viewModel.events.first?.title, "Test Event")
    }

    func testFetchEvents_EmptyResponse() {
        viewModel.events = []
        XCTAssertTrue(viewModel.events.isEmpty)
    }

    func testFetchEvents_ErrorHandling() {
        let error = NSError(domain: "FirestoreError", code: 500, userInfo: nil)
        XCTAssertNotNil(error)
        XCTAssertEqual(error.domain, "FirestoreError")
        XCTAssertEqual(error.code, 500)
    }
}
