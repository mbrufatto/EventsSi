//
//  DetailEventViewModelProtocol.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import Foundation

protocol DetailEventViewModelProtocol {
    func getEvent(eventId: String, completion: @escaping GetEventClosure)
    func loadAddress(latitude: String, longitude: String, completion: @escaping GetEventAddressClosure)
    func doCheckin(eventId: String, name: String, email: String, completion: @escaping DoCheckinClousure)
}
