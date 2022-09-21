//
//  File.swift
//  
//
//  Created by Fabio Mauersberger on 21.11.21.
//

import Foundation
import swiftbar

print("Printing a timed bar...")
let bar1 = Progressbar(total: 10, maxWidth: 80) // 80 is the standard width of a macOS terminal
bar1.setProgressAndPrint(3)
Thread.sleep(forTimeInterval: .init(2))
bar1.setProgressAndPrint(7)
Thread.sleep(forTimeInterval: .init(3))
bar1.setProgressAndPrint(10)

print("Print a bar while doing heavy calculation...")
let testArray = Array<Int>(repeating: Int.random(in: 0...100), count: 10)
var result = 0
//print("Doing heavy calculation noone understands.") // print any important stuff first
//var bar = Progressbar(total: testArray.count, maxWidth: 80) // because the bar wants its own space and will overwrite anything printed after initializing the bar (because bad hacks)
for i in ProgressingArray(testArray) {
    result += i
    //bar += 1
    Thread.sleep(forTimeInterval: 0.5)
}
print("Got it: \(result). Nice.")

print("Print a normal stepping bar")
let c = Progressbar.Configuration(
    total: 100,
    maxWidth: 80,
    terminatingSymbols: .init(terminatingSymbols: .pipes, color: .cyan),
    barCharacter: .init(character: "I", color: .green),
    progressBarStyle: .preciseBar,
    statsStyle: .init(color: .blue))

var bar2 = Progressbar(configuration: c)
for _ in 1...bar2.config.total {
    Thread.sleep(forTimeInterval: .init(0.05))
    bar2 += 1
}
