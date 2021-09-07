//
//  DetailViewController.swift
//  OmdbMovieApp
//
//  Created by bora on 2.09.2021.
//

import UIKit
import Kingfisher
import SnapKit
import FirebaseAnalytics

class DetailViewController: UIViewController {
    
    let service = Services()
    var movieDetails: MovieDetails?
    let screen = UIScreen.main.bounds
    var movieID: String?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private let viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.sizeToFit()
        return iv
    }()
    
    private let ratingIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.sizeToFit()
        iv.image = #imageLiteral(resourceName: "imdb")
        iv.isHidden = true
        return iv
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = UIColor(white: 0, alpha: 0.8)
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.text = "Movie Details"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        getMovieDetails()
        self.layout()
        setupNavbar()
        
    }
    
    func setupNavbar() {
        if self.traitCollection.userInterfaceStyle == .dark {
            titleLabel.textColor = .white
        }
        else {
            
        }
        navigationItem.titleView = titleLabel
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if screen.height > 800 {
            scrollView.contentSize = CGSize(width: screen.width, height: screen.height*1.25)
        }
        else {
            scrollView.contentSize = CGSize(width: screen.width, height: screen.height*1.5)
        }
    }
    
    private func getMovieDetails() {
        // tt0094712
        self.showHUD(progressLabel: "")
        service.getMovieDetails(id: movieID ?? "") { [weak self] (response) in
            print(response)
            self?.movieDetails = response
            let details = self?.movieDetails
            let url = URL(string: self?.movieDetails?.poster ?? "")
            self?.imageView.kf.setImage(with: url)
            
            self?.detailLabel.text = "Title : \(details?.title ?? "") \n Year: \(details?.released ?? "")"+"\n Run time :\(details?.runtime ?? "") \n Genre: \(details?.genre ?? "") \n Director: \(details?.director ?? "") \n Writer: \(details?.writer ?? "") \n Actors: \(details?.actors ?? "") \n Explain: \(details?.plot ?? "") \n Total Box Office: \(details?.boxOffice ?? "") \n Production: \(details?.production ?? "") \n Type: \(details?.type ?? "")"
            self?.ratingIV.isHidden = false
            self?.ratingLabel.text = details?.imdbRating
            self?.dismissHUD(isAnimated: true)
            
        }
    }
    
    func fetchAnalytics() {
        Analytics.logEvent("movie_detail", parameters: ["value" : movieDetails])
        
    }
    
}

extension DetailViewController {
    private func layout() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        scrollView.addSubview(viewContent)
        viewContent.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.width.equalTo(UIScreen.main.bounds.width)
            maker.centerX.equalToSuperview()
        }
        
        viewContent.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(100)
            maker.height.equalTo(screen.width)
            maker.bottom.equalTo(screen.width-screen.height)
        }
        
        viewContent.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().inset(16)
            maker.top.equalTo(self.imageView.snp.bottom).offset(120)
        }
        
        viewContent.addSubview(ratingIV)
        ratingIV.snp.makeConstraints { (maker) in
            maker.height.equalTo(20)
            maker.width.equalTo(60)
            maker.top.equalTo(self.detailLabel.snp.bottom).offset(25)
            
        }
        
        viewContent.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.detailLabel.snp.bottom).offset(25)
            maker.leading.equalToSuperview().offset(65)
            
        }
        
    }
    
}
