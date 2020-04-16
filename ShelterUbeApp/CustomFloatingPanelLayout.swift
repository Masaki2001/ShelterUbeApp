
import UIKit
import FloatingPanel

class CustomFloatingPanelLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .half
    }
    
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .half, .tip]
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
            case .full: return 20
            case .half: return 275.0
            case .tip: return 80.0
            default: return nil
        }
    }
    
    
}
