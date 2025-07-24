//
//  MovieModel.swift
//  Assignment-LottoAndMovie
//
//  Created by 김민성 on 7/24/25.
//

import Foundation


enum MovieModelError: Error {
    case rankNotInt
    case dtoDateFormatError
}

/// 랭킹에 신규 진입 여부를 나타내는 타입.
enum RankOldNew: String {
    /// 랭킹에 기존에 존재하던 경우
    case old = "OLD"
    /// 랭킹에 신규로 진입한 경우
    case new = "NEW"
}

struct MovieModel: Decodable {
    /*
    /// 순번
    let rnum: Int
     */
    
    /// 박스오피스 순위
    let rank: Int
    
    /*
    /// 전일 대비 순위의 증감분
    let rankInten: Int
    /// 랭킹에 신규 진입 여부
    let rankOldAndNew: RankOldNew
    /// 영화의 대표 코드
    let movieCd: Int
     */
    
    /// 영화명(국문)
    let movieNm: String
    /// 영화의 개봉일
    let openDt: Date
    
    /*
    /// 해당일의 매출액
    let salesAmt: String
    /// 해당일자 상영작의 매출총액 대비 해당 영화의 매출비율
    let salesShare: String
    /// 전일 대비 매출액 증감분
    let salesInten: String
    /// 전일 대비 매출액 증감 비율
    let salesChange: String
    /// 누적매출액
    let salesAcc: String
    /// 해당일의 관객수
    let audiCnt: String
    /// 전일 대비 관객수 증감분
    let audiInten: String
    /// 전일 대비 관객수 증감 비율
    let audiChange: String
    /// 누적관객수
    let audiAcc: String
    /// 해당일자에 상영한 스크린수
    let scrnCnt: String
    /// 해당일자에 상영된 횟수
    let showCnt: String
     */
    
    init(from dto: MovieDTO) throws {
        guard let rank = Int(dto.rank) else {
            throw MovieModelError.rankNotInt
        }
        self.rank = rank
        self.movieNm = dto.movieNm
        
        let openDateFormat: String = "yyyy-MM-dd"
        let formatter = DateFormatter()
        formatter.dateFormat = openDateFormat
        guard let openDate = formatter.date(from: dto.openDt) else {
            throw MovieModelError.dtoDateFormatError
        }
        self.openDt = openDate
    }
    
}
