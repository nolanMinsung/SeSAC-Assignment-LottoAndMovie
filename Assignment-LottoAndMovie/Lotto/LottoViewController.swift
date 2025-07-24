//
//  LottoViewController.swift
//  Assignment-LottoAndMovie
//
//  Created by 김민성 on 7/23/25.
//

import UIKit

class LottoViewController: UIViewController {
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 20)
        textField.textAlignment = .center
        return textField
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "당첨번호 안내"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.text = "0000-00-00 추첨"
        label.textAlignment = .right
        label.textColor = .label
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        return view
    }()
    
    private let mainTextLabel: UILabel = {
        let label = UILabel()
        label.text = "000회 당첨결과"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let lottoNumberStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [
            // 아래 숫자들은 초기 더미 데이터에 해당.
            LottoNumberBall(number: 6),
            LottoNumberBall(number: 14),
            LottoNumberBall(number: 16),
            LottoNumberBall(number: 21),
            LottoNumberBall(number: 27),
            LottoNumberBall(number: 37),
            LottoNumberBall(string: "+"),
            LottoNumberBall(number: 40),
        ])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 7
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupViewHierarchy()
        setupLayoutConstraints()
        setTextFieldInputView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let lottoBallSideLength = lottoNumberStackView.frame.height
        lottoNumberStackView.arrangedSubviews.forEach { lottoBall in
            lottoBall.layer.cornerRadius = lottoBallSideLength/2
            lottoBall.clipsToBounds = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setMainTextAttribute(number: 1181)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
}


// Initial Settings
private extension LottoViewController {
    
    func setupViewHierarchy() {
        [
            textField,
            titleLabel,
            dateLabel,
            separator,
            mainTextLabel,
            lottoNumberStackView,
        ].forEach { view.addSubview($0) }
    }
    
    func setupLayoutConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(separator.snp.top).offset(-12)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(80)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(1)
        }
        
        mainTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(40)
        }
        
        lottoNumberStackView.snp.makeConstraints { make in
            make.top.equalTo(mainTextLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        lottoNumberStackView.arrangedSubviews.forEach { lottoBall in
            lottoBall.snp.makeConstraints { make in
                make.width.equalTo(lottoBall.snp.height)
            }
        }
    }
    
    func setTextFieldInputView() {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        textField.inputView = pickerView
    }
    
    func setMainTextAttribute(number: Int) {
        let justString = "\(number)회 당첨결과"
        let attributedText = NSMutableAttributedString(string: justString)
        attributedText.addAttributes(
            [.foregroundColor: UIColor.systemYellow],
            range: (justString as NSString).range(of: "\(number)회")
        )
        mainTextLabel.attributedText = attributedText
    }
    
}


// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension LottoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1181
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedNumber = row + 1
        textField.text = "\(selectedNumber)"
        setMainTextAttribute(number: selectedNumber)
        LottoNetworkManager.shared.fetchLottoResult(drawNumber: selectedNumber) { [weak self] result in
            switch result {
            case .success(let lottoResultModel):
                self?.configureLottoBalls(lottoResultModel)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
}


// 뷰 업데이트 관련
extension LottoViewController {
    
    // view로 분리할 경우 view 자체의 메서드로 두는 것이 좋을 듯.
    func configureLottoBalls(_ resultModel: LottoResultModel) {
        let numbers = resultModel.numbers
        for i in 0..<7 {
            let lottoBallIndex = i < 6 ? i : i + 1
            guard let lottoBall = lottoNumberStackView.arrangedSubviews[lottoBallIndex] as? LottoNumberBall else { continue }
            lottoBall.setNumber(numbers[i])
        }
    }
    
}
