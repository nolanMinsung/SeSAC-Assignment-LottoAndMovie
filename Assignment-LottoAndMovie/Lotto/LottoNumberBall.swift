//
//  LottoNumberBall.swift
//  Assignment-LottoAndMovie
//
//  Created by 김민성 on 7/23/25.
//

import UIKit

import SnapKit

final class LottoNumberBall: UIView {
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemOrange
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    convenience init(number: Int) {
        self.init()
        label.text = "\(number)"
        label.textColor = .white
        setBackgroundColor(number)
    }
    
    convenience init(string: String) {
        self.init()
        label.text = string
        label.textColor = .label
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNumber(_ number: Int) {
        label.text = "\(max(1, min(45, number)))"
        setBackgroundColor(number)
    }
    
    // 숫자에 따라 색이 결정됨.
    private func setBackgroundColor(_ number: Int) {
        switch ((number-1) / 10) {
        case 0:
            backgroundColor = .systemYellow
        case 1:
            backgroundColor = .systemTeal
        case 2:
            backgroundColor = .systemRed
        case 3:
            backgroundColor = .systemGray
        default:
            backgroundColor = .systemPurple
        }
    }
    
}
