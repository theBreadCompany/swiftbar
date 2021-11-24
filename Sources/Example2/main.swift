//
//  main.swift
//  
//
//  Created by Fabio Mauersberger on 21.11.21.
//

import Foundation
import swiftbar

let testArray = [0, 4, 3, 21, 35, 16, 45, 264, 30, 2]
var result = 0

print("Doing heavy calculation noone understands.") // print any important stuff first
var bar = Progressbar(total: testArray.count, maxWidth: 80) // because the bar wants its own space and will overwrite anything printed after initializing the bar (because bad hacks)
for i in testArray {
    result += i
    bar += 1
    Thread.sleep(forTimeInterval: 0.5)
}
print("Got it: \(result). Nice.")
