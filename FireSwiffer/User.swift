//
//  User.swift
//  FireSwiffer
//
//  Created by Vasily on 06.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import FirebaseAuth

struct User {
    let uid: String
    let email: String
    
    init(userData: FIRUser) {
        uid = userData.uid
        
        if let mail = userData.providerData.first?.email {
            email = mail
        } else {
            email = ""
        }
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
