//
//  LottoResultModel.swift
//  Assignment-LottoAndMovie
//
//  Created by 김민성 on 7/24/25.
//

import Foundation

struct LottoResultModel {
    
    enum LottoResultModelError: LocalizedError {
        case invalidDTODateFormat(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidDTODateFormat(let string):
                "LottoModelDTO의 drawDate 속성의 날짜 형식이 유효하지 않습니다. drawDate: \(string)"
            }
        }
    }
    
    static func from(dto: LottoResultDTO) throws -> LottoResultModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let drawDate = formatter.date(from: dto.drwNoDate) else {
            throw LottoResultModelError.invalidDTODateFormat(dto.drwNoDate)
        }
        
        return LottoResultModel(
            isSuccess: (dto.returnValue == "success"),
            totalSellAmount: dto.totSellamnt,
            drawNumber: dto.drwNo,
            drawDate: drawDate,
            firstWinnerCount: dto.firstPrzwnerCo,
            firstPrizeAmount: dto.firstWinamnt,
            firstPrizeTotalAmount: dto.firstAccumamnt,
            num1: dto.drwtNo1,
            num2: dto.drwtNo2,
            num3: dto.drwtNo3,
            num4: dto.drwtNo4,
            num5: dto.drwtNo5,
            num6: dto.drwtNo6,
            bonusNum: dto.bnusNo
        )
    }
    
    /// 응답 결과. `success` 혹은 `failure`?
    let isSuccess: Bool
    
    /// 총판매금액. total sell amount 인 듯.
    let totalSellAmount: Int
    /// 회차
    let drawNumber: Int
    /// 추첨 날짜. `yyyy-MM-dd` 형식
    let drawDate: Date
    
    /// 1등 당첨자 수
    let firstWinnerCount: Int
    /// 1등 1인당 당첨금액
    let firstPrizeAmount: Int
    /// 1등 총 당첨금액
    let firstPrizeTotalAmount: Int
    
    /// 1번 당첨 숫자
    let num1: Int
    /// 2번 당첨 숫자
    let num2: Int
    /// 3번 당첨 숫자
    let num3: Int
    /// 4번 당첨 숫자
    let num4: Int
    /// 5번 당첨 숫자
    let num5: Int
    /// 6번 당첨 숫자
    let num6: Int
    /// 보너스 숫자
    let bonusNum: Int
    
    var numbers: [Int] {
        [num1, num2, num3, num4, num5, num6, bonusNum]
    }
    
}
