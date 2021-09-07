//
//  ListInteractor.swift
//  OmdbMovieApp
//
//  Created by bora on 5.09.2021.
//

import Foundation

class ListInteractor {

    var presenter: ListInteractorOutputProtocol!
    
    private var listApi: Services
    
    init(listApi: Services) {
        self.listApi = listApi
    }
    
    convenience required init () {
        self.init(listApi: Services())
    }
    
}

extension ListInteractor: ListInteractorInputProtocol {
    func fetchMoviesList() {
        listApi.getMovieList(pagination: false, page: "1") { [weak self] (response) in
            self?.presenter.MovieListResponse(movieList: response)
        }
    }
    
    func fetchSearchedMovie(movieName: String) {
        let params = SearchMovieRequest(query: movieName)
        listApi.getSearchMovieResults(params: params.string) { [weak self] (response) in
            self?.presenter.searchedMovieResponse(response: response)
        }
    }
    
}

