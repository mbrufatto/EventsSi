//
//  DetailEventViewModel.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import Foundation

class DetailEventViewModel: DetailEventViewModelProtocol {
    
    private var networkManagerProtocol: NetworkManagerProtocol
    private var event: Event?
    
    init(networkManagerProtocol: NetworkManagerProtocol? = nil) {
        self.networkManagerProtocol = networkManagerProtocol ?? NetworkManager()
    }
    
    func getEvent(eventId: String, completion: @escaping GetEventClosure) {
        self.networkManagerProtocol.getEvent(eventId: eventId, completion: { event in
            completion(event)
        })
    }
    
    func loadAddress(latitude: String, longitude: String, completion: @escaping GetEventAddressClosure) {
        self.networkManagerProtocol.getAddressByLatitudeAndLongitude(latitude: latitude, longitude: longitude, completion: { address in
            completion(address)
        })
    }
    
    func doCheckin(eventId: String, name: String, email: String, completion: @escaping DoCheckinClousure) {
        self.networkManagerProtocol.sendCheckin(eventId: eventId, name: name, email: email, completion: { result in
            completion(result)
        })
    }
}
