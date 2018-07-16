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

public class MTLabel: UILabel {
    
    public var angle: CGFloat = .pi/2
    public var clockwise: Bool = true
    public var totalArc: CGFloat = 0
    
    public override func draw(_ rect: CGRect) {
        textArc()
    }
    
    // Draws text around an arc of radius r with the text centred
    private func textArc() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let str = self.text ?? ""
        let size = self.bounds.size
        context.translateBy(x: size.width / 2, y: size.height / 2)
        
        let radius = getRadius()
        let strLength = str.count
        
        let characters: [String] = str.map { String($0) }
        // Arc subtended by each character
        var arcs: [CGFloat] = []
        
        // Calculate arcs total
        for i in 0 ..< strLength {
            let chord = characters[i].size(withAttributes: [NSAttributedStringKey.font: self.font]).width
            arcs += [chordToArc(chord, radius: radius)]
            totalArc += arcs[i]
        }
        
        let direction: CGFloat = clockwise ? -1 : 1
        let slantCorrection: CGFloat = clockwise ? -(.pi/2) : (.pi/2)
        var thetaI = angle - direction * totalArc / 2
        
        for i in 0 ..< strLength {
            thetaI += direction * arcs[i] / 2
            // Call centre with each character in turn.
            centre(text: characters[i], context: context, radius: radius, angle: thetaI, slantAngle: thetaI + slantCorrection)
            thetaI += direction * arcs[i] / 2
        }
    }
    
    private func chordToArc(_ chord: CGFloat, radius: CGFloat) -> CGFloat {
        return 2 * asin(chord / (2 * radius))
    }
    
    // Draws the String str centred at the position
    private func centre(text str: String, context: CGContext, radius r:CGFloat, angle theta: CGFloat, slantAngle: CGFloat) {
        // Set the text attributes
        let attributes = [NSAttributedStringKey.foregroundColor: self.textColor,
                          NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: self.font.pointSize)] as [NSAttributedStringKey : Any]
        
        context.saveGState()
        // Move the origin to the centre of the text
        context.translateBy(x: r * cos(theta), y: -(r * sin(theta)))
        // Rotate the coordinate system
        context.rotate(by: -slantAngle)
        // Calculate the width of the text
        let offset = str.size(withAttributes: attributes)
        // Move the origin by half the size of the text
        context.translateBy(x: -offset.width / 2, y: -offset.height / 2)
        // Draw the text
        str.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        context.restoreGState()
    }
    
    private func getRadius() -> CGFloat {
        let smallestWidthOrHeight = min(self.bounds.size.height, self.bounds.size.width)
        let heightOfFont = self.text?.size(withAttributes: [NSAttributedStringKey.font: self.font]).height ?? 0
        
        // Dividing the smallestWidthOrHeight by 2 gives us the radius for the circle.
        return (smallestWidthOrHeight/2) - heightOfFont - 1
    }
}
