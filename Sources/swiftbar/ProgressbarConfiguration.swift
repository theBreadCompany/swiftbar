//
//  ProgressbarConfiguration.swift
//
//
//  Created by Fabio Mauersberger on 27.11.21.
//
//  Featuring far to complicated struct-ures for

import Foundation

extension Progressbar {
    /**
     `struct` representing a configuration for a progress bar.
     */
    public struct Configuration: Codable {
        
        /**
         struct defining the characters that appear on the far left or the far right respectivly, together with their color.
         The first character will be on the left and the second one on the right side of the bar.
         */
        public struct Boundary: Codable {
            
            public var terminatingSymbols: TerminatingSymbols = .squareBrackets
            public var color: ANSIColors = .standardWhite
            
            public init(terminatingSymbols: TerminatingSymbols = .squareBrackets, color: ANSIColors = .standardWhite) {
                self.terminatingSymbols = terminatingSymbols
                self.color = color
            }
        }
        
        /**
         These styles get defined as static properties returning a function that will 'render' the bar.
         The idea is to extend this struct and deliver the hand a ``Creator`` function with it,
         which is basically a function receiving several parameters and returning the 'rendered' bar
         */
        public struct Style: Codable {
            
            private static var implementations = Dictionary<String, Creator>()
            
            public init(_ name: String, createdWith creator: @escaping Creator) {
                self.name = name
                self.bar = creator
                Self.implementations.updateValue(creator, forKey: name)
            }
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                name = try container.decode(String.self)
                bar = Self.implementations[name]! // assumable as every initialization gets stored
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(name)
            }
            
            var name: String
            var bar: Creator
            
            // (progress, total, maxWidth) -> String
            
            public typealias Creator = (Int, Configuration) -> String
            public static let simpleBar = Style("simpleBar", createdWith: { progress, config in
                let counterContent = " [\(progress)/\(config.total)]"
                let barWidth = config.maxWidth - (counterContent.count)
                let currentBarWidth = Int(Float(progress) / Float(config.total) * Float(barWidth))
                let barContent =
                Progressbar.colorize(config.terminatingSymbols.terminatingSymbols.rawValue.first!.description, with: config.terminatingSymbols.color)
                + Progressbar.colorize(String(repeating: config.barCharacter.character, count: Int(currentBarWidth)), with: config.barCharacter.color)
                + String(repeating: " ", count: barWidth - currentBarWidth)
                + Progressbar.colorize(config.terminatingSymbols.terminatingSymbols.rawValue.last!.description, with: config.terminatingSymbols.color)
                + Progressbar.colorize(counterContent, with: config.statsStyle.color)
                return barContent
            })
            public static let preciseBar = Style("preciseBar", createdWith: { progress, config in
                let counterContent = " [\(progress)/\(config.total)]"
                let percentCounter = "[\(Int(Float(progress) / Float(config.total) * 100))%] "
                let barWidth = config.maxWidth - (counterContent.count + percentCounter.count)
                let currentBarWidth = Int(Float(progress) / Float(config.total) * Float(barWidth))
                let barContent =
                Progressbar.colorize(percentCounter, with: config.statsStyle.color)
                + Progressbar.colorize(config.terminatingSymbols.terminatingSymbols.rawValue.first!.description, with: config.terminatingSymbols.color)
                + Progressbar.colorize(String(repeating: config.barCharacter.character, count: currentBarWidth), with: config.barCharacter.color)
                + String(repeating: " ", count: barWidth - currentBarWidth)
                + Progressbar.colorize(config.terminatingSymbols.terminatingSymbols.rawValue.last!.description, with: config.terminatingSymbols.color)
                + Progressbar.colorize(counterContent, with: config.statsStyle.color)
                return barContent
            })
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
            
            /**
             enum to define where the prgress is placed
             */
            public enum Placement: Codable {
                case leading, trailing, leadingInBar, centeredInBar, trailingInBar
            }
            
            public var color: ANSIColors
            public var placement: Placement
            
            public init(color: ANSIColors = .standardWhite, placement: Placement = .trailing) {
                self.color = color
                self.placement = placement
            }
            
        }

        /**
         struct to define the title style
         */
        public struct TitleStyle: Codable {
            
            public var color: ANSIColors
            
            public init(color: ANSIColors = .white) {
                self.color = color
            }
        }
        
        /**
         enum defining the characters that {can} appear on the far left or the far right respectivly
         The first character will be on the left and the second one on the right side of the  bar.
         It does not matter if the String contains one or two characters as they are inferred to via .first and .last.
         
         TODO: rewrite as `static let`s to make extendible
         */
        public enum TerminatingSymbols: String, Codable {
            case roundBrackets = "()"
            case squareBrackets = "[]"
            case curlyBrackets = "{}"
            case pipes = "|"
        }
        
        public var total: Int
        public var maxWidth: Int
        public var terminatingSymbols: Boundary
        public var barCharacter: BarCharacter
        public var progressBarStyle: Style
        public var statsStyle: StatsStyle
        public var titleStyle: TitleStyle
        
        public init(total: Int, maxWidth: Int, terminatingSymbols: Boundary = .init(), barCharacter: BarCharacter = .init(), progressBarStyle: Style = .preciseBar, statsStyle: StatsStyle = .init(), titleStyle: TitleStyle = .init()) {
            self.total = total
            self.maxWidth = maxWidth != -1 ? maxWidth - 2 : -1
            self.terminatingSymbols = terminatingSymbols
            self.barCharacter = barCharacter
            self.progressBarStyle = progressBarStyle
            self.statsStyle = statsStyle
            self.titleStyle = titleStyle
        }
        
    }
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
