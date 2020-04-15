
import UIKit
import FloatingPanel

class CustomFloatingPanelLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.half, .tip]
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
            case .half: return 346.0
            case .tip: return 80.0
            default: return nil
        }
    }
    
    
}
