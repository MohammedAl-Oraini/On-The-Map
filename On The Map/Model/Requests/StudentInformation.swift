//
//  StudentInformation.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 28/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let firstName: String?
    let lastName: String?
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String?
    let uniqueKey: String?
    let objectId: String
}
