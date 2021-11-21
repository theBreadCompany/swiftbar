// Improvable Progressbar with dumb hacks
// powered by https://stackoverflow.com/questions/25483292/update-current-line-with-command-line-tool-in-swift

import Darwin
import Foundation

public class Progressbar {
    
    private let length: Int
    private let maxWidth: Int
    private let fillingChar: String
    private var progress: Int
    
    public init(length: Int, maxWidth: Int, filledWith char: String = "#") {
        self.length = length
        self.maxWidth = maxWidth
        self.fillingChar = {
            if char.count > 1 {
                return String(char.first!)
            } else if char.count == 0 {
                return "#"
            } else { return char }
        }()
        self.progress = 0
        print("") // pls dont hate me ;-;
    }
    
    public func setProgress(_ p: Int) {
        self.progress = p
    }
    
    public func setProgressAndPrint(_ p: Int) {
        self.progress = p
        self.printProgress()
    }
    
    private func printProgress() {
        let counterContent = "[\(self.progress)/\(length)]"
        let currentWidth = Float(progress) / Float(length) * Float(maxWidth - counterContent.count - 1)
        let barContent = String(repeating: self.fillingChar, count: Int(currentWidth))
        let spaceCount = maxWidth - (counterContent.count + barContent.count)
        print("\u{1B}[1A\u{1B}[K" + barContent + String(repeating: " ", count: spaceCount) + counterContent)
        fflush(__stdoutp)
    }
}
