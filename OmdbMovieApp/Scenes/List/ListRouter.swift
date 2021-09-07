//
//  ListRouter.swift
//  OmdbMovieApp
//
//  Created by bora on 2.09.2021.
//

import UIKit

class ListRouter {
    
    internal var controller: ListViewController!
    internal var presenter: ListPresenter!
    internal var interactor: ListInteractor!
    
    init() {
        interactor = ListInteractor()
        presenter = ListPresenter()
        controller = ListViewController()

        
    }
    
    let screen = UIScreen.main.bounds
    
    var view = ListViewController()
    func prepareView() ->  UIViewController {
        view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let label = UILabel(frame: CGRect(x: screen.width/2, y: 0, width: screen.width, height: 44))
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        self.view.navigationItem.titleView = label
        return view
    }
}
