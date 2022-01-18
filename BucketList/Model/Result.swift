//
//  Result.swift
//  BucketList
//
//  Created by Amit Shrivastava on 09/01/22.
//

import Foundation


struct Result: Codable {
    var query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    static func < (lhs: Page, rhs: Page) -> Bool {
        return lhs.title < rhs.title
    }
    
    var pageid: Int
    let title: String
    let terms: [String: [String]]?
    var description: String {
        terms?["description"]?.first ?? " NO further information"
    }
}
