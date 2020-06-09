//
//  Event.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import Foundation

struct Event: Decodable {
    var id: String = ""
    var title: String = ""
    var date: String = ""
    var description: String = ""
    var image: String = ""
    var latitude: String = "''"
    var longitude: String = ""
    var address: String = ""
    var price: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case date
        case description
        case image
        case latitude
        case longitude
        case address
        case price
    }
    
    init() {}
    
    init(from decode: Decoder) throws {
        let container = try decode.container(keyedBy: CodingKeys.self)
        
        if let eventId = try? container.decode(String.self, forKey: .id) {
            self.id = eventId
        }
        
        if let eventTitle = try? container.decode(String.self, forKey: .title) {
            self.title = eventTitle
        }
        
        if let eventDate = try? container.decode(Int.self, forKey: .date) {
            self.date = eventDate.convertTimespampToDate()
        }
        
        if let eventDesc = try? container.decode(String.self, forKey: .description) {
            self.description = eventDesc
        }
        
        if let eventImage = try? container.decode(String.self, forKey: .image) {
            self.image = eventImage
        }
        
        if let eventLatitude = try? container.decode(String.self, forKey: .latitude) {
            self.latitude = eventLatitude
        } else if let eventLatitude = try? container.decode(Double.self, forKey: .latitude) {
            self.latitude = "\(eventLatitude)"
        }
        
        if let eventLongitude = try? container.decode(String.self, forKey: .longitude) {
            self.longitude = eventLongitude
        } else if let eventLongitude = try? container.decode(Double.self, forKey: .longitude) {
            self.longitude = "\(eventLongitude)"
        }
        
        if let eventPrice = try? container.decode(Double.self, forKey: .price) {
            self.price = eventPrice
        }
    }
}
