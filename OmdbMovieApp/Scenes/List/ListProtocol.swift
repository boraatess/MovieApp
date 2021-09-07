//
//  ListProtocol.swift
//  OmdbMovieApp
//
//  Created by bora on 6.09.2021.
//

import UIKit

//MARK: Router
protocol ListRouterProtocol: class {
    func showMovieDetail(withId: String)
}

//MARK: Presenter

protocol ListPresenterProtocol: class {
    var interactor: ListInteractorInputProtocol! { get set }
    func searchedMovie(movieName: String)
    func viewDidLoad()
    func selectedMovieListIndex(index: IndexPath)
    func selectedSearchedMovieIndex(index: IndexPath)
}

//MARK: Interactor

// Interactor -> Presenter
protocol ListInteractorOutputProtocol: class {
    func MovieListResponse(movieList: SearchResultsModel)
    func searchedMovieResponse(response: SearchResultsModel)
    func errorResponse(error: Error)
}

// Presenter -> Interactor

protocol ListInteractorInputProtocol: class {
    var presenter: ListInteractorOutputProtocol! { get set }
    func fetchMoviesList()
    func fetchSearchedMovie(movieName: String)
}

//MARK: View
protocol ListViewProtocol: class {
    var presenter: ListPresenterProtocol! { get set }
    func MovieListResponse(movieList: [Search])
    func searchedMovieResponse(response: [Search])
    func showError(descriptiom: String)
}
