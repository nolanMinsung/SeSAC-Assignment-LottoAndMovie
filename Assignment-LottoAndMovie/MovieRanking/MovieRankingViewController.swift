//
//  MovieRankingViewController.swift
//  Assignment-LottoAndMovie
//
//  Created by 김민성 on 7/23/25.
//

import UIKit

import SnapKit

class MovieRankingViewController: UIViewController {
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 18)
        textField.textColor = .white
        return textField
    }()
    
    let textFieldUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .white
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 45
        tableView.keyboardDismissMode = .onDrag
        tableView.register(MovieRankingTableViewCell.self, forCellReuseIdentifier: "MovieRankingTableViewCell")
        return tableView
    }()
    
    var movies: [MovieModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupViewHierarchy()
        setupLayoutConstraints()
        setupDelegates()
        setupActions()
        updateMovieRankingData()
    }
    
}


// Initial Settings
private extension MovieRankingViewController {
    
    func setupDelegates() {
        tableView.dataSource = self
        searchTextField.delegate = self
    }
    
    func setupViewHierarchy() {
        view.addSubview(searchTextField)
        view.addSubview(textFieldUnderLine)
        view.addSubview(searchButton)
        view.addSubview(tableView)
    }
    
    
    func setupLayoutConstraints() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        textFieldUnderLine.snp.makeConstraints { make in
            make.bottom.equalTo(searchButton)
            make.horizontalEdges.equalTo(searchTextField)
            make.height.equalTo(4)
        }
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField)
            make.leading.equalTo(searchTextField.snp.trailing).offset(20)
            make.bottom.equalTo(textFieldUnderLine)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textFieldUnderLine.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func setupActions() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    @objc func searchButtonTapped() {
        doSearch()
        view.endEditing(true)
    }
    
}


// 뷰 업데이트 관련
private extension MovieRankingViewController {
    
    /// 검색창에 입력된 데이터를 바탕으로 영화 순위 검색.
    func doSearch() {
        let trimmedSearchText = searchTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        guard !trimmedSearchText.isEmpty else { return }
        guard let date = dateFormatter.date(from: trimmedSearchText) else {
            alert(message: "유효하지 않은 날짜 형식입니다.\n검색할 수가 업슴니다. \nyyyyMMdd 형식으로 검색 부탁드려요. 🙏")
            return
        }
        updateMovieRankingData(date: date)
    }
    
    /// 특정 날짜(Date)의 영화 순위 정보를 받아와 화면의 띄우는 함수.
    /// - Parameter date: 순위를 알고 싶은 날짜 정보.
    func updateMovieRankingData(date: Date = Date.now.addingTimeInterval(-3600 * 24)) {
        fetchMovieRankingData(date: date) { [weak self] result in
            switch result {
            case .success(let fetchedMovieModels):
                self?.movies = fetchedMovieModels
                self?.tableView.reloadData()
            case .failure(let error):
                self?.alert(message: error.localizedDescription)
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
}


// MARK: - UITableViewDataSource
extension MovieRankingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieRankingTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! MovieRankingTableViewCell
        cell.configure(with: movies[indexPath.row], ranking: indexPath.row + 1)
        return cell
    }
    
}


// MARK: - UITextFieldDelegate
extension MovieRankingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doSearch()
        searchTextField.resignFirstResponder()
        return true
    }
    
}


// 네트워크 통신
extension MovieRankingViewController {
    
    /// 영화 순위 정보를 비동기적으로 받아오는 함수. 영화 정보는 `MovieModel` 타입이다.
    /// - Parameters:
    ///   - date: 영화 순위를 알고 싶은 날짜의 `Date` 인스턴스.
    ///   - completion: 콜백함수입니다~
    func fetchMovieRankingData(
        date: Date,
        completion: @escaping (Result<[MovieModel], Error>) -> Void
    ) {
        MovieNetworkManager.shard.requestMovieRanking(date: date) { result in
            switch result {
            case .success(let movieModels):
                completion(.success(movieModels))
            case .failure(let error):
                completion(.failure(error))
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: "에러 발생", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}
