//
//  LottoResultDTO.swift
//  Assignment-LottoAndMovie
//
//  Created by 김민성 on 7/24/25.
//

import Foundation

/*
{
    "totSellamnt":113802682000,
    "returnValue":"success",
    "drwNoDate":"2025-07-19",
    "firstWinamnt":1593643500,
    "drwtNo6":41,
    "drwtNo4":20,
    "firstPrzwnerCo":17,
    "drwtNo5":33,
    "bnusNo":28,
    "firstAccumamnt":27091939500,
    "drwNo":1181,
    "drwtNo2":10,
    "drwtNo3":14,
    "drwtNo1":8
}
 */


struct LottoResultDTO: Decodable {
    /// 총판매금액. total sell amount 인 듯.
    let totSellamnt: Int
    /// 응답 결과. `success` 혹은 `failure`?
    let returnValue: String
    /// 추첨 날짜. `yyyy-MM-dd` 형식
    let drwNoDate: String
    /// 1등 1인당 당첨금액
    let firstWinamnt: Int
    /// 6번 당첨 숫자
    let drwtNo6: Int
    /// 4번 당첨 숫자
    let drwtNo4: Int
    /// 1등 당첨자 수
    let firstPrzwnerCo: Int
    /// 5번 당첨 숫자
    let drwtNo5: Int
    /// 보너스 숫자
    let bnusNo: Int
    /// 1등 총 당첨금액
    let firstAccumamnt: Int
    /// 회차
    let drwNo: Int
    /// 2번 당첨 숫자
    let drwtNo2: Int
    /// 3번 당첨 숫자
    let drwtNo3: Int
    /// 1번 당첨 숫자
    let drwtNo1: Int
}
