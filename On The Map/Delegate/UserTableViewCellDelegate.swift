//
//  UserTableViewCellDelegate.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 29/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import Foundation

// a protocol to setup the user location button in the table view

protocol UserTableViewCellDelegate:class {
    func didTapLocationPin(lat:Double,long:Double,name:String,url:String)
}
