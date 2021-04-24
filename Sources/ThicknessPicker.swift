import SpriteKit

/// /*#-localizable-zone(thicknessPicker1)*/A custom picker used to select the thickness of the brush in the drawing toolbar./*#-end-localizable-zone*/
public class ThicknessPicker: SideBarPlaceable {
    var width = 400
    var height = 60
    var elementSize = 40
    
    /// /*#-localizable-zone(thicknessPicker2)*/An event handler that’s called when selecting a thickness./*#-end-localizable-zone*/
    public var onSelectedValue: ((Int) -> Void) = { _ in }
    
    /// /*#-localizable-zone(thicknessPicker3)*/The toolbar icon for the thickness picker./*#-end-localizable-zone*/
    public var icon = Graphic.line(length: 40, thickness: 15, color: .black)
    
    /// /*#-localizable-zone(thicknessPicker4)*/Removes all graphics associated with the thickness picker./*#-end-localizable-zone*/
    public func dismiss() {
        scene.removeGraphics(named: "ThicknessPicker")
    }
    
    public init() {
        icon.rotation = 90
    }
    
    /// /*#-localizable-zone(thicknessPicker5)*/Draws and sets up the thickness picker./*#-end-localizable-zone*/
    public func draw(at point: Point) {
        let rect = Graphic.rectangle(width: width + 20, height: height + 10, cornerRadius: 20, color: #colorLiteral(red: 0.9214347004890442, green: 0.9214347004890442, blue: 0.9214347004890442, alpha: 1.0))
        rect.name = "ThicknessPicker"
        scene.place(rect, at: point, anchoredTo: .left)
        
        let columns = width / elementSize
        let columnDistance = Double(width) / Double(columns)
        var currentPosition = Point(x: point.x + 25, y: point.y)
        
        for i in 1...columns {
            var thickness = Double(i) * 3
            let line = Graphic.line(length: 40, thickness: Int(thickness), color: .black)
            let overlayCircle = Graphic.circle(radius: 20, color: .clear)
            overlayCircle.name = "ThicknessPicker"
            line.name = "ThicknessPicker"
            line.rotation = 90
            scene.place(line, at: currentPosition)
            scene.place(overlayCircle, at: currentPosition)
            
            overlayCircle.setOnTouchHandler { [self] _ in
                line.run(SKAction.scale(to: 1.5, duration: 0.2)) {
                    onSelectedValue(Int(thickness))
                    dismiss()
                }
            }
            
            currentPosition.x += columnDistance
        }
        
    }
}
