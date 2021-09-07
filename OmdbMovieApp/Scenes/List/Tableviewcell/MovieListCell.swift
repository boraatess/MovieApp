//
//  MovieListCell.swift
//  OmdbMovieApp
//
//  Created by bora on 4.09.2021.
//

import UIKit
import Kingfisher

class MovieListCell: UITableViewCell {

    private let imageViewCover: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let labelYear: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
        if self.traitCollection.userInterfaceStyle == .dark {
            labelYear.textColor = UIColor.white
        }
        else {
            // labelYear.textColor = UIColor(white: 0, alpha: 0.6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(movie: Search) {
        let url = URL(string: movie.poster)
        imageViewCover.kf.setImage(with: url)
        labelTitle.text = movie.title
        labelYear.text = movie.year
    }
    
    private func layout() {
        addSubview(imageViewCover)
        imageViewCover.snp.makeConstraints{ (maker) in
            maker.height.width.equalTo(100)
            maker.leading.equalToSuperview().offset(16)
            maker.bottom.equalToSuperview().inset(10)
            maker.top.equalToSuperview().offset(10)
        }

        addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.imageViewCover.snp.trailing).offset(10)
            maker.top.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().inset(22)
            maker.height.equalTo(20)
        }
        
        addSubview(labelYear)
        labelYear.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.imageViewCover.snp.trailing).offset(10)
            maker.trailing.equalToSuperview().inset(22)
            maker.top.equalTo(self.labelTitle.snp.bottom).offset(5)
            maker.bottom.equalToSuperview().inset(25)
        }
        
    }

}
