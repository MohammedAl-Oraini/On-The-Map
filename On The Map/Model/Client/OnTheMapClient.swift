//
//  OnTheMapClient.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 28/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import Foundation

class OnTheMapClient {
    
    //MARK: data for authentication
    
    struct Auth {
        static var sessionId = ""
        static var key = "1111"
    }
    
    //MARK: networking methods
    
    class func getStudentLocations(completion: @escaping (StudentLocations?, Error?) -> Void) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            if error != nil {
                print(error?.localizedDescription ?? "error was discoverd")// Handle error...
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(StudentLocations.self, from: data)
                OnTheMapModel.students = responseObject.results
                completion(responseObject, nil)
                
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func login(username:String ,password: String ,completion: @escaping (Bool , Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false,error)
                return
            }
            do {
                let range = 5..<data!.count
                let newData = data?.subdata(in: range) /* subset response data! */
                
                let responseObject = try JSONDecoder().decode(LoginResponse.self, from: newData!)
                Auth.sessionId = responseObject.session.id
                Auth.key = responseObject.account.key
                completion(true,nil)
                
            } catch {
                completion(false,error)
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    class func gettingPublicUserData (userID:String,completion: @escaping (Bool, Error?) -> Void) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(userID)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false , error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */

            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(UserInformation.self, from: newData!)
                OnTheMapModel.user.lastName = responseObject.lastName
                OnTheMapModel.user.firstName = responseObject.firstName
                print("Success chang name to \(OnTheMapModel.user.firstName) \(OnTheMapModel.user.lastName)")
                completion(true,nil)
                
            } catch {
                print(error.localizedDescription)
                completion(false,error)
            }
            
            
        }
        task.resume()
    }
    class func postingStudentLocation(firstName:String ,lastName: String, mapString:String,mediaURL:String,latitude:Double,longitude:Double ,completion: @escaping (Bool , Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(OnTheMapClient.Auth.key)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false,error)
                return
            }
            completion(true,nil)
        }
        task.resume()
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            Auth.key = ""
            Auth.sessionId = ""
            OnTheMapModel.students.removeAll()
            OnTheMapModel.user.firstName = "firstName"
            OnTheMapModel.user.lastName = "lastName"
            completion()
        }
        task.resume()
    }
}
