// Improvable Progressbar with dumb hacks
// powered by https://stackoverflow.com/questions/25483292/update-current-line-with-command-line-tool-in-swift

import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

/**
 This class provides an easy-to-use progress bar.
 */
open class Progressbar {
    
    public let config: Configuration
    private var progress: Int
    
    /**
     - parameter length: The total count of iterations, stages of execution or similiar
     - parameter maxWidth: The broadest width the bar should occupy in characters
     - parameter filledWith: The character that is used to fill the bar. Strings longer than 1 are cut down to the first character.
     - note: 80 is used as the default maxWidth as this is the default width of a macOS terminal window.
     */
    @available(*, deprecated, message: "Please use init(total:maxWidth:filledWith:")
    public init(length: Int, maxWidth: Int = 80, filledWith char: String = "#") {
        self.config = Configuration(
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
        self.config = Configuration(
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
    public init(configuration: Configuration) {
        self.config = configuration
        self.progress = 0
    }
    
    /**
     - returns: the progress the bar is currently at
     - note: this may not always be the progress that is actually shown
     */
    open func getProgress() -> Int {
        return self.progress
    }
    
    /**
     Sets the progress without printing
     - parameter p: The new progress status of the progress bar
     */
    open func setProgress(_ p: Int) {
        self.progress = p
    }
    
    /**
     Sets the progress and updates the progress bar
     - parameter p: The new progress status of the progress bar
     */
    open func setProgressAndPrint(_ p: Int) {
        if progress == 0 { print("") } // bad hack to ensure that the previous line wont be overwritten
        self.progress = p
        self.printProgress()
    }
    
    static public func colorize(_ s: String, with c: ANSIColors) -> String {
        return c.rawValue + s + (c.rawValue.isEmpty ? "" : "\u{001B}[0m")
    }
    
    open func currentState() -> String {
        // no, this is not the way how stuff should be rendered. But its the best way to provide extendable styles
        return config.progressBarStyle.bar(progress, config)
    }
    
    /**
     Prints or updates the progress bar with the current status
     */
    private func printProgress() {
        print("\u{1B}[1A\u{1B}[K" + self.currentState())
        fflush(stdout)
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
