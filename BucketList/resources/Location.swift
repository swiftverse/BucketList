//
//  Location.swift
//  BucketList
//
//  Created by Amit Shrivastava on 07/01/22.
//

import Foundation

struct Location: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}
