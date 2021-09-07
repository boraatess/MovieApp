//
//  LoadingAlertView.swift
//  OmdbMovieApp
//
//  Created by bora on 2.09.2021.
//

import UIKit
import NVActivityIndicatorView
import SnapKit

class LoadingView {
    
    static let shared = LoadingView()
    
    private let vc = UIViewController()
    private lazy var window: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        vc.view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        window.rootViewController = vc
        window.windowLevel = UIWindow.Level.alert + 2
        window.makeKeyAndVisible()
        window.isHidden = true
        return window
    }()
    
    init() {
        
        let loadingSubView = UIView()
        vc.view.addSubview(loadingSubView)
        loadingSubView.layer.cornerRadius = 15
        loadingSubView.backgroundColor = .lightGray
        loadingSubView.snp.makeConstraints({ (make) in
            make.height.equalTo(UIScreen.main.bounds.width*0.2)
            make.width.equalTo(UIScreen.main.bounds.width*0.2)
            make.center.equalToSuperview()
        })

        let loadingInducator = NVActivityIndicatorView(frame: .zero, type: .pacman, color: .white, padding: .none)
        loadingSubView.addSubview(loadingInducator)
        loadingInducator.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(20)
            make.bottom.trailing.equalToSuperview().inset(20)
            make.center.equalToSuperview()
        }
        loadingInducator.startAnimating()
    }
    
    func show() {
        window.isHidden = false
    }
    
    func hide() {
        window.isHidden = true
    }
}
