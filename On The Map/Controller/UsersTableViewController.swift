//
//  UsersTableViewController.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 24/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    //MARK: - Life cycle of the app
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMapModel.students.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath) as! UserTableViewCell
        cell.userName.text = "\(OnTheMapModel.students[indexPath.row].firstName ?? "") \(OnTheMapModel.students[indexPath.row].lastName ?? "")"
        cell.userLink.text = "\(OnTheMapModel.students[indexPath.row].mediaURL ?? "")"
        cell.delgate = self
        cell.long = OnTheMapModel.students[indexPath.row].longitude
        cell.lat = OnTheMapModel.students[indexPath.row].latitude

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        guard let toOpen = OnTheMapModel.students[indexPath.row].mediaURL else{
                handleMissingLink()
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
        guard let url = URL(string: toOpen) else {
                handleMissingLink()
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
        app.open(url, options: [:], completionHandler: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - IBAction of the table view

    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        OnTheMapClient.getStudentLocations(completion: handleStudentLocations(students:error:))
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        OnTheMapClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - handling methods
    
    func handleStudentLocations(students:StudentLocations?,error:Error?) {
        guard (students?.results) != nil else {
            return
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func handleMissingLink() {
        let alertVC = UIAlertController(title: "Link broken", message: "could not open the page", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

}

//MARK: - delgate method to setup the location pin button

extension UsersTableViewController: UserTableViewCellDelegate {
    func didTapLocationPin(lat:Double,long:Double,name:String,url:String) {
        UserLocationViewController.latitude = lat
        UserLocationViewController.longitude = long
        UserLocationViewController.name = name
        UserLocationViewController.url = url
        performSegue(withIdentifier: "pinLocation", sender: nil)
    }

}
