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
        textField.tintColor = .label
        return textField
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "당첨번호 안내"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
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
            LottoNumberBall(number: 00),
            LottoNumberBall(number: 00),
            LottoNumberBall(number: 00),
            LottoNumberBall(number: 00),
            LottoNumberBall(number: 00),
            LottoNumberBall(number: 00),
            LottoNumberBall(string: "+"),
            LottoNumberBall(number: 00),
        ])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 7
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var latestDrawNumber = getLatestLottoDrawNumber()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupViewHierarchy()
        setupLayoutConstraints()
        setTextFieldInputView()
        LottoNetworkManager.shared.fetchLottoResult(drawNumber: latestDrawNumber) { [weak self] result in
            switch result {
            case .success(let lottoResultModel):
                self?.configureLottoBalls(lottoResultModel)
            case .failure(let error):
                self?.alert(message: "문제가 발생했네요.\n\(error.localizedDescription)")
                assertionFailure(error.localizedDescription)
            }
        }
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
        return latestDrawNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(latestDrawNumber - row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedNumber = latestDrawNumber - row
        textField.text = "\(selectedNumber)"
        setMainTextAttribute(number: selectedNumber)
        LottoNetworkManager.shared.fetchLottoResult(drawNumber: selectedNumber) { [weak self] result in
            switch result {
            case .success(let lottoResultModel):
                self?.configureLottoBalls(lottoResultModel)
            case .failure(let error):
                self?.alert(message: "문제가 발생했네요.\n\(error.localizedDescription)")
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
}


// 뷰 업데이트 관련
extension LottoViewController {
    
    // view로 분리할 경우 view 자체의 메서드로 두는 것이 좋을 듯.
    func configureLottoBalls(_ resultModel: LottoResultModel) {
        
        // 로또 공을 채워보자.
        let numbers = resultModel.numbers
        for i in 0..<7 {
            let lottoBallIndex = i < 6 ? i : i + 1
            guard let lottoBall = lottoNumberStackView.arrangedSubviews[lottoBallIndex] as? LottoNumberBall else { continue }
            lottoBall.setNumber(numbers[i])
        }
        
        // 날짜를 표시해 주자.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = "\(formatter.string(from: resultModel.drawDate)) 추첨"
    }
    
}


extension LottoViewController {
    
    /// 가장 최신 로또 회차를 반환하는 함수.
    /// - Returns: 함수를 호출하는 시점을 기준으로 가장 최신 로또 회차.
    func getLatestLottoDrawNumber() -> Int {
        // 0001회차: 2002년 12월 07일
        // 1181회차: 2025년 07월 19일
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let firstDrawDate = formatter.date(from: "20021207")!
        
        guard let koreaTimeZone = TimeZone(identifier: "Asia/Seoul") else {
            fatalError("TimeZone identifier에 Seoul이 없다고?")
        }
        let currentDateComponent = calendar.dateComponents(in: koreaTimeZone, from: .now)
        // 아래 코드에서 강제 언래핑하였는데,
        // dateComponents(in:from:) 메서드의 반환값은 모든 component들을 포함하기 때문.
        let hour = currentDateComponent.hour!
        let minute = currentDateComponent.minute!
        
        // 토요일일 경우, 로또 추첨 여부에 따라 회차가 달라질 수 있음. 함수 호출 시각이 로또 추첨 시각보다 지났는지 여부를 확인.
        let isDrawTimePassed: Bool = {
            guard hour > 20 else {
                return false
            }
            // 8시 xx분이면 8시 40분을 넘겼는지 확인.
            // 9시 이후면 무조건 true
            // 실제로 35분 전후로 뽑는데, 넉넉하게 5분 여유 잡아서 40분 기준으로 구현
            return (hour == 20) ? (minute >= 40) : true
        }()
        let dateDiffInDay: Int = calendar.dateComponents([.day], from: firstDrawDate, to: .now).day!
        
        if dateDiffInDay % 7 == 0 {
            // 토요일인 경우
            // 로또 추첨 시간이 지났는지 여부에 따라 달라짐.
            return isDrawTimePassed ? dateDiffInDay/7 + 1 : dateDiffInDay/7
        } else {
            // 토요일이 아닌 경우
            // 그냥 7로 나눈 몫 + 1
            return dateDiffInDay / 7 + 1
        }
    }
    
}
