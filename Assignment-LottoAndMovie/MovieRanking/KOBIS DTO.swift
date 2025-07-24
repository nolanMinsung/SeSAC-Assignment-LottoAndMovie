//
//  KOBIS DTO.swift
//  Assignment-LottoAndMovie
//
//  Created by 김민성 on 7/24/25.
//

import Foundation


struct KOBISBoxOfficeDTO: Decodable {
    let boxOfficeResult: BoxOfficeResultDTO
}

struct BoxOfficeResultDTO: Decodable {
    let boxofficeType: String
    let showRange: String
    let dailyBoxOfficeList: [MovieDTO]
}

struct MovieDTO: Decodable {
    let rnum: String
    let rank: String
    let rankInten: String
    let rankOldAndNew: String
    let movieCd: String
    let movieNm: String
    let openDt: String
    let salesAmt: String
    let salesShare: String
    let salesInten: String
    let salesChange: String
    let salesAcc: String
    let audiCnt: String
    let audiInten: String
    let audiChange: String
    let audiAcc: String
    let scrnCnt: String
    let showCnt: String
}
