//
//  UIViewController+.swift
//  Assignment-LottoAndMovie
//
//  Created by 김민성 on 7/24/25.
//

import UIKit

extension UIViewController {
    
    /// `alert`를 띄워보자
    /// - Parameter message: `alert` 메시지
    func alert(message: String) {
        let alertController = UIAlertController(title: "에러 발생", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}
