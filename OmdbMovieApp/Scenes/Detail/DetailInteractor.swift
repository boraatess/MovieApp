//
//  DetailInteractor.swift
//  OmdbMovieApp
//
//  Created by bora on 5.09.2021.
//

import Foundation

class DetailInteractor {
    var presenter: DetailInteractorOutputProtocol!
    private let detailApi: Services

    init(detailApi: Services) {
        self.detailApi = detailApi
    }
    
    convenience required init () {
        self.init(detailApi: Services())
    }
}

extension DetailInteractor: DetailInteractorInputProtocol {
    func fetchSelectedMovieDetails(id: String) {
        detailApi.getMovieDetails(id: id) { [weak self] (response) in
            print(response)
            self?.presenter.selectedMovieDetailResponse(movieDetailResponse: response)
        }
    }

}
