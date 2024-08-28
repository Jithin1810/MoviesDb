//
//  MovieSearchViewModeTests.swift
//  MoviesDbTests
//
//  Created by JiTHiN on 27/08/24.
//

import XCTest
@testable import MoviesDb

class MockFavoritesService: FavoritesService {
    var favorites: [Movies] = []
    
    override func saveFavorite(movie: Movies) {
        favorites.append(movie)
    }
    
    override func removeFavorite(imdbID: String) {
        favorites.removeAll { $0.imdbID == imdbID }
    }
    
    override func loadFavorites() -> [Movies] {
        return favorites
    }
}

class MockMovieSearchManagerDelegate: MovieSearchManagerDelegate {
    var didUpdateMovieCalled = false
    var didFailWithErrorCalled = false
    var error: Error?
    
    func didUpdateMovie() {
        didUpdateMovieCalled = true
    }
    
    func didFailWithError(_ error: Error) {
        didFailWithErrorCalled = true
        self.error = error
    }
}

class MovieSearchViewModelTests: XCTestCase {
    var viewModel: MovieSearchViewModel!
    var mockDelegate: MockMovieSearchManagerDelegate!
    var mockFavoritesService: MockFavoritesService!

    override func setUp() {
        super.setUp()
        mockDelegate = MockMovieSearchManagerDelegate()
        mockFavoritesService = MockFavoritesService()
        viewModel = MovieSearchViewModel()
        viewModel.delegate = mockDelegate
        viewModel.favouriteService = mockFavoritesService
        viewModel.network = MockNetworkManager()
    }

    override func tearDown() {
        viewModel = nil
        mockDelegate = nil
        mockFavoritesService = nil
        super.tearDown()
    }

    func testToggleFavorite() {
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
        viewModel.moviesArray = [movie]

        // When
        viewModel.toggleFavourite(for: "test_id")
        
        // Then
        XCTAssertTrue(mockFavoritesService.loadFavorites().contains { $0.imdbID == "test_id" })

        // When
        viewModel.toggleFavourite(for: "test_id")
        
        // Then
        XCTAssertFalse(mockFavoritesService.loadFavorites().contains { $0.imdbID == "test_id" })
    }

    func testFetchMovieSuccess() {
            // Given
            let expectation = XCTestExpectation(description: "Fetch movie success")
            let mockData = """
            {
                "Search": [
                    {
                        "Title": "Test Movie",
                        "Year": "2024",
                        "Poster": "",
                        "Plot": "This is a test movie.",
                        "Genre": "Action, Adventure",
                        "Director": "Test Director",
                        "Actors": "Test Actor 1, Test Actor 2",
                        "imdbRating": "7.8",
                        "imdbID": "test_id"
                    }
                ]
            }
            """.data(using: .utf8)
            URLProtocolMock.testURLs = [URL(string: "https://www.omdbapi.com/?s=TestMovie&apikey=3940df7")!: mockData]
            let success = URLProtocol.registerClass(URLProtocolMock.self)

            // When
            viewModel.featchMovie(movieName: "TestMovie")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Then
                XCTAssertTrue(self.mockDelegate.didUpdateMovieCalled)
                XCTAssertEqual(self.viewModel.movieCount(), 1)
                let movie = self.viewModel.modelAt(0)
                XCTAssertEqual(movie.Title, "Test Movie")
                XCTAssertEqual(movie.imdbID, "test_id")
                URLProtocol.unregisterClass(URLProtocolMock.self)
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        }
    func testIsFavorite() {
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
         mockFavoritesService.saveFavorite(movie: movie)

         // When
         let isFavorite = viewModel.isFavourite(imdbId: "test_id")
         
         // Then
         XCTAssertTrue(isFavorite)
     }

    func testClearAllResults() {
        // Given
        viewModel.moviesArray = [
            Movies(
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
        ]
        
        // When
        viewModel.clearAllResult()
        
        // Then
        XCTAssertTrue(viewModel.moviesArray.isEmpty)
    }
}
