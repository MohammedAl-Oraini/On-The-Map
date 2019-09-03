//
//  LoginViewController.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 24/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlet of the login view

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Life cycle of the app
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    //MARK: - IBAction of the login view

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            showLoginFailure(message: "Fill the missing fields")
            return
        }
        OnTheMapClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    @IBAction func signupButtonTapped(_ sender: Any) {
        let app = UIApplication.shared
        app.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    //MARK: - handling methods
    
    func handleLoginResponse(success: Bool, error: Error?) {
        DispatchQueue.main.async {
            if success {
                self.performSegue(withIdentifier: "logInIdentifier", sender: nil)
            } else {
                self.showLoginFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}

