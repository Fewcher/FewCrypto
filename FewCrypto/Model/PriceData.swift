//
//  PriceData.swift
//  FewCrypto
//
//  Created by Fewcher on 17.04.2022.
//

import Foundation

struct PriceData: Codable {
    let bitcoin: Bitcoin
}

struct Bitcoin: Codable {
    let usd: Int
    let rub: Int
}
