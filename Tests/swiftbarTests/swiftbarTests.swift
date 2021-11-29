//
//  swiftbarTests.swift
//  
//
//  Created by Fabio Mauersberger on 29.11.21.
//

import XCTest
@testable import swiftbar

final class swiftbarTests: XCTestCase {
    
    var config = ProgressbarConfiguration(total: 100, maxWidth: 80,
                                          terminatingSymbols: .init(terminatingSymbols: .squareBrackets, color: .standardWhite),
                                          barCharacter: .init(character: Character("#"), color: .standardWhite),
                                          progressBarStyle: .preciseBar,
                                          statsStyle: .init(color: .standardWhite))
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    
    func initTests() throws {
        
        let bar = Progressbar(configuration: config)
        
        XCTAssertEqual(bar.getProgress(), 0)
        
        XCTAssertEqual(try JSONEncoder().encode(config), try JSONEncoder().encode(bar.config))
    }
    
    func simpleBarTest() {
        
        let bar = Progressbar(configuration: config)
        
        for i in 1...bar.config.total {
            let counter = "] [\(i)/100]"
            let barWidth = config.maxWidth - counter.count
            XCTAssertEqual(bar.currentState(), String(repeating: bar.config.barCharacter.character, count: barWidth / bar.config.total * i) + String(repeating: " ", count: barWidth - barWidth / bar.config.total * i) + counter)
            bar += 1
        }

    }
    
    func preciseBarTest() {
        
        self.config.progressBarStlye = .simpleBar
        let bar = Progressbar(configuration: config)
        
        for i in 1...bar.config.total {
            let percent = "[\(i)%] ["
            let counter = "] [\(i)/100]"
            let barWidth = config.maxWidth - (percent.count + counter.count)
            XCTAssertEqual(bar.currentState(), percent + String(repeating: bar.config.barCharacter.character, count: barWidth / bar.config.total * i) + String(repeating: " ", count: barWidth - barWidth / bar.config.total * i) + counter)
            bar += 1
        }
    }
}
