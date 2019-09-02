//
//  loginResponse.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 31/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}
