//
//  DetailEventTest.swift
//  EventsSiTests
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import XCTest
@testable import EventsSi

class DetailEventTest: XCTestCase {
    
    private var detailEventViewModelProtocol: DetailEventViewModelProtocol!
    
    override func setUp() {
        super.setUp()
        detailEventViewModelProtocol = DetailEventViewModel()
    }
    
    func testSelectEvent() {
        let event = didLoadEvents(nameFile: "event")
        XCTAssertEqual(event.title, "Feira de adoção de animais na Redenção")
    }
    
    private func didLoadEvents(nameFile: String) -> Event {
        let bundle = Bundle(for: type(of: self))
        if let url = bundle.url(forResource: nameFile, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Event.self, from: data)
                return jsonData
            } catch {
                return Event()
            }
        }
        return Event()
    }
}
