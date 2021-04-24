import PlaygroundSupport
import SPCCore
import UIKit

/// /*#-localizable-zone(setUpLiveView1)*/A global instance of Scene./*#-end-localizable-zone*/
public let scene = Scene(size: Scene.sceneSize)

/// /*#-localizable-zone(setUpLiveView2)*/Sets up the Live View using the scene’s SKView./*#-end-localizable-zone*/
public func setUpLiveView(presentation: LiveViewContentPresentation = .aspectFitMaximum) {
    LiveViewController.contentPresentation = presentation
    let liveViewController = LiveViewController()
    liveViewController.contentView = scene.skView
    PlaygroundPage.current.liveView = liveViewController
    liveViewController.backgroundImage = UIImage.from(color: UIColor(named: "scene_background_color") ?? .systemBackground)
    scene.backgroundColor = UIColor(named: "scene_background_color") ?? .systemBackground
}
