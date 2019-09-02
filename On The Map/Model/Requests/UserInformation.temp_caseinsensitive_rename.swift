//
//  UserInformation.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 31/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import Foundation

struct UserInformation:Codable {
    var firstName:String
    var lastName:String
    
    enum CodingKeys:String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
