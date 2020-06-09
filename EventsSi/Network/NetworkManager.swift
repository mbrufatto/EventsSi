//
//  NetworkManager.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import Foundation

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
}
