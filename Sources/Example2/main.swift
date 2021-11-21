//
//  main.swift
//  
//
//  Created by Fabio Mauersberger on 21.11.21.
//

import Foundation
import swiftbar

let testArray = [0, 4, 3, 21, 35, 6]
var result = 0

print("Doing heavy calculation noone understands.") // print any important stuff first
let bar = Progressbar(length: testArray.count, maxWidth: 84) // because the bar wants its own space and will overwrite anything printed after initializing the bar (because bad hacks)
for i in testArray {
    result += i
    bar.setProgressAndPrint(bar.getProgress() + 1)
    Thread.sleep(forTimeInterval: 0.5)
}
print("Got it: \(result). Nice.")
