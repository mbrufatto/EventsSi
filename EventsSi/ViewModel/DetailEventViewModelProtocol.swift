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
}
