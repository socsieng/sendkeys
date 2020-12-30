import Foundation

class MouseController {
    let animationRefreshInterval: TimeInterval = 0.01
    
    func move(start: CGPoint, end: CGPoint, duration: TimeInterval) {
        let resolvedStart = resolveLocation(start)
        
        let animator = Animator(duration, animationRefreshInterval, { progress in
            let location = CGPoint(
                x: (Double(end.x - resolvedStart.x) * progress) + Double(resolvedStart.x),
                y: (Double(end.y - resolvedStart.y) * progress) + Double(resolvedStart.y)
            )
            self.setLocation(location)
        })
        
        animator.animate()
    }
    
    func click(_ location: CGPoint, button: CGMouseButton, clickCount: Int) {
        let resolvedLocation = resolveLocation(location)
        
        var downMouseType = CGEventType.leftMouseDown
        var upMouseType = CGEventType.leftMouseUp
        
        if button != .left {
            downMouseType = CGEventType.otherMouseDown
            upMouseType = CGEventType.otherMouseUp
        }
        
        let downEvent = CGEvent(mouseEventSource: nil, mouseType: downMouseType, mouseCursorPosition: resolvedLocation, mouseButton: button)
        downEvent?.post(tap: CGEventTapLocation.cghidEventTap)
        
        let upEvent = CGEvent(mouseEventSource: nil, mouseType: upMouseType, mouseCursorPosition: resolvedLocation, mouseButton: button)
        upEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    func drag(start: CGPoint, end: CGPoint, duration: TimeInterval, button: CGMouseButton) {
        let resolvedStart = resolveLocation(start)
        let animator = Animator(duration, animationRefreshInterval, { progress in
            let location = CGPoint(
                x: (Double(end.x - resolvedStart.x) * progress) + Double(resolvedStart.x),
                y: (Double(end.y - resolvedStart.y) * progress) + Double(resolvedStart.y)
            )
            self.setLocation(location)
        })
        
        var downMouseType = CGEventType.leftMouseDown
        var upMouseType = CGEventType.leftMouseUp
        
        if button != .left {
            downMouseType = CGEventType.otherMouseDown
            upMouseType = CGEventType.otherMouseUp
        }
        
        let downEvent = CGEvent(mouseEventSource: nil, mouseType: downMouseType, mouseCursorPosition: resolvedStart, mouseButton: button)
        downEvent?.post(tap: CGEventTapLocation.cghidEventTap)

        animator.animate()
        
        let upEvent = CGEvent(mouseEventSource: nil, mouseType: upMouseType, mouseCursorPosition: end, mouseButton: button)
        upEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    func getLocation() -> CGPoint? {
        let event = CGEvent(source: nil);
        return event?.location
    }
    
    private func setLocation(_ location: CGPoint, moveType: CGEventType = CGEventType.mouseMoved, button: CGMouseButton = CGMouseButton.left) {
        let moveEvent = CGEvent(mouseEventSource: nil, mouseType: moveType, mouseCursorPosition: location, mouseButton: button)
        moveEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    func resolveLocation(_ location: CGPoint) -> CGPoint {
        let currentLocation = getLocation()
        return CGPoint(
            x: location.x < 0 ? (currentLocation?.x ?? 0) : location.x,
            y: location.y < 0 ? (currentLocation?.y ?? 0) : location.y
        )
    }
}
