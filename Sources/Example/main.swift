//
//  File.swift
//  
//
//  Created by Fabio Mauersberger on 21.11.21.
//

import Foundation
import swiftbar

let bar = Progressbar(length: 10, maxWidth: 84) // 84 is the standard width of a macOS terminal
bar.setProgressAndPrint(3)
Thread.sleep(forTimeInterval: .init(2))
bar.setProgressAndPrint(7)
Thread.sleep(forTimeInterval: .init(3))
bar.setProgressAndPrint(10)
