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
    let moviewButton = UIButton(configuration: .tinted())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottoButton.configuration?.image = UIImage(systemName: "dollarsign.bank.building")
        lottoButton.configuration?.title = "로또"
        lottoButton.configuration?.subtitle = "일확천금을 노리세요?"
        lottoButton.configuration?.titlePadding = 10
        
        moviewButton.configuration?.image = UIImage(systemName: "movieclapper")
        moviewButton.configuration?.title = "영화"
        moviewButton.configuration?.subtitle = "영화 볼 시간이 있어요?"
        moviewButton.configuration?.titlePadding = 10
        
        view.addSubview(lottoButton)
        view.addSubview(moviewButton)
        lottoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(200)
        }
        moviewButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lottoButton.snp.bottom).offset(100)
        }
    }
    
    
}

