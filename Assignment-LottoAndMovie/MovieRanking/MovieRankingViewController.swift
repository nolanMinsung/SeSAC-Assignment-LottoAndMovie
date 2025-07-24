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
        updateMovieRankingData()
        view.endEditing(true)
    }
    
}


// 뷰 업데이트 관련
extension MovieRankingViewController {
    
    func updateMovieRankingData() {
        fetchMovieRankingData { [weak self] result in
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
        updateMovieRankingData()
        searchTextField.resignFirstResponder()
        return true
    }
    
}


// 네트워크 통신
extension MovieRankingViewController {
    
    /// 영화 순위 정보를 비동기적으로 받아오는 함수. 영화 정보는 `MovieModel` 타입이다.
    /// - Parameters:
    ///   - date: 영화 순위를 알고 싶은 날짜의 `Date` 인스턴스. 기본값으로 조회 시점보다 하루 전(어제)의 값이 들어감.
    ///   - completion: 콜백함수입니다~
    func fetchMovieRankingData(
        date: Date = Date.now.addingTimeInterval(-3600 * 24),
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
