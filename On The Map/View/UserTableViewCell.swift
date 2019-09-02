//
//  UserTableViewCell.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 24/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import UIKit

//MARK: custom cell

class UserTableViewCell: UITableViewCell {
    
    // conform to the delgate
    
    weak var delgate:UserTableViewCellDelegate?
    
    //MARK: - IBOutlet of the custom cell

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLink: UILabel!
    @IBOutlet weak var userLocation: UIButton!
    
    //MARK: -  data to be used in the user location view
    
    var lat: Double?
    var long: Double?
    
    //MARK: - IBAction of the custom pin button
    
    @IBAction func userLocationButtonTapped(_ sender: UIButton) {
        delgate?.didTapLocationPin(lat: lat!, long: long!, name: userName.text ?? "", url: userLink.text ?? "")
    }
}
