//
//  NetworkManager.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import Foundation

class NetworkManager: NetworkManagerProtocol {
    
    func getEvents(completion: @escaping GetEventsClosure) {
        
        let url = URL(string: ApiConfig.baseUrl)
        
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url!)) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedEvents = try decoder.decode([Event].self, from: data)
                        completion(decodedEvents)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func getAddressByLatitudeAndLongitude(latitude: String, longitude: String, completion: @escaping GetEventAddressClosure) {
        
        let url = URL(string: "http://nominatim.openstreetmap.org/reverse?lat=\(latitude)&lon=\(longitude)&format=json")
        
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url!)) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedAddress = try decoder.decode(AddressBase.self, from: data)
                        completion(decodedAddress.address)
                    } catch {
                        print(error.localizedDescription)
                        debugPrint(error)
                        completion(Address())
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func getEvent(eventId: String, completion: @escaping GetEventClosure) {
        
        let url = URL(string: "\(ApiConfig.baseUrl)/\(eventId)")
        
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url!)) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedEvent = try decoder.decode(Event.self, from: data)
                        completion(decodedEvent)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func sendCheckin(eventId: String, name: String, email: String, completion: @escaping DoCheckinClousure) {
        let parameters = [
            "eventId": eventId,
            "name": name,
            "email": email
            ] as [String : Any]
        
        //create the url with URL
        let url = URL(string: ApiConfig.checkinUrl)!
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        guard let status = json["code"] else {
                            return
                        }
                        
                        if status as! String == "200" {
                            completion(true)
                        }
                        completion(false)
                    }
                } catch let error {
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        })
        task.resume()
    }
}
