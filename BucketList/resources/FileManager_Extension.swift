//
//  FileManager_Extension.swift
//  BucketList
//
//  Created by Amit Shrivastava on 06/01/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
