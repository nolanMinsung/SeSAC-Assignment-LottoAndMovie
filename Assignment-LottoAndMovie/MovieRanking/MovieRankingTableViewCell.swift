//
//  MovieRankingTableViewCell.swift
//  Assignment-LottoAndMovie
//
//  Created by 김민성 on 7/24/25.
//

import UIKit

import SnapKit

class MovieRankingTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MovieRankingTableViewCell"
    
    let rankingNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.text = "엽문4: 더 파이널"
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2020-04-01"
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        setupViewHierarchy()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// Initial Settings
private extension MovieRankingTableViewCell {
    
    func setupViewHierarchy() {
        contentView.addSubview(rankingNumberLabel)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(dateLabel)
    }
    
    func setupLayoutConstraints() {
        rankingNumberLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.leading.equalToSuperview()
            make.width.equalTo(45)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        
        movieNameLabel.setContentHuggingPriority(.init(749), for: .horizontal)
        movieNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(rankingNumberLabel.snp.trailing).offset(30)
        }
        
        dateLabel.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.verticalEdges.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(movieNameLabel.snp.trailing).offset(20)
        }
    }
    
}


extension MovieRankingTableViewCell {
    
    func configure(with movie: Movie, ranking: Int) {
        rankingNumberLabel.text = "\(ranking)"
        movieNameLabel.text = movie.title
        
        var releaseDate = movie.releaseDate
        let index1 = releaseDate.index(releaseDate.startIndex, offsetBy: 4)
        let index2 = releaseDate.index(releaseDate.startIndex, offsetBy: 6)
        
        // index2부터 넣어야 함.
        releaseDate.insert("-", at: index2)
        releaseDate.insert("-", at: index1)
        dateLabel.text = releaseDate
    }
    
}
