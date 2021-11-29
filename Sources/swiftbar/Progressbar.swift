// Improvable Progressbar with dumb hacks
// powered by https://stackoverflow.com/questions/25483292/update-current-line-with-command-line-tool-in-swift

import Foundation

/**
 This class provides an easy-to-use progress bar.
 */
public class Progressbar {
    
    public let config: ProgressbarConfiguration
    private var progress: Int
    
    /**
     - parameter length: The total count of iterations, stages of execution or similiar
     - parameter maxWidth: The broadest width the bar should occupy in characters
     - parameter filledWith: The character that is used to fill the bar. Strings longer than 1 are cut down to the first character.
     - note: 80 is used as the default maxWidth as this is the default width of a macOS terminal window.
     */
    @available(*, deprecated, message: "Please use init(total:maxWidth:filledWith:")
    public init(length: Int, maxWidth: Int = 80, filledWith char: String = "#") {
        self.config = ProgressbarConfiguration(
            total: length,
            maxWidth: maxWidth,
            terminatingSymbols: .init(terminatingSymbols: .squareBrackets, color: .white),
            barCharacter: .init(character: .init(char), color: .white),
            progressBarStyle: .simpleBar,
            statsStyle: .init(color: .white))
        self.progress = 0
    }
    
    /**
     - parameter total: The total count of iterations, stages of execution or similiar
     - parameter maxWidth: The broadest width the bar should occupy in characters
     - parameter filledWith: The character that is used to fill the bar. Strings longer than 1 are cut down to the first character.
     - note: 80 is used as the default maxWidth as this is the default width of a macOS terminal window.
     */
    public init(total: Int, maxWidth: Int = 80, filledWith char: String = "#") {
        self.config = ProgressbarConfiguration(
            total: total,
            maxWidth: maxWidth,
            terminatingSymbols: .init(terminatingSymbols: .squareBrackets, color: .white),
            barCharacter: .init(character: .init(char), color: .white),
            progressBarStyle: .simpleBar,
            statsStyle: .init(color: .white))
        self.progress = 0
    }
    
    /**
     Initialize a progress bar
     - parameter configuration: The existing configuration you want to use
     */
    public init(configuration: ProgressbarConfiguration) {
        self.config = configuration
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
        if progress == 0 { print("") } // bad hack to ensure that the previous line wont be overwritten
        self.progress = p
        self.printProgress()
    }
    
    static public func colorize(_ s: String, with c: ANSIColors) -> String {
        return c.rawValue + s + (c.rawValue.isEmpty ? "" : "\u{001B}[0m")
    }
    
    public func currentState() -> String {
        let _maxWidth = self.config.maxWidth - 2
        let counterContent = " [\(self.progress)/\(self.config.total)]"
        
        var barContent = ""
        switch self.config.progressBarStlye {
        case .simpleBar:
            let barWidth = _maxWidth - (counterContent.count)
            let currentBarWidth = Int(Float(progress) / Float(self.config.total) * Float(barWidth))
            barContent =
            Progressbar.colorize(self.config.terminatingSymbols.terminatingSymbols.rawValue.first!.description, with: self.config.terminatingSymbols.color)
            + Progressbar.colorize(String(repeating: self.config.barCharacter.character, count: Int(currentBarWidth)), with: self.config.barCharacter.color)
            + String(repeating: " ", count: barWidth - currentBarWidth)
            + Progressbar.colorize(self.config.terminatingSymbols.terminatingSymbols.rawValue.last!.description, with: self.config.terminatingSymbols.color)
            + Progressbar.colorize(counterContent, with: self.config.statsStyle.color)
        case .preciseBar:
            let percentCounter = "[\(Int(Float(self.progress) / Float(self.config.total) * 100))%] "
            let barWidth = _maxWidth - (counterContent.count + percentCounter.count)
            let currentBarWidth = Int(Float(progress) / Float(self.config.total) * Float(barWidth))
            barContent =
            Progressbar.colorize(percentCounter, with: self.config.statsStyle.color)
            + Progressbar.colorize(self.config.terminatingSymbols.terminatingSymbols.rawValue.first!.description, with: self.config.terminatingSymbols.color)
            + Progressbar.colorize(String(repeating: self.config.barCharacter.character, count: currentBarWidth), with: self.config.barCharacter.color)
            + String(repeating: " ", count: barWidth - currentBarWidth)
            + Progressbar.colorize(self.config.terminatingSymbols.terminatingSymbols.rawValue.last!.description, with: self.config.terminatingSymbols.color)
            + Progressbar.colorize(counterContent, with: self.config.statsStyle.color)
        }
        
        return barContent
    }
    
    /**
     Prints or updates the progress bar with the current status
     */
    private func printProgress() {
        print("\u{1B}[1A\u{1B}[K" + self.currentState())
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
    public static func += (lhs: Progressbar, rhs: Int) {
        lhs.setProgressAndPrint(lhs.getProgress() + rhs)
    }
    
    /**
     Updates the progress and prints new state
     - parameter lhs: the progress bar to update
     - parameter rhs: the progress that shall be reverted
     - note: simply use as i. e. bar -= 1
     */
    public static func -= (lhs: Progressbar, rhs: Int) {
        lhs.setProgressAndPrint(lhs.getProgress() - rhs)
    }
    
    
}
