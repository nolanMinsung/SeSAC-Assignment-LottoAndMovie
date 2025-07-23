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
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.text = "엽문4: 더 파이널"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2020-04-01"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
            make.leading.verticalEdges.equalToSuperview().inset(10)
            make.width.equalTo(44)
            make.height.equalTo(60)
        }
        
        movieNameLabel.setContentHuggingPriority(.init(749), for: .horizontal)
        movieNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(rankingNumberLabel.snp.trailing).offset(30)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.verticalEdges.trailing.equalToSuperview().inset(10)
        }
    }
    
}


extension MovieRankingTableViewCell {
    
    
    
}
