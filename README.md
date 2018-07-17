# MultiTypeCircleChart
Circle chart with percentage slide template. Can be used for diagram, graph, chart, report, data visualization, presentation.

## Requirements

- Xcode 8.0+
- Swift 4.0+

## Installation

MTCircleChart is available through CocoaPods. You can install it with the following command:

```bash
$ gem install cocoapods
```

```ruby
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'MTCircleChart'
end
```

Then, run the following command:

```bash
$ pod install
```
## Example

```swift
import MTCircleChart

class ViewController: UIViewController {
    
    let circleChart: MTCircleChart = {
        
        let mainColor = UIColor(red: 185/255, green: 212/255, blue: 235/255, alpha: 1.0)
        let textColor = UIColor(red: 75/255, green: 118/255, blue: 176/255, alpha: 1.0)
    
        let v = MTCircleChart(tracks: [
            MTTrack(value: 86, total: 100, color: mainColor, text: "CONNECTICUT"),
            MTTrack(value: 82, total: 100, color: mainColor.withAlphaComponent(0.75), text: "ALABAMA"),
            MTTrack(value: 75, total: 100, color: mainColor.withAlphaComponent(0.45), text: "NEVADA"),
            MTTrack(value: 70, total: 100, color: mainColor.withAlphaComponent(0.15), text: "UTAH")
            ], MTConfig(textColor: textColor))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(circleChart)
        layout()
    }

    // MARK: Layout
    private func layout() {
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": circleChart])
        )
        NSLayoutConstraint.activate(
             NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": circleChart])
        )
    }
}
```

## License

MTCircleChart is released under the MIT license. See LICENSE for details.
