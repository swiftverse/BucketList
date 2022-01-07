//
//  FileManager_Extension.swift
//  BucketList
//
//  Created by Amit Shrivastava on 06/01/22.
//

import Foundation

extension FileManager {
   static func getDocumentsDirectory() -> URL {
        return  self.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
