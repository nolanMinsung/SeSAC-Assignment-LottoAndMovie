//
//  LottoNetworkManager.swift
//  Assignment-LottoAndMovie
//
//  Created by 김민성 on 7/24/25.
//

import Foundation

import Alamofire
/**
https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=1181
 */


final class LottoNetworkManager {
    
    static let shared = LottoNetworkManager()
    private init() { }
    
    /// - Note: 아래 값들은 `Github` 등에 공유되면 안 되는 민감한 정보일 수 있으므로,
    /// 실제로는 `.gitignore`에 추가된 `.xcconfig` 등에서 가져오는 것으로 구현
    let baseUrlString = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber"
        
}


extension LottoNetworkManager {
    
    func fetchLottoResult(
        drawNumber: Int,
        completion: @escaping (Result<LottoResultModel, Error>) -> Void
    ) {
        let parameters: [String: String] = ["drwNo": "\(drawNumber)"]
        AF.request(baseUrlString, method: .get, parameters: parameters)
            .responseDecodable(of: LottoResultDTO.self) { result in
                let result = result.result
                switch result {
                case .success(let lottoResultDTO):
                    do {
                        let lottoResultModel = try LottoResultModel.from(dto: lottoResultDTO)
                        completion(.success(lottoResultModel))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
