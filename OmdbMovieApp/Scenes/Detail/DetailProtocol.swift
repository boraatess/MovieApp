//
//  DetailProtocol.swift
//  OmdbMovieApp
//
//  Created by bora on 6.09.2021.
//

import UIKit

//MARK: Router
protocol DetailRouterProtocol: class {
    func showMovieDetail(withId: String)
}

//MARK: Presenter
protocol DetailPresenterProtocol: class {
    var interactor: DetailInteractorInputProtocol! { get set }
    func viewDidLoad()
}

//MARK: Interactor

// Interactor -> Presenter
protocol DetailInteractorOutputProtocol: class {
    func selectedMovieDetailResponse(movieDetailResponse: MovieDetails)
    func errorResponse(error: Error)
}

// Presenter -> Interactor
protocol DetailInteractorInputProtocol: class {
    var presenter: DetailInteractorOutputProtocol! { get set }
    func fetchSelectedMovieDetails(id: String)
}

//MARK: View
protocol DetailViewProtocol: class {
    var presenter: DetailPresenterProtocol! { get set }
    func selectedMovieDetail(movieDetail: MovieDetails)
    func showError(descriptiom: String)
}
