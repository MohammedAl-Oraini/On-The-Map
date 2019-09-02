//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 29/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController {
    
    //MARK: - IBOutlet of the information posting view

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    //MARK: - setting up the link text field delegate
    
    let linkTextFieldDelegate = LinkTextFieldDelegate()
    
    //MARK: - Life cycle of the app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.linkTextField.delegate = linkTextFieldDelegate
    }
    
    // MARK: - IBAction of the information posting view
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func findLocationButtonTapped(_ sender: UIButton) {
        AddingLocationViewController.locationString = locationTextField.text ?? ""
        AddingLocationViewController.urlString = linkTextField.text ?? "https//"
        if locationTextField.text != "" && linkTextField.text != "" {
            performSegue(withIdentifier: "findLocation", sender: sender)
        } else {
            showTextFailure(message: "Fill the missing text")
        }
        
    }
    
    //MARK: - error handling method
    
    func showTextFailure(message: String) {
        let alertVC = UIAlertController(title: "Missing Text", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
