//
//  Address.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import Foundation

struct Address: Codable {
    var road: String = ""
    var suburb: String = ""
    var city_district: String = ""
    var city: String =  ""
    var state_district: String = ""
    var state: String = ""
    var postcode: String = ""
    var country: String = ""
    var country_code: String = ""
}

struct AddressBase: Codable {
    var address: Address
}
