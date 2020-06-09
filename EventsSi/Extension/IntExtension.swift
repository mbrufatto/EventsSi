//
//  IntExtension.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import Foundation

extension Int {
    func convertTimespampToDate() -> String {
        let epocTime = TimeInterval(self) / 1000
        let unixTimestamp = Date(timeIntervalSince1970: epocTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: unixTimestamp)
    }
}
