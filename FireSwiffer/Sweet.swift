//
//  Sweet.swift
//  FireSwiffer
//
//  Created by Vasily on 06.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Sweet {
    let key: String!
    let content: String!
    let addedByUser: String!
    let itemRef: FIRDatabaseReference?
    
    init(content: String, addedByUser: String, key: String = "") {
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.itemRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as? NSDictionary
        
        if let sweetContent = snapshotValue!["content"] as? String {
            content = sweetContent
        } else {
            content = ""
        }
        
        if let sweetUser = snapshotValue!["addedByUser"] as? String {
            addedByUser = sweetUser
        } else {
            addedByUser = ""
        }
    }
    
    func toAny() -> Any {
        return ["content":content, "addedByUser": addedByUser]
    }
    
}
