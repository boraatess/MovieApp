//
//  NetworkManager.swift
//  OmdbMovieApp
//
//  Created by bora on 6.09.2021.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init(){ }
    
    var manager = NetworkReachabilityManager(host: "www.apple.com")
    fileprivate let isReachable = true
    
    func startMonitoring() {
        
        
    }
    
}
