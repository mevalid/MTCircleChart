// MIT License
// Copyright (c) 2018 mevalid
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

public class MTValueLabel: MTLabel {
    
    var value: CGFloat = 0.0 {
        didSet {
            let percValue = value * 100
            let formatDef = percValue.truncatingRemainder(dividingBy: 1) == 0
            let strValue = formatDef ? String(format: "%.0f", percValue) : String(describing: percValue)
            self.text = "\(strValue)%"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let angle: CGFloat = -((.pi * 1.5) * (1 - self.value) + self.totalArc)
        let pathAnimation = CABasicAnimation(keyPath: "transform.rotation")
        pathAnimation.duration = CFTimeInterval(1.0)
        pathAnimation.fromValue = 0
        pathAnimation.toValue = angle
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        self.transform = transform.rotated(by: angle)
        self.layer.add(pathAnimation, forKey: "transform.rotation")
        
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 1
        })
    }
}
