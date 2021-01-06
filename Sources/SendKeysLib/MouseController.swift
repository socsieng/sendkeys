import Foundation

class MouseController {
    enum ScrollAxis {
        case horizontal
        case vertical
    }
    
    let animationRefreshInterval: TimeInterval
    let keyPresser = KeyPresser()
    
    init(animationRefreshInterval: TimeInterval) {
        self.animationRefreshInterval = animationRefreshInterval
    }
    
    func move(start: CGPoint?, end: CGPoint, duration: TimeInterval, flags: CGEventFlags) {
        let resolvedStart = start ?? getLocation()!
        let eventSource = CGEventSource(event: nil)
        
        let animator = Animator(duration, animationRefreshInterval, { progress in
            let location = CGPoint(
                x: (Double(end.x - resolvedStart.x) * progress) + Double(resolvedStart.x),
                y: (Double(end.y - resolvedStart.y) * progress) + Double(resolvedStart.y)
            )
            self.setLocation(location, eventSource: eventSource, flags: flags)
        })
        
        animator.animate()
    }
    
    func click(_ location: CGPoint?, button: CGMouseButton, flags: CGEventFlags, clickCount: Int) {
        let resolvedLocation = location ?? getLocation()!
        
        var downMouseType = CGEventType.leftMouseDown
        var upMouseType = CGEventType.leftMouseUp
        
        if button == .right {
            downMouseType = CGEventType.rightMouseDown
            upMouseType = CGEventType.rightMouseUp
        } else if button != .left {
            downMouseType = CGEventType.otherMouseDown
            upMouseType = CGEventType.otherMouseUp
        }
        
        let downEvent = CGEvent(mouseEventSource: nil, mouseType: downMouseType, mouseCursorPosition: resolvedLocation, mouseButton: button)
        downEvent?.setIntegerValueField(.mouseEventClickState, value: Int64(clickCount))
        downEvent?.flags = flags
        downEvent?.post(tap: CGEventTapLocation.cghidEventTap)
        let eventSource = CGEventSource(event: downEvent)
        
        let upEvent = CGEvent(mouseEventSource: eventSource, mouseType: upMouseType, mouseCursorPosition: resolvedLocation, mouseButton: button)
        upEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    func drag(start: CGPoint?, end: CGPoint, duration: TimeInterval, button: CGMouseButton, flags: CGEventFlags) {
        let resolvedStart = start ?? getLocation()!
        var eventSource: CGEventSource?

        var downMouseType = CGEventType.leftMouseDown
        var upMouseType = CGEventType.leftMouseUp
        var moveType = CGEventType.leftMouseDragged

        let animator = Animator(duration, animationRefreshInterval, { progress in
            let location = CGPoint(
                x: (Double(end.x - resolvedStart.x) * progress) + Double(resolvedStart.x),
                y: (Double(end.y - resolvedStart.y) * progress) + Double(resolvedStart.y)
            )
            self.setLocation(location, eventSource: eventSource, moveType: moveType, button: button, flags: flags)
        })

        if button == .right {
            downMouseType = CGEventType.rightMouseDown
            upMouseType = CGEventType.rightMouseUp
            moveType = CGEventType.rightMouseDragged
        } else if button != .left {
            downMouseType = CGEventType.otherMouseDown
            upMouseType = CGEventType.otherMouseUp
            moveType = CGEventType.otherMouseDragged
        }
        
        let downEvent = CGEvent(mouseEventSource: nil, mouseType: downMouseType, mouseCursorPosition: resolvedStart, mouseButton: button)
        downEvent?.flags = flags
        downEvent?.post(tap: CGEventTapLocation.cghidEventTap)
        eventSource = CGEventSource(event: downEvent)

        animator.animate()
        
        let upEvent = CGEvent(mouseEventSource: eventSource, mouseType: upMouseType, mouseCursorPosition: end, mouseButton: button)
        upEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    func scroll(_ delta: CGPoint, _ duration: TimeInterval, flags: CGEventFlags) {
        var scrolledX: Int = 0;
        var scrolledY: Int = 0;
        let eventSource = CGEventSource(event: nil)

        let animator = Animator(duration, animationRefreshInterval, { progress in
            if delta.x != 0 {
                let amount = Int((Double(delta.x) * progress) - Double(scrolledX))
                scrolledX += amount
                
                self.scrollBy(amount, .horizontal, eventSource: eventSource, flags: flags)
            }
            if delta.y != 0 {
                let amount = Int((Double(delta.y) * progress) - Double(scrolledY))
                scrolledY += amount
                
                self.scrollBy(amount, .vertical, eventSource: eventSource, flags: flags)
            }
        })
        
        animator.animate()
    }
    
    func scrollBy(_ amount: Int, _ axis: ScrollAxis, eventSource: CGEventSource?, flags: CGEventFlags) {
        if #available(OSX 10.13, *) {
            let event = CGEvent(scrollWheelEvent2Source: eventSource, units: .pixel, wheelCount: 1, wheel1: 0, wheel2: 0, wheel3: 0)
            let field = axis == .vertical ? CGEventField.scrollWheelEventPointDeltaAxis1 : CGEventField.scrollWheelEventPointDeltaAxis2
            
            event?.setIntegerValueField(field, value: Int64(amount * -1))
            event?.flags = flags

            event?.post(tap: CGEventTapLocation.cghidEventTap)
        } else {
            fatalError("Scrolling is only available on 10.13 or later\n")
        }
    }
    
    func getLocation() -> CGPoint? {
        let event = CGEvent(source: nil);
        return event?.location
    }
    
    private func setLocation(_ location: CGPoint, eventSource: CGEventSource?, moveType: CGEventType = CGEventType.mouseMoved, button: CGMouseButton = CGMouseButton.left, flags: CGEventFlags = []) {
        let moveEvent = CGEvent(mouseEventSource: eventSource, mouseType: moveType, mouseCursorPosition: location, mouseButton: button)
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
