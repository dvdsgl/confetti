//
//  Event.swift
//  Confetti
//
//  Created by David Siegel on 5/6/17.
//  Copyright © 2017 confetti. All rights reserved.
//

import Foundation

class Event {
    var year: Int?
    var month: Int
    var day: Int
    
    init() {
        year = 1986
        month = 3
        day = 25
    }
    
    var description: String {
        if let year = year {
            return "\(monthName) \(day), \(year)"
        } else {
            return "\(monthName) \(day)"
        }
    }
    
    var monthName: String {
        let formatter = DateFormatter()
        return formatter.monthSymbols[month - 1]
    }
}
