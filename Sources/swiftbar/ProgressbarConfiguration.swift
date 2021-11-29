//
//  ProgressbarConfiguration.swift
//
//
//  Created by Fabio Mauersberger on 27.11.21.
//
//  Featuring far to complicated struct-ures for

import Foundation

/**
 struct representing a configuration for a progress bar.
 */
public struct ProgressbarConfiguration: Codable {
    
    public var total: Int
    public var maxWidth: Int
    public var terminatingSymbols: TerminatingSymbol
    public var barCharacter: BarCharacter
    public var progressBarStlye: ProgressbarStyle
    public var statsStyle: StatsStyle
    
    public init(total: Int, maxWidth: Int, terminatingSymbols: TerminatingSymbol = TerminatingSymbol(), barCharacter: BarCharacter = BarCharacter(), progressBarStyle: ProgressbarStyle = .preciseBar, statsStyle: StatsStyle = .init(color: .standardWhite)) {
        self.total = total
        self.maxWidth = maxWidth
        self.terminatingSymbols = terminatingSymbols
        self.barCharacter = barCharacter
        self.progressBarStlye = progressBarStyle
        self.statsStyle = statsStyle
    }
    
}

/**
 struct defining the characters that appear on the far left or the far right respectivly, together with their color.
 The first character will be on the left and the second one on the right side of the  bar.
 */
public struct TerminatingSymbol: Codable {
    
    public var terminatingSymbols: TerminatingSymbols
    public var color: ANSIColors
    
    public init(terminatingSymbols: TerminatingSymbols = .squareBrackets, color: ANSIColors = .standardWhite) {
        self.terminatingSymbols = terminatingSymbols
        self.color = color
    }
}

/**
 struct to represent the character filling the bar together with its color
 */
public struct BarCharacter: Codable {
    
    public var character: String
    public var color: ANSIColors
    
    public init(character: String = "#", color: ANSIColors = .standardWhite) {
        self.character = {
            if character.isEmpty { return "#" }
            if character.count > 2 { return character.dropLast(character.count - 2).description }
            return character
        }()
        self.color = color
    }
    
}

/**
 struct to define the statistics style
 */
public struct StatsStyle: Codable {
    
    public var color: ANSIColors
    
    public init(color: ANSIColors = .standardWhite) {
        self.color = color
    }
}

/**
 enum defining the characters that {can} appear on the far left or the far right respectivly
 The first character will be on the left and the second one on the right side of the  bar.
 It does not matter if the String contains one or two characters as they are inferred to via .first and .last.
 */
public enum TerminatingSymbols: String, Codable {
    case roundBrackets = "()"
    case squareBrackets = "[]"
    case curlyBrackets = "{}"
    case pipes = "|"
}

/**
 enum holding the values for ansi colors aka colors that can be used to represent text in the terminal
 */
public enum ANSIColors: String, Codable {
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case purple = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case standardWhite = ""
    
}

public enum ProgressbarStyle: Codable {
    case simpleBar, preciseBar
}

/*
extension Character: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(self.description)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let s = try container.decode(String.self)
        if s.count == 0 {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected String with count = 1, but got empty String instead!")
        } else if s.count > 1 {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected String with count = 1, but got String with count > 1 instead!")
        } else {
            self = Character(s)
        }
    }
}
*/
