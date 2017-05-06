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
