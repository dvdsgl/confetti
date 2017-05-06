//: Playground - noun: a place where people can play

import UIKit
import Foundation

import ConfettiKit

var str = "Hello, playground"


// Get a month name given an int
let month = 3
let formatter = DateFormatter()
formatter.monthSymbols[month]

let e = Event(person: Person.david, month: 3, day: 8, year: 1986)
e.description

// Get next date
let components = DateComponents(year: 1986, month: 3, day: 25)
let first = Calendar.current.date(from: components)!
let next = Calendar.current.nextDate(after: Date(),
                          matching: DateComponents(month: components.month, day: components.day),
                          matchingPolicy: .nextTime,
                          repeatedTimePolicy: .first,
                          direction: .forward)!

Calendar.current.dateComponents([.year], from: first, to: next).year