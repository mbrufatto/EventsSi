//
//  ListEventViewModelProtocol.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import Foundation

protocol ListEventViewModelProtocol {
    func numberOfRows() -> Int
    func eventAt(_ index: Int) -> Event
    func loadEvents(completion: @escaping GetEventsClosure)
    func updateListEvent(events: [Event])
}
