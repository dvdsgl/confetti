//: Playground - noun: a place where people can play

import UIKit
import Foundation

import ConfettiKit

var str = "Hello, playground"


// Get a month name given an int
let month = 3
let formatter = DateFormatter()
formatter.monthSymbols[month]

let e = EventViewModel(Event(person: Person.hannah, month: 5, day: 7, year: 2000))
e.daysAway

// Get next date
let components = DateComponents(year: 1986, month: 5, day: 7)

let calendar = Calendar.current
let startOfToday = calendar.startOfDay(for: Date())
let startOfYesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday)!
let first = calendar.date(from: components)!
let next = calendar.nextDate(after: startOfYesterday,
                          matching: DateComponents(month: components.month, day: components.day),
                          matchingPolicy: .nextTime,
                          repeatedTimePolicy: .first,
                          direction: .forward)!

calendar.dateComponents([.day], from: startOfYesterday, to: next).day!

let cyan = UIColor(red: 31.0 / 255.0, green: 213, blue: 190, alpha: 1)