//
//  Services.swift
//  OmdbMovieApp
//
//  Created by bora on 2.09.2021.
//

import Foundation
import Alamofire
import AlamofireMapper

class Services {
 
    public var baseUrl = Bundle.main.object(forInfoDictionaryKey: "ApiUrl") as! String
    
    var isPaginating: Bool = false

    //MARK:- getSearchMovieResults
    public func getMovieList(pagination: Bool = false, page: String,
                                      successCompletion: @escaping ((_ json : SearchResultsModel) -> Void)) {
        if pagination {
            isPaginating = true
        }
        let url = baseUrl+"&s=All&type=movie&page="+page
        print(url)
        
        Alamofire.request(url, method: .get, parameters: nil).responseObject { (response : DataResponse<SearchResultsModel>) in
            switch response.result {
            case .success(let json):
                successCompletion(json)
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            if pagination {
                self.isPaginating = false
            }
        }
    }
    
    //MARK:- getSearchMovieResults
    public func getSearchMovieResults(params: String, successCompletion: @escaping ((_ json : SearchResultsModel) -> Void)) {
        let url = baseUrl+"&type=movie&page=1&s="+params
        print(url)
        if url.verifyUrl(urlString: url) {
            Alamofire.request(url, method: .get, parameters: nil).responseObject { (response : DataResponse<SearchResultsModel>) in
                switch response.result {
                case .success(let json):
                    successCompletion(json)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
       
    }
    
    //MARK:- getMovieDetails
    public func getMovieDetails(id: String, successCompletion: @escaping ((_ json : MovieDetails) -> Void)) {
        let url = baseUrl+"&i="+id
        print(url)
        Alamofire.request(url, method: .get, parameters: nil).responseObject { (response : DataResponse<MovieDetails>) in
            switch response.result {
            case .success(let json):
                successCompletion(json)
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
           
        }
    }
    
}
