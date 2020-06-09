//
//  NetworkManagerProtocol.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import Foundation

typealias GetEventsClosure = ([Event]) -> Void
typealias GetEventAddressClosure = (Address) -> Void

protocol NetworkManagerProtocol {
    func getEvents(completion: @escaping GetEventsClosure)
    func getAddressByLatitudeAndLongitude(latitude: String, longitude: String, completion: @escaping GetEventAddressClosure)
}
