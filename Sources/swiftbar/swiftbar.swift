// Improvable Progressbar with dumb hacks
// powered by https://stackoverflow.com/questions/25483292/update-current-line-with-command-line-tool-in-swift

import Foundation

public class Progressbar {
    
    private let total: Int
    private let maxWidth: Int
    private let fillingChar: String
    private var progress: Int
    
    public init(total: Int, maxWidth: Int, filledWith char: String = "#") {
        self.total = total
        self.maxWidth = maxWidth
        self.fillingChar = {
            if char.count > 1 {
                return String(char.first!)
            } else if char.count == 0 {
                return "#"
            } else { return char }
        }()
        self.progress = 0
    }
    
    public func getProgress() -> Int {
        return self.progress
    }
    
    public func setProgress(_ p: Int) {
        self.progress = p
    }
    
    
    public func setProgressAndPrint(_ p: Int) {
        self.progress = p
        self.printProgress()
    }
    
    private func printProgress() {
        if progress == 0 { print("") }
        let _maxWidth = maxWidth - 2
        let counterContent = " [\(self.progress)/\(total)]"
        let barWidth = _maxWidth - (counterContent.count)
        let currentBarWidth = Float(progress) / Float(total) * Float(barWidth)
        var barContent = String(repeating: self.fillingChar, count: Int(currentBarWidth))
        barContent += String(repeating:" ", count:barWidth - barContent.count)
        print("\u{1B}[1A\u{1B}[K" + "[" + barContent + "]" + counterContent)
        fflush(__stdoutp)
    }
}

extension Progressbar {
    
    static func += (lhs: inout Progressbar, rhs: Int) {
        lhs.progress += rhs
    }
    
    static func + (lhs: inout Progressbar, rhs: Int) {
        lhs += rhs
    }
    
    static func -= (lhs: inout Progressbar, rhs: Int) {
        lhs.progress -= rhs
    }
    
    static func - (lhs: inout Progressbar, rhs: Int) {
        lhs -= rhs
    }
    
}
