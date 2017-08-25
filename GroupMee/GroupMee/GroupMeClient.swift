//
//  GroupMeClient.swift
//  GroupMee
//
//  Created by Gabriel Fernandes on 4/27/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation

//GET /v3/groups HTTP/1.1
//User-Agent: CoolApp/2.0
//Host: api.groupme.com
//Accept: */*
// X-Access-Token: ACCESS_TOKEN

class GroupMeClient {
    
    static var token: String?
    static var user_id: String?
    
    static let URI_BASE = "https://api.groupme.com/v3/"
    
    static func getUser(completion: @escaping()->Void) {
        GETrequest(place: "users/me", completion: {
            (httpCode, data) in
            if httpCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:AnyObject]
                    let resp = json["response"] as! [String:AnyObject]
                    if let id = resp["id"] as? String {
                        self.user_id = id
                    }
                    completion()
                } catch {
                    print("Error")
                }
            }
        })
    }
    
    static func getGroups(completion: @escaping(_ json: [AnyObject]?)->Void) {
        GETrequest(place: "groups", completion: {
            (httpCode, data) in
            if httpCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:AnyObject]
                    completion(json["response"] as! [AnyObject])
                } catch {
                    print("Error")
                    completion(nil)
                }
            }
        })
    }
    
    static func getGroupMessages(id:String, completion: @escaping(_ json: [String:AnyObject]?)->Void) {
        GETrequest(place: "groups/\(id)/messages", completion: {
            (httpCode, data) in
            if httpCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:AnyObject]
                    completion(json["response"] as! [String:AnyObject])
                } catch {
                    print("Error")
                    completion(nil)
                }
            }
        })
    }
    
    //function that simplifies a POST call
    static func GETrequest(place:String, completion: @escaping (_ httpCode: Int, _ data:Data) -> Void) {
        //inputs URI base
        var request = URLRequest(url: URL(string: URI_BASE + place)!)
        request.httpMethod = "GET"
        //Inouts the token needed
        request.addValue(self.token!, forHTTPHeaderField: "X-Access-Token")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        //handles errors
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print(error)
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                do {
                    //print(data)
                    completion(httpStatus.statusCode, data)
                } catch {
                    print("Error with Json")
                    completion(httpStatus.statusCode, data)
                }
            }
            
        }
        task.resume()
    }
    
    
}
