import UIKit

internal final class WindowOverlayWindow: UIWindow {
  override init(windowScene: UIWindowScene) {
    super.init(windowScene: windowScene)
    // Above sheets and the keyboard, below system alerts.
    self.windowLevel = .alert - 1
    self.backgroundColor = .clear
  }
  required init?(coder: NSCoder) { fatalError() }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard let rootView = rootViewController?.view,
          let hitView = super.hitTest(point, with: event)
    else { return nil }

    // UIKit-backed controls, and before iOS 18 everything SwiftUI draws, are hit as subviews of the hosting view.
    if hitView !== rootView {
      return hitView
    }
    // From iOS 18, the hosting view takes the hit for what SwiftUI draws, so look for a layer under its own.
    if #available(iOS 18.0, *),
       let layer = rootView.layer.hitTest(point),
       layer !== rootView.layer
    {
      return hitView
    }
    return nil
  }
}
