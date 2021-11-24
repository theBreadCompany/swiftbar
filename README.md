# swiftbar
I couldn't find a progress bar package, so I created one.

## Installation
This package is available via the Swift Package Manager. Simply add ```.package(url: "https://github.com/theBreadCompany/swiftbar.git", from: "1.0.0")``` to your ```Package.swift``` or ```https://github.com/theBreadCompany/swiftbar.git``` to your project's package dependencies.

## Usage
This module is (yet) rather... simple. I. e. create a bar with the length of ```your_collection.count```, loop through ```your_collection``` and update with ```bar.setPrgress(bar.getProgress() + 1)``` or ```bar += 1```. 

If you want to see it in action, clone (```git clone https://github.com/theBreadCompany/swiftbar.git```) the repo, ```cd``` into it, type ```swift build``` and execute either ```.build/debug/Example``` or ```.build/debug/Example2```.

Please keep in mind that there may be unexpected behaviour as the Xcode "terminal" isn't an actual terminal.

## TODO
- Write tests
- Introduce a tqdm (python) inspired Collection that print a bar as it is being subscripted
- add styles
- add speed of iterations, including units

## Support
I am happy about any way of supporting me, may it be suggesting new ideas or reporting bugs ^^.
