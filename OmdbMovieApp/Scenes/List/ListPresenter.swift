//
//  ListPresenter.swift
//  OmdbMovieApp
//
//  Created by bora on 5.09.2021.
//

import Foundation

class ListPresenter: NSObject {
    
    var view: ListViewProtocol!
    var interactor: ListInteractorInputProtocol!
    var router: ListRouterProtocol!
  
    private var movieListResponse: SearchResultsModel?
    private var searchedMoviewResponse: SearchResultsModel?
}

extension ListPresenter: ListPresenterProtocol {
    func selectedMovieListIndex(index: IndexPath) {
        guard let movieID = movieListResponse?.search?[index.row].imdbID else { return }
        router.showMovieDetail(withId: movieID)
    }
    
    func selectedSearchedMovieIndex(index: IndexPath) {
        guard let movieId = movieListResponse?.search?[index.row].imdbID else { return }
        router.showMovieDetail(withId: movieId)
    }
    
    func showMovieDetail(withId: String) {
        router.showMovieDetail(withId: withId)
    }
    
    func viewDidLoad() {
        interactor.fetchMoviesList()
    }

    func searchedMovie(movieName: String) {
        movieName.count > 2 ? interactor.fetchSearchedMovie(movieName: movieName) : view.searchedMovieResponse(response: [])
    }
}

extension ListPresenter: ListInteractorOutputProtocol {
    func MovieListResponse(movieList: SearchResultsModel) {
        guard let movieListResponse = movieList.search else { return }
        self.movieListResponse = movieList
        view.MovieListResponse(movieList: movieListResponse)
    }
    
    func searchedMovieResponse(response: SearchResultsModel) {
        guard let searhResults = response.search else { return }
        self.searchedMoviewResponse = response
        view.MovieListResponse(movieList: searhResults)
    }
    
    func errorResponse(error: Error) {
        view.showError(descriptiom: error.localizedDescription)
    }
    
    
}
