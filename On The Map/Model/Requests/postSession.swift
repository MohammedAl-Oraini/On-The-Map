//
//  postSession.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 31/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
