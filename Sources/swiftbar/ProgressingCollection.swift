//
//  ProgressingArray.swift
//  
//
//  Created by Fabio Mauersberger on 29.11.21.
//

import Foundation

public struct ProgressingArray<Element>: Collection, ExpressibleByArrayLiteral {
    
    public var startIndex: ArrayType.Index
    public var endIndex: ArrayType.Index
    
    public typealias Element = ArrayType.Element
    public typealias Index = ArrayType.Index
    
    public typealias ArrayType = [Element]
    
    private var content: [Element]
    public var bar: Progressbar
    
    init(content: [Element], config: Progressbar.Configuration? = nil) {
        self.content = content
        if let config = config {
            self.bar = Progressbar(configuration: config)
        } else {
            self.bar = Progressbar(total: content.count)
        }
        self.startIndex = content.startIndex
        self.endIndex = content.endIndex
    }
    
    public init(arrayLiteral: Element...) {
        self.init(content: arrayLiteral)
    }
    
    public init(_ elements: Array<Element>) {
        self.init(content: elements)
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public subscript(position: Int) -> ArrayType.Element {
        get {
            bar.setProgressAndPrint(position+1)
            return content[position]
        }
    }
}

