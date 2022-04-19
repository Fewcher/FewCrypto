//
//  PriceData.swift
//  FewCrypto
//
//  Created by Fewcher on 17.04.2022.
//

import Foundation

//struct Results: Decodable {
//    let hits: [Post]
//}
//
//struct Post: Decodable, Identifiable {
//    var id: String {
//        return objectID
//    }
//    let objectID: String
//    let points: Int
//    let title: String
//    let url: String?
//}

// DONT LOOK UP

struct PriceData: Codable {
    let bitcoin: Bitcoin
}

struct Bitcoin: Codable {
    let usd: Int
    let rub: Int
}

//struct Results: Codable {
//    let bitcoin: Post
//}
//
//struct Post: Codable {
//    let usd: Int
//    let rub: Int
//}
