import Foundation

class MouseController {
    enum ScrollAxis {
        case horizontal
        case vertical
    }
    
    let animationRefreshInterval: TimeInterval = 0.01
    
    func move(start: CGPoint, end: CGPoint, duration: TimeInterval, flags: CGEventFlags) {
        let resolvedStart = resolveLocation(start)
        
        let animator = Animator(duration, animationRefreshInterval, { progress in
            let location = CGPoint(
                x: (Double(end.x - resolvedStart.x) * progress) + Double(resolvedStart.x),
                y: (Double(end.y - resolvedStart.y) * progress) + Double(resolvedStart.y)
            )
            self.setLocation(location, flags: flags)
        })
        
        animator.animate()
    }
    
    func click(_ location: CGPoint, button: CGMouseButton, flags: CGEventFlags, clickCount: Int) {
        let resolvedLocation = resolveLocation(location)
        
        var downMouseType = CGEventType.leftMouseDown
        var upMouseType = CGEventType.leftMouseUp
        
        if button != .left {
            downMouseType = CGEventType.otherMouseDown
            upMouseType = CGEventType.otherMouseUp
        }
        
        let downEvent = CGEvent(mouseEventSource: nil, mouseType: downMouseType, mouseCursorPosition: resolvedLocation, mouseButton: button)
        downEvent?.flags = flags
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
    
    func scroll(_ delta: CGPoint, _ duration: TimeInterval) {
        var scrolledX: Int = 0;
        var scrolledY: Int = 0;
        
        let animator = Animator(duration, animationRefreshInterval, { progress in
            if delta.x != 0 {
                let amount = Int((Double(delta.x) * progress) - Double(scrolledX))
                scrolledX += amount
                
                self.scrollBy(amount, .horizontal)
            }
            if delta.y != 0 {
                let amount = Int((Double(delta.y) * progress) - Double(scrolledY))
                scrolledY += amount
                
                self.scrollBy(amount, .vertical)
            }
        })
        
        animator.animate()
    }
    
    func scrollBy(_ amount: Int, _ axis: ScrollAxis) {
        if #available(OSX 10.13, *) {
            let event = CGEvent(scrollWheelEvent2Source: nil, units: .pixel, wheelCount: 1, wheel1: 0, wheel2: 0, wheel3: 0)
            let field = axis == .vertical ? CGEventField.scrollWheelEventPointDeltaAxis1 : CGEventField.scrollWheelEventPointDeltaAxis2
            
            event?.setIntegerValueField(field, value: Int64(amount * -1))
            event?.post(tap: CGEventTapLocation.cghidEventTap)
        } else {
            fatalError("Scrolling is only available on 10.13 or later\n")
        }
    }
    
    func getLocation() -> CGPoint? {
        let event = CGEvent(source: nil);
        return event?.location
    }
    
    private func setLocation(_ location: CGPoint, moveType: CGEventType = CGEventType.mouseMoved, button: CGMouseButton = CGMouseButton.left, flags: CGEventFlags = []) {
        let moveEvent = CGEvent(mouseEventSource: nil, mouseType: moveType, mouseCursorPosition: location, mouseButton: button)
        moveEvent?.flags = flags
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
