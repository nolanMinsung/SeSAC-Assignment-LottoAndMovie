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
    
    var movies: [Movie] = []
    
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
extension MovieRankingViewController {
    
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


extension MovieRankingViewController {
    
    func updateMovieRankingData() {
        var movieSet: Set<Movie> = []
        while movieSet.count < 11 {
            movieSet.insert(MovieInfo.movies.randomElement()!)
        }
        movies = Array(movieSet).sorted { $0.audienceCount < $1.audienceCount }
        tableView.reloadData()
    }
    
}

extension MovieRankingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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

extension MovieRankingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateMovieRankingData()
        searchTextField.resignFirstResponder()
        return true
    }
    
}
