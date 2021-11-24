// Improvable Progressbar with dumb hacks
// powered by https://stackoverflow.com/questions/25483292/update-current-line-with-command-line-tool-in-swift

import Foundation

/**
 This class provides an easy-to-use progress bar.
 */
public class Progressbar {
    
    private let total: Int
    private let maxWidth: Int
    private let fillingChar: String
    private var progress: Int
    
    /**
     - parameter length: The total count of iterations, stages of execution or similiar
     - parameter maxWidth: The broadest width the bar should occupy in characters
     - parameter filledWith: The character that is used to fill the bar. Strings longer than 1 are cut down to the first character.
     - note: 80 is used as the default maxWidth as this is the default width of a macOS terminal window.
     */
    @available(*, deprecated, message: "Please use init(total:maxWidth:filledWith:")
    public init(length: Int, maxWidth: Int = 80, filledWith char: String = "#") {
        self.total = length
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
    
    /**
     - parameter total: The total count of iterations, stages of execution or similiar
     - parameter maxWidth: The broadest width the bar should occupy in characters
     - parameter filledWith: The character that is used to fill the bar. Strings longer than 1 are cut down to the first character.
     - note: 80 is used as the default maxWidth as this is the default width of a macOS terminal window.
     */
    public init(total: Int, maxWidth: Int = 80, filledWith char: String = "#") {
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
    
    
    /**
     - returns: the progress the bar is currently at
     - note: this may not always be the progress that is actually shown
     */
    public func getProgress() -> Int {
        return self.progress
    }

    /**
     Sets the progress without printing
     - parameter p: The new progress status of the progress bar
     */
    public func setProgress(_ p: Int) {
        self.progress = p
    }
    
    /**
     Sets the progress and updates the progress bar
     - parameter p: The new progress status of the progress bar
     */
    public func setProgressAndPrint(_ p: Int) {
        self.progress = p
        self.printProgress()
    }
    
    /**
     Prints or updates the progress bar with the current status
     */
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
    
    /**
     Updates the progress and prints new state
     - parameter lhs: the progress bar to update
     - parameter rhs: the progress that has been made
     - note: simply use as i. e. bar += 1
     */
    public static func += (lhs: inout Progressbar, rhs: Int) {
        lhs.setProgressAndPrint(lhs.getProgress() + rhs)
    }
    
    /**
     Updates the progress and prints new state
     - parameter lhs: the progress bar to update
     - parameter rhs: the progress that shall be reverted
     - note: simply use as i. e. bar -= 1
     */
   public static func -= (lhs: inout Progressbar, rhs: Int) {
       lhs.setProgressAndPrint(lhs.getProgress() - rhs)
    }
    
    
}
