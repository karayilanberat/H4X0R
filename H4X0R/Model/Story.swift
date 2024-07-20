//
//  Story.swift
//  H4X0R
//
//  Created by berat on 20.07.2024.
//

import Foundation

struct Story: Decodable, Identifiable {
    let by: String?
    let descendants: Int?
    let id: Int
    let kids: [Int]?
    let score: Int
    let time: Int?
    let title: String
    let type: String?
    let url: String??
}
