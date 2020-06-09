//
//  ListEventsTest.swift
//  EventsSiTests
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import XCTest
@testable import EventsSi

class ListEventsTest: XCTestCase {

    private var listEventViewModelProtocol: ListEventViewModelProtocol!
    
    override func setUp() {
        super.setUp()
        listEventViewModelProtocol = ListEventViewModel()
    }
    
    func testListEvents() {
        let events = didLoadEvents(nameFile: "events")
        listEventViewModelProtocol.updateListEvent(events: events)
        XCTAssertEqual(events.count, listEventViewModelProtocol.numberOfRows())
    }
    
    func testSelectEvent() {
        let events = didLoadEvents(nameFile: "events")
        listEventViewModelProtocol.updateListEvent(events: events)
        let event = listEventViewModelProtocol.eventAt(0)
        
        XCTAssertEqual(event.title, "Feira de adoção de animais na Redenção")
    }
    
    private func didLoadEvents(nameFile: String) -> [Event] {
        let bundle = Bundle(for: type(of: self))
        if let url = bundle.url(forResource: nameFile, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Event].self, from: data)
                return jsonData
            } catch {
                return []
            }
        }
        return []
    }
}
