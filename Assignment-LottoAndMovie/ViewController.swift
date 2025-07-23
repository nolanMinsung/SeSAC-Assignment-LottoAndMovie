//
//  ViewController.swift
//  Assignment-LottoAndMovie
//
//  Created by 김민성 on 7/23/25.
//

import UIKit

import SnapKit

class ViewController: UIViewController {
    
    let lottoButton = UIButton(configuration: .tinted())
    let movieButton = UIButton(configuration: .tinted())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottoButton.configuration?.image = UIImage(systemName: "dollarsign.bank.building")
        lottoButton.configuration?.title = "로또"
        lottoButton.configuration?.subtitle = "일확천금을 노리세요?"
        lottoButton.configuration?.titlePadding = 10
        
        movieButton.configuration?.image = UIImage(systemName: "movieclapper")
        movieButton.configuration?.title = "영화"
        movieButton.configuration?.subtitle = "영화 볼 시간이 있어요?"
        movieButton.configuration?.titlePadding = 10
        
        view.addSubview(lottoButton)
        view.addSubview(movieButton)
        lottoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(200)
        }
        movieButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lottoButton.snp.bottom).offset(100)
        }
        
        
        lottoButton.addTarget(self, action: #selector(presetnLottoVC), for: .touchUpInside)
        movieButton.addTarget(self, action: #selector(presentMovieRankingVC), for: .touchUpInside)
    }
    
    @objc private func presetnLottoVC() {
        present(LottoViewController(), animated: true)
    }
    
    @objc private func presentMovieRankingVC() {
        present(MovieRankingViewController(), animated: true)
    }
    
}

