#  MoviesDb ReadMe - 

MoviesDb is an iOS application that allows users to search for movies using the OMDb API, view details about each movie, and manage a list of favorite movies. The app utilizes the Model-View-ViewModel (MVVM) design pattern and demonstrates usage of various iOS frameworks and features, including URLSession for networking, UserDefaults for local storage, and UITableView for displaying data.


##Features -

Movie Search: 
Search for movies by title and view search results.
Movie Details:
View detailed information about a selected movie, including plot, genre, director, and cast.
Favorites: 
Add and remove movies from a list of favorites, stored persistently using UserDefaults.
UI Integration: 
Includes UITableView with sections for favorites and search results, and handles keyboard dismissal when tapping outside of input fields.


##Architecture - 

MVVM Pattern: 
Separates concerns into Model, View, and ViewModel.
Networking: 
Handles API requests and responses through a NetworkingClient protocol and a concrete NetworkManager.
Persistence: 
Manages favorite movies using UserDefaults through the FavoritesService class.


##Usage - 

Search Movies:
Enter a movie title into the search bar and press return to fetch and display results.
View Movie Details:
Tap on a movie from the search results to view detailed information.
Manage Favorites:
Use the favorite button in the table view cells to add or remove movies from your favorites list.
Dismiss Keyboard:
Tap outside the search bar to dismiss the keyboard.


##Unit Testing

The project includes unit tests for:

MovieSearchViewModel: 
Testing search functionality and handling of favorite movies.
MovieDetailsViewModel: 
Testing movie details fetching and error handling.
UITableView Sections: 
Ensuring correct setup and data handling in table view sections.
To run the tests:

Open Xcode.
Select the Test Navigator (⌘ + 6).
Run Tests: Click the play button next to the test target.
