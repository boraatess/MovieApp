//
//  DetailRouter.swift
//  OmdbMovieApp
//
//  Created by bora on 2.09.2021.
//

import Foundation
import UIKit

class DetailRouter {
    let screen = UIScreen.main.bounds
    
    var view = DetailViewController()
    func prepareView(movieID: String) ->  UIViewController {
        view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.movieID = movieID
        
        return view
        
    }

}
