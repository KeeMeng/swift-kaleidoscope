import Foundation
import CoreGraphics
import UIKit

var defaultDrawingColor = UIColor(named: "drawing_default_color") ?? .black

/// /*#-localizable-zone(drawing1)*/Requirements for placing a graphic in the drawing toolbar./*#-end-localizable-zone*/
public protocol SideBarPlaceable {
    var icon: Graphic { get set }
}

/// /*#-localizable-zone(drawing3)*/Requirements for a brush./*#-end-localizable-zone*/
public protocol Brush: SideBarPlaceable {
    var thickness: Int { get set }
    var color: Color { get set }
    var handleTouch: ((Touch) -> Void) { get set }
}

/// /*#-localizable-zone(drawing4)*/Draws a series of circles to create free-form lines./*#-end-localizable-zone*/
public class Pen: Brush, SideBarPlaceable {
    public var icon: Graphic = Graphic(image: #imageLiteral(resourceName: "Pen tool_@2x.png"))
    public var thickness: Int = 5
    public var handleTouch: ((Touch) -> Void) = { _ in }
    public var color: Color = defaultDrawingColor
    
    public init() {
        handleTouch = { [self] touch in
            let circle = Graphic.circle(radius: Int(self.thickness / 2), color: self.color)
            scene.place(circle, at: touch.position)
        }
    }
}

/// /*#-localizable-zone(drawing5)*/Draws a line from the previous touch point to the current touch point./*#-end-localizable-zone*/
public class Lines: Brush, SideBarPlaceable {
    public var icon: Graphic = Graphic(image: #imageLiteral(resourceName: "Line tool_@2x.png"))
    public var thickness: Int = 5
    public var handleTouch: ((Touch) -> Void) = { _ in }
    public var color: Color = defaultDrawingColor
    public var previousTouchPoint: Point? = nil
    
    
    public init() {
        handleTouch = { [self] touch in
            if previousTouchPoint == nil {
                previousTouchPoint = touch.position
            }
            
            let line = Graphic.line(start: previousTouchPoint!, end: touch.position, thickness: self.thickness, color: self.color)
            scene.place(line)
            
            previousTouchPoint = touch.position
        }
    }
}

/// /*#-localizable-zone(drawing6)*/Simulates spray paint by drawing a series of variously-sized circles./*#-end-localizable-zone*/
public class SprayPaint: Brush, SideBarPlaceable {
    public var icon: Graphic = Graphic(image: #imageLiteral(resourceName: "Spraypaint_@2x.png"))
    public var thickness: Int = 5
    public var handleTouch: ((Touch) -> Void) = { _ in }
    public var color: Color = defaultDrawingColor
    
    public init() {
        handleTouch = { [self] touch in
            for i in 1...Int.random(in: 10...30) {
                let randomRadius = (self.thickness / self.thickness) + Int.random(in: 0...(thickness / 2))
                let circle = Graphic.circle(radius: randomRadius, color: self.color)
                
                let randomPoint = touch.position.randomPoint(in: Double(thickness))
                guard randomPoint.x > -410 else { continue }
                scene.place(circle, at: randomPoint)
            }
        }
    }
}

/// /*#-localizable-zone(drawing7)*/Removes any graphic within the brush’s path./*#-end-localizable-zone*/
public class Eraser: Brush, SideBarPlaceable {
    public var handleTouch: ((Touch) -> Void) = { _ in }
    public var icon: Graphic = Graphic(image: #imageLiteral(resourceName: "Eraser_@2x.png"))
    public var thickness: Int = 30
    public var color: Color = .white
    
    public init() {
        handleTouch = { [self] touch in
            let graphics = scene.getGraphics(at: touch.position, in: Size(width: self.thickness * 2, height: self.thickness * 2))
            scene.remove(graphics)
        }
    }
    
}

/// /*#-localizable-zone(drawing8)*/Sets up the drawing app. Contains the color picker, thickness picker, and all added brushes./*#-end-localizable-zone*/
public class DrawingToolBar {
    var height: Int
    var width = 90
    var sideBarSpacing: Double = 85
    var sideRect: Graphic
    let colorPicker = ColorPicker()
    let thicknessPicker = ThicknessPicker()
    
    /// /*#-localizable-zone(drawing10)*/Maximum number of brushes./*#-end-localizable-zone*/
    let maxBrushes = 6
    
    /// /*#-localizable-zone(drawing11)*/All of the brushes in the toolbar./*#-end-localizable-zone*/
    var brushes: [Brush] = []
    
    /// /*#-localizable-zone(drawing12)*/The currently selected brush./*#-end-localizable-zone*/
    var selectedBrush: Brush = Pen()
    
    /// /*#-localizable-zone(drawing13)*/Sets up the toolbar./*#-end-localizable-zone*/
    public init(brushes: [Brush]) {
        self.brushes = brushes
        
        height = 250 + (brushes.count * 75)
        
        if let brush = brushes.first {
            selectedBrush = brush
        } else {
            selectedBrush = Pen()
        }
        
        sideRect = Graphic.rectangle(width: width, height: height, cornerRadius: 20, color: #colorLiteral(red: 0.7999293208, green: 0.8000453115, blue: 0.7999039292, alpha: 1.0))
        
        setUpSideBar()
        enableDrawing()
    }
    
    /// /*#-localizable-zone(drawing14)*/Enables drawing on the canvas./*#-end-localizable-zone*/
    func enableDrawing() {
        scene.setOnTouchMovedHandler { touch in
            // /*#-localizable-zone(drawing001)*/Prevents touch events in the toolbar space./*#-end-localizable-zone*/
            guard touch.position.x > -410 else { return }
            self.selectedBrush.handleTouch(touch)
        }
    }
    
    /// /*#-localizable-zone(drawing16)*/Disables drawing on the canvas./*#-end-localizable-zone*/
    func disableDrawing() {
        scene.setOnTouchMovedHandler { touch in
            // /*#-localizable-zone(drawing18)*/Drawing disabled./*#-end-localizable-zone*/
        }
    }
    
    /// /*#-localizable-zone(drawing19)*/Adds all pickers and brushes to the toolbar./*#-end-localizable-zone*/
    func setUpSideBar() {
        var brushCount = 0
        scene.place(sideRect, at: Point(x: -460, y: 0))
        
        var selectorPosition = Point(x: -460, y: sideRect.location.y + Double((height/2)) - 60)
        
        for brush in brushes {
            guard brushCount < maxBrushes else { continue }
            
            if let brush = brushes.first {
                brush.icon.setImageColor(to: .systemPurple)
            }
            
            brush.icon.setOnTouchHandler {_ in
                brush.icon.pulse()
                self.selectedBrush.icon.setImageColor(to: .black)
                brush.icon.setImageColor(to: .systemPurple)
                self.selectedBrush = brush
            }
            scene.place(brush.icon, at: selectorPosition)
            selectorPosition.y -= sideBarSpacing
            brushCount += 1
        }
        
        // /*#-localizable-zone(drawing20)*/Adds the color picker./*#-end-localizable-zone*/
        scene.place(colorPicker.icon, at: selectorPosition)
        colorPicker.icon.setOnTouchHandler { [self] _ in
            colorPicker.icon.pulse()
            colorPicker.draw(at: selectorPosition)
            disableDrawing()
            colorPicker.onSelectedColor = { color in
                colorPicker.icon.backgroundColor = color
                for var brush in brushes {
                    brush.color = color
                }
                enableDrawing()
            }
        }
        
        // /*#-localizable-zone(drawing21)*/Adds the thickness picker./*#-end-localizable-zone*/
        selectorPosition.y -= sideBarSpacing
        let overlayCircle = Graphic.circle(radius: 20, color: .clear)
        scene.place(thicknessPicker.icon, at: selectorPosition)
        scene.place(overlayCircle, at: selectorPosition)
        overlayCircle.setOnTouchHandler { [self] _ in
            thicknessPicker.icon.pulse()
            thicknessPicker.draw(at: selectorPosition)
            disableDrawing()
            thicknessPicker.onSelectedValue = { thickness in
                for var brush in brushes {
                    brush.thickness = thickness
                }
                thicknessPicker.icon.size.height = CGFloat(thickness)
                enableDrawing()
            }
        }
        
        // /*#-localizable-zone(drawing22)*/Dismisses pickers when you touch outside of them./*#-end-localizable-zone*/
        scene.setOnTouchHandler( { [self] touch in
            thicknessPicker.dismiss()
            colorPicker.dismiss()
            enableDrawing()
        })
    }
}
