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
typealias GetEventClosure = (Event) -> Void
typealias DoCheckinClousure = (Bool) -> Void

protocol NetworkManagerProtocol {
    func getEvents(completion: @escaping GetEventsClosure)
    func getAddressByLatitudeAndLongitude(latitude: String, longitude: String, completion: @escaping GetEventAddressClosure)
    func getEvent(eventId: String, completion: @escaping GetEventClosure)
    func sendCheckin(eventId: String, name: String, email: String, completion: @escaping DoCheckinClousure)
}
