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
}
