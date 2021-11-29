//
//  File.swift
//  
//
//  Created by Fabio Mauersberger on 28.11.21.
//

import Foundation
import swiftbar

let c = ProgressbarConfiguration(
    total: 100,
    maxWidth: 80,
    terminatingSymbols: .init(terminatingSymbols: .pipes, color: .cyan),
    barCharacter: .init(character: Character("I"), color: .green),
    progressBarStyle: .preciseBar,
    statsStyle: .init(color: .blue))

var bar = Progressbar(configuration: c)
for _ in 1...bar.config.total {
    Thread.sleep(forTimeInterval: .init(0.05))
     bar += 1
}
