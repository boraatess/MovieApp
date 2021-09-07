//
//  DetailPresenter.swift
//  OmdbMovieApp
//
//  Created by bora on 5.09.2021.
//

import Foundation

class DetailPresenter: NSObject {
    
    var view: DetailViewProtocol!
    var interactor: DetailInteractorInputProtocol!
    var router: DetailRouterProtocol!
    
    private let movieId: String
    private var movieDetailResponse: MovieDetails?
    
    init(movieId: String) {
        self.movieId = movieId
        super.init()

    }

}

extension DetailPresenter: DetailPresenterProtocol {
    
    func viewDidLoad() {
        interactor.fetchSelectedMovieDetails(id: movieId)
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func selectedMovieDetailResponse(movieDetailResponse: MovieDetails) {
        view.selectedMovieDetail(movieDetail: movieDetailResponse)
    }
    
    func errorResponse(error: Error) {
        view.showError(descriptiom: error.localizedDescription)
    }
    
}
