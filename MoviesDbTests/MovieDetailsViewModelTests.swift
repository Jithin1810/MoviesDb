//
//  MovieDetailsViewModelTests.swift
//  MoviesDbTests
//
//  Created by JiTHiN on 28/08/24.
//

import Foundation
import XCTest
@testable import MoviesDb

class MockMovieDetailsManagerDelegate: MovieDetailsManagerDelegate {
    var didUpdateMovieDetailsCalled = false
    var didFailWithErrorCalled = false
    var error: Error?

    func didUpdateMovieDetails() {
        didUpdateMovieDetailsCalled = true
    }

    func didFailWithError(_ error: Error) {
        didFailWithErrorCalled = true
        self.error = error
    }
}

class MovieDetailsViewModelTests: XCTestCase {
    var viewModel: MovieDetailsViewModel!
    var mockDelegate: MockMovieDetailsManagerDelegate!
    var mockNetworkingClient: MockNetworkManager!

    override func setUp() {
        super.setUp()
        let selectedMovie = Movies(
            Title: "Test Movie",
            Year: "2024",
            Poster: "",
            Plot: "This is a test movie.",
            Genre: "Action, Adventure",
            Director: "Test Director",
            Actors: "Test Actor 1, Test Actor 2",
            imdbRating: "7.8",
            imdbID: "test_id"
        )
        mockDelegate = MockMovieDetailsManagerDelegate()
        mockNetworkingClient = MockNetworkManager()
        viewModel = MovieDetailsViewModel(delegate: mockDelegate, selectedMovie: selectedMovie, network: mockNetworkingClient)
    }

    override func tearDown() {
        viewModel = nil
        mockDelegate = nil
        mockNetworkingClient = nil
        super.tearDown()
    }

    func testFetchMovieSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch movie details success")
        let mockData = """
        {
            "Title": "Updated Test Movie",
            "Year": "2024",
            "Poster": "",
            "Plot": "Updated plot",
            "Genre": "Action, Adventure",
            "Director": "Updated Director",
            "Actors": "Updated Actor 1, Updated Actor 2",
            "imdbRating": "8.0",
            "imdbID": "test_id"
        }
        """.data(using: .utf8)

        URLProtocolMock.testURLs = [URL(string: "https://www.omdbapi.com/?t=Test Movie&apikey=3940df7")!: mockData]
        URLProtocolMock.testError = nil

        // When
        viewModel.featchMovie()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Then
            XCTAssertTrue(self.mockDelegate.didUpdateMovieDetailsCalled, "Delegate method didUpdateMovieDetails should be called")
            XCTAssertEqual(self.viewModel.movieCount(), 1, "Movie count should be 1")
            let movie = self.viewModel.modelAt(0)
            XCTAssertEqual(movie.Title, "Updated Test Movie", "Title should be 'Updated Test Movie'")
            XCTAssertEqual(movie.imdbID, "test_id", "imdbID should be 'test_id'")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testParseJsonSuccess() {
        // Given
        let jsonData = """
        {
            "Title": "Parsed Movie",
            "Year": "2024",
            "Poster": "",
            "Plot": "Parsed plot",
            "Genre": "Action",
            "Director": "Parsed Director",
            "Actors": "Parsed Actor",
            "imdbRating": "7.9",
            "imdbID": "parsed_id"
        }
        """.data(using: .utf8)

        // When
        let movie = viewModel.parseJson(jsonData!)

        // Then
        XCTAssertNotNil(movie)
        XCTAssertEqual(movie?.Title, "Parsed Movie")
        XCTAssertEqual(movie?.imdbID, "parsed_id")
    }

    func testParseJsonFailure() {
        // Given
        let invalidData = "invalid data".data(using: .utf8)!

        // When
        let movie = viewModel.parseJson(invalidData)

        // Then
        XCTAssertNil(movie)
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled)
    }

    func testMovieCount() {
        // Given
        let movie = Movies(
            Title: "Test Movie",
            Year: "2024",
            Poster: "",
            Plot: "This is a test movie.",
            Genre: "Action, Adventure",
            Director: "Test Director",
            Actors: "Test Actor 1, Test Actor 2",
            imdbRating: "7.8",
            imdbID: "test_id"
        )
        viewModel.selectedMovie = movie

        // When
        let count = viewModel.movieCount()

        // Then
        XCTAssertEqual(count, 1)
    }

    func testModelAt() {
        // Given
        let movie = Movies(
            Title: "Test Movie",
            Year: "2024",
            Poster: "",
            Plot: "This is a test movie.",
            Genre: "Action, Adventure",
            Director: "Test Director",
            Actors: "Test Actor 1, Test Actor 2",
            imdbRating: "7.8",
            imdbID: "test_id"
        )
        viewModel.selectedMovie = movie

        // When
        let result = viewModel.modelAt(0)

        // Then
        XCTAssertEqual(result.Title, "Test Movie")
        XCTAssertEqual(result.imdbID, "test_id")
    }
}
