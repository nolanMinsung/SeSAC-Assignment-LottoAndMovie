//
//  MovieNetworkManager.swift
//  Assignment-LottoAndMovie
//
//  Created by 김민성 on 7/24/25.
//

import Foundation

import Alamofire

// 일일 박스오피스 API로 한정
class MovieNetworkManager {
    
    static let shard = MovieNetworkManager()
    private init() { }
    
    enum MovieNetworkManagerError: Error {
        case invalidURLFormat
    }
    
    enum QueryParameter: String {
        case key
        case targetDt
        case itemPerPage
        case multiMovieYn
        case repNationCd
        case wideAreaCd
    }
    
    /// - Note: 아래 값들은 `Github` 등에 공유되면 안 되는 민감한 정보일 수 있으므로,
    /// 실제로는 `.gitignore`에 추가된 `.xcconfig` 등에서 가져오는 것으로 구현
    let apiKey: String = "2150b2f3ee5962f8f030f0311f9eb787"
    let baseUrlString = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
    
    func requestMovieRanking(
        date: Date,
        completion: @escaping (Result<[MovieModel], Error>) -> Void
    ) {
        let targetDate = self.getTargetDate(from: date)
        let queries: [QueryParameter: String] = [.key: apiKey, .targetDt: targetDate]
        do {
            let url = try makeURLWithQueryParameters(baseURLString: baseUrlString, parameters: queries)
            AF
                .request(url, method: .get)
                .responseDecodable(of: [MovieModel].self) { response in
                    switch response.result {
                    case .success(let movieModels):
                        completion(.success(movieModels))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        } catch let error {
            completion(.failure(error))
        }
    }
    
}


extension MovieNetworkManager {
    
    /// `Swift`의 `Date` 타입을 이용하여 영화진흥위원회의 '일별 박스오피스' OPEN API 중 `targetDt`에 해당하는 쿼리 파라미터로 변환하는 함수.
    /// - Parameter date: 변환할 `Date` 타입의 인스턴스
    /// - Returns: OPEN API 의 쿼리 파라미터에 사용될 문자열 형식의 날짜 정보.
    func getTargetDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: date)
    }
    
    
    func makeURLWithQueryParameters(baseURLString: String, parameters: [QueryParameter: String]) throws -> URL {
        var urlString = baseURLString
        urlString += "?"
        for (key, value) in parameters {
            let parameterString = "\(key.rawValue)=\(value)"
            urlString += parameterString
        }
        guard let url = URL(string: urlString) else {
            throw MovieNetworkManagerError.invalidURLFormat
        }
        return url
    }
    
}
