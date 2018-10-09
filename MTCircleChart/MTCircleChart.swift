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

public class MTCircleChart: UIView {
    
    public var tracks = [MTTrack]()
    public var config: MTConfig = MTConfig()
    
    // Drawing attributes
    private var maxRadius: CGFloat?
    private var lineWidth: CGFloat?
    private var isDrawn: Bool = false
    private var tasks = [DispatchWorkItem]()
    
    // Redraw on screen direction change
    override public var bounds: CGRect {
        didSet {
            guard isDrawn else { return }
            self.clearAll()
            self.setNeedsDisplay()
        }
    }
    
    // MARK: Lifecycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience public init(tracks: [MTTrack], _ config: MTConfig = MTConfig()) {
        self.init(frame: CGRect.zero)
        self.tracks = tracks
        self.config = config
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        isDrawn = true
        maxRadius = min(self.frame.width, self.frame.height) / 2
        lineWidth = maxRadius! / CGFloat(self.tracks.count + 1)
        
        tracks.enumerated().forEach { index, track in
            self.drawLayer(at: index, for: track)
        }
    }
    
    // MARK: Additional Helpers
    private func drawLayer(at index: Int, for track: MTTrack) {
        
        let layer = CAShapeLayer()
        let radius = (maxRadius! - lineWidth!/2) - (lineWidth! * CGFloat(index))
        let endValue: CGFloat = track.value / track.total
        let startAngle: CGFloat = -(.pi / 2)
        let endAngle: CGFloat = (endValue * 2 * .pi) + startAngle
        
        // Center point due to margins
        let center = CGPoint(x: self.center.x - frame.minX, y: self.center.y - frame.minY)
        
        let layerPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        layer.path = layerPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = track.color.cgColor
        layer.lineWidth = lineWidth ?? 10
        
        let task = DispatchWorkItem {
            
            // Add the circleLayer to the view's layer's sublayers
            self.layer.addSublayer(layer)
            layer.add(self.animateStroke(), forKey:"strokeEnd")
            
            // Labels config
            self.config.fontSize = self.lineWidth! * 0.4
            let labelFrameSize = (radius * 2) + (self.lineWidth! / 2) + self.config.fontSize!
            self.config.frameSize = CGSize(width: labelFrameSize, height: labelFrameSize)
            self.setLabel(for: track)
            
        }
        
        tasks.append(task)
        
        // Execute active task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (0.2 * Double(index)), execute: tasks[index])
    }
    
    private func setLabel(for track: MTTrack) {
        
        let titleLabel = MTTitleLabel()
        titleLabel.config = self.config
        titleLabel.center = center
        titleLabel.text = "\(track.text)"
        titleLabel.value = track.value / track.total
        self.addSubview(titleLabel)
    }
    
    private func clearAll() {
        tasks.forEach { $0.cancel() }
        tasks = []
        subviews.forEach { $0.removeFromSuperview() }
        layer.sublayers?.forEach {
            $0.removeAllAnimations()
            $0.removeFromSuperlayer()
        }
    }
    
    private func animateStroke() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        return animation
    }
}
