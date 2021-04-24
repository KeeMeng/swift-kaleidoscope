import CoreGraphics
import UIKit
import SpriteKit

/// /*#-localizable-zone(shapesExtras1)*/Converts from degrees to radians./*#-end-localizable-zone*/
public func radians(fromDegrees: Double) -> CGFloat {
    return CGFloat(fromDegrees * (Double.pi / 180.0))
}

/*
//#-localizable-zone(shapesBezierPath)
 (!) UIBezierPath uses radians to specify angles.
     The above function converts from degrees.

 (!) When drawing arcs with UIBezierPath,
     the 0º point is at the 3 o'clock position.

              270º
               |
       180º —— + ——  0º
               |
              90º
 
//#-end-localizable-zone
*/
/// /*#-localizable-zone(shapesExtras2)*/Creates a CGPath, used to create a custom shape./*#-end-localizable-zone*/
public func oddShape() -> CGPath {
    let path = UIBezierPath()
    let leftCircleCenter = CGPoint(x: 40, y: 40)
    let rightCircleCenter = CGPoint(x: 160, y: 40)
    let boxTopLeft = leftCircleCenter
    let boxTopRight = rightCircleCenter
    let boxBottomRight = CGPoint(x: 160, y: 160)
    let boxBottomLeft = CGPoint(x: 40, y: 160)
    path.addArc(withCenter: leftCircleCenter,
                radius: 40,
                startAngle: radians(fromDegrees: 90),
                endAngle: radians(fromDegrees: 0),
                clockwise: true)
    path.addLine(to: rightCircleCenter)
    path.addArc(withCenter: rightCircleCenter,
                radius: 40,
                startAngle: radians(fromDegrees: 180),
                endAngle: radians(fromDegrees: 90),
                clockwise: true)
    path.addLine(to: boxBottomRight)
    path.addLine(to: boxBottomLeft)
    path.addLine(to: boxTopLeft)
    path.close()
    return path.cgPath
}

public extension UIColor {
    /// /*#-localizable-zone(shapesExtras3)*/Creates a new, lighter color, where 1.0 is the lightest and 0.0 is no change./*#-end-localizable-zone*/
    public func lighter(percent: Double = 0.2) -> UIColor {
        return withBrightness(percent: 1 + percent)
    }
    
    /// /*#-localizable-zone(shapesExtras4)*/Creates a new, darker color, where 1.0 is darkest and 0.0 is no change./*#-end-localizable-zone*/
    public func darker(percent: Double = 0.2) -> UIColor {
        return withBrightness(percent: 1 - percent)
    }
    
    /// /*#-localizable-zone(shapesExtras5)*/Creates a new Color with the given transparency, where 0.0  is completely transparent and 1.0 is completely opaque./*#-end-localizable-zone*/
    public func withAlpha(alpha: Double) -> Color {
        return self.withAlphaComponent(CGFloat(alpha))
    }
    
    /// /*#-localizable-zone(shapesExtras6)*/Creates a new Color with the given brightness, where 0.0 is the darkest and 1.0 is the brightest./*#-end-localizable-zone*/
    private func withBrightness(percent: Double) -> UIColor {
        var cappedPercent = min(percent, 1.0)
        cappedPercent = max(0.0, percent)
        
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness) * cappedPercent, alpha: Double(alpha))
    }
    
    /// /*#-localizable-zone(shapesExtras7)*/Picks a random color./*#-end-localizable-zone*/
    public static func random() -> UIColor {
        let uint32MaxAsFloat = Float(UInt32.max)
        let red = Double(Float(arc4random()) / uint32MaxAsFloat)
        let blue = Double(Float(arc4random()) / uint32MaxAsFloat)
        let green = Double(Float(arc4random()) / uint32MaxAsFloat)
        
        return Color(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

public extension Point {
    /// /*#-localizable-zone(shapesExtras8)*/Selects a random point within the radius of a circle./*#-end-localizable-zone*/
    func randomPoint(in radius: Double) -> Point {
        let alpha = 2 * Double.pi * Double.random(in: 0...radius)
        let r = radius * sqrt(Double.random(in: 0...radius))
        let x = r * cos(alpha) + self.x
        let y = r * sin(alpha) + self.y
        return Point(x: x, y: y)
    }
}

public extension Graphic {
    /// /*#-localizable-zone(shapesExtras9)*/Creates a slight pulsing animation on a graphic./*#-end-localizable-zone*/
    func pulse() {
        let currentScale = self.scale
        let scaleUp = SKAction.scale(by: 1.15, duration: 0.15)
        let scaleBack = SKAction.scale(to: CGFloat(currentScale), duration: 0.075)
        let sequence = SKAction.sequence([scaleUp, scaleBack])
        self.run(sequence)
    }
    
    /// /*#-localizable-zone(shapesExtras10)*/Makes the current graphic draggable./*#-end-localizable-zone*/
    var isDraggable: Bool {
        get {
            if self.hasHandler(forInteraction: .drag) {
                return true
            } else {
                return false
            }
            
        } set {
            if newValue {
                let handler: (Touch)->Void = {touch in
                    self.location = touch.position
                }
                self.setHandler(for: .drag, handler: handler)
            } else {
                self.removeHandler(forInteraction: .drag)
            }
        }
    }
}

public extension Sprite {
    /// /*#-localizable-zone(shapesExtras11)*/Makes the current graphic draggable./*#-end-localizable-zone*/
    var isDraggable: Bool {
        get {
            if self.hasHandler(forInteraction: .drag) {
                return true
            } else {
                return false
            }
            
        } set {
            if newValue {
                let handler: (Touch)->Void = {touch in
                    self.location = touch.position
                }
                self.setHandler(for: .drag, handler: handler)
            } else {
                self.removeHandler(forInteraction: .drag)
            }
        }
    }
}
