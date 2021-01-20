import Foundation

class MouseController {
    enum ScrollAxis {
        case horizontal
        case vertical
    }

    enum mouseEventType {
        case up
        case down
        case move
        case drag
    }

    let animationRefreshInterval: TimeInterval
    let keyPresser = KeyPresser()
    var downButtons = Set<CGMouseButton>()

    init(animationRefreshInterval: TimeInterval) {
        self.animationRefreshInterval = animationRefreshInterval
    }

    func move(start: CGPoint?, end: CGPoint, duration: TimeInterval, flags: CGEventFlags) {
        let resolvedStart = start ?? getLocation()!
        let eventSource = CGEventSource(event: nil)
        let button = downButtons.first
        let moveType = getEventType(.move, button)

        let animator = Animator(
            duration, animationRefreshInterval,
            { progress in
                let location = CGPoint(
                    x: (Double(end.x - resolvedStart.x) * progress) + Double(resolvedStart.x),
                    y: (Double(end.y - resolvedStart.y) * progress) + Double(resolvedStart.y)
                )
                self.setLocation(location, eventSource: eventSource, moveType: moveType, button: button, flags: flags)
            })

        animator.animate()
    }

    func click(_ location: CGPoint?, button: CGMouseButton, flags: CGEventFlags, clickCount: Int) {
        let resolvedLocation = location ?? getLocation()!
        let downMouseType = getEventType(.down, button)
        let upMouseType = getEventType(.up, button)

        let downEvent = CGEvent(
            mouseEventSource: nil, mouseType: downMouseType, mouseCursorPosition: resolvedLocation, mouseButton: button)
        downEvent?.setIntegerValueField(.mouseEventClickState, value: Int64(clickCount))
        downEvent?.flags = flags
        downEvent?.post(tap: CGEventTapLocation.cghidEventTap)
        let eventSource = CGEventSource(event: downEvent)

        let upEvent = CGEvent(
            mouseEventSource: eventSource, mouseType: upMouseType, mouseCursorPosition: resolvedLocation,
            mouseButton: button)
        upEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }

    func down(_ location: CGPoint?, button: CGMouseButton, flags: CGEventFlags) {
        let resolvedLocation = location ?? getLocation()!
        let downMouseType = getEventType(.down, button)

        let downEvent = CGEvent(
            mouseEventSource: nil, mouseType: downMouseType, mouseCursorPosition: resolvedLocation, mouseButton: button)
        downEvent?.flags = flags
        downEvent?.post(tap: CGEventTapLocation.cghidEventTap)

        downButtons.insert(button)
    }

    func up(_ location: CGPoint?, button: CGMouseButton, flags: CGEventFlags) {
        let resolvedLocation = location ?? getLocation()!
        let upMouseType = getEventType(.up, button)

        let upEvent = CGEvent(
            mouseEventSource: nil, mouseType: upMouseType, mouseCursorPosition: resolvedLocation,
            mouseButton: button)
        upEvent?.post(tap: CGEventTapLocation.cghidEventTap)
        downButtons.remove(button)
    }

    func drag(start: CGPoint?, end: CGPoint, duration: TimeInterval, button: CGMouseButton, flags: CGEventFlags) {
        let resolvedStart = start ?? getLocation()!
        let downMouseType = getEventType(.down, button)
        let upMouseType = getEventType(.up, button)
        let moveType = getEventType(.drag, button)
        var eventSource: CGEventSource?

        let animator = Animator(
            duration, animationRefreshInterval,
            { progress in
                let location = CGPoint(
                    x: (Double(end.x - resolvedStart.x) * progress) + Double(resolvedStart.x),
                    y: (Double(end.y - resolvedStart.y) * progress) + Double(resolvedStart.y)
                )
                self.setLocation(location, eventSource: eventSource, moveType: moveType, button: button, flags: flags)
            })

        if !downButtons.contains(button) {
            let downEvent = CGEvent(
                mouseEventSource: nil, mouseType: downMouseType, mouseCursorPosition: resolvedStart, mouseButton: button
            )
            downEvent?.flags = flags
            downEvent?.post(tap: CGEventTapLocation.cghidEventTap)
            eventSource = CGEventSource(event: downEvent)
        }

        animator.animate()

        if !downButtons.contains(button) {
            let upEvent = CGEvent(
                mouseEventSource: eventSource, mouseType: upMouseType, mouseCursorPosition: end, mouseButton: button)
            upEvent?.post(tap: CGEventTapLocation.cghidEventTap)
        }
    }

    func scroll(_ delta: CGPoint, _ duration: TimeInterval, flags: CGEventFlags) {
        var scrolledX: Int = 0
        var scrolledY: Int = 0
        let eventSource = CGEventSource(event: nil)

        let animator = Animator(
            duration, animationRefreshInterval,
            { progress in
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

    func circle(_ center: CGPoint, _ radius: CGPoint, _ fromAngle: Double, _ toAngle: Double, _ duration: TimeInterval)
    {
        let eventSource = CGEventSource(event: nil)
        let ANGLE_OFFSET: Double = -90
        let button = downButtons.first
        let moveType = getEventType(.move, button)

        let animator = Animator(
            duration, animationRefreshInterval,
            { progress in
                let angle = (toAngle - fromAngle) * progress + fromAngle + ANGLE_OFFSET
                let location = CGPoint(
                    x: cos(angle * Double.pi / 180) * Double(radius.x) + Double(center.x),
                    y: sin(angle * Double.pi / 180) * Double(radius.y) + Double(center.y)
                )
                self.setLocation(location, eventSource: eventSource, moveType: moveType, button: .left, flags: [])
            })

        animator.animate()
    }

    func scrollBy(_ amount: Int, _ axis: ScrollAxis, eventSource: CGEventSource?, flags: CGEventFlags) {
        if #available(OSX 10.13, *) {
            let event = CGEvent(
                scrollWheelEvent2Source: eventSource, units: .pixel, wheelCount: 1, wheel1: 0, wheel2: 0, wheel3: 0)
            let field =
                axis == .vertical
                ? CGEventField.scrollWheelEventPointDeltaAxis1 : CGEventField.scrollWheelEventPointDeltaAxis2

            event?.setIntegerValueField(field, value: Int64(amount * -1))
            event?.flags = flags

            event?.post(tap: CGEventTapLocation.cghidEventTap)
        } else {
            fatalError("Scrolling is only available on 10.13 or later\n")
        }
    }

    func getLocation() -> CGPoint? {
        let event = CGEvent(source: nil)
        return event?.location
    }

    private func setLocation(
        _ location: CGPoint, eventSource: CGEventSource?, moveType: CGEventType = CGEventType.mouseMoved,
        button: CGMouseButton? = nil, flags: CGEventFlags = []
    ) {
        let moveEvent = CGEvent(
            mouseEventSource: eventSource, mouseType: moveType, mouseCursorPosition: location,
            mouseButton: button ?? CGMouseButton.left)
        moveEvent?.flags = flags
        moveEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }

    private func getEventType(_ mouseType: mouseEventType, _ button: CGMouseButton? = nil) -> CGEventType {
        switch mouseType {
        case .up:
            if button == CGMouseButton.left {
                return CGEventType.leftMouseUp
            } else if button == CGMouseButton.right {
                return CGEventType.rightMouseUp
            } else {
                return CGEventType.otherMouseUp
            }
        case .down:
            if button == CGMouseButton.left {
                return CGEventType.leftMouseDown
            } else if button == CGMouseButton.right {
                return CGEventType.rightMouseDown
            } else {
                return CGEventType.otherMouseDown
            }
        case .move:
            if button == nil {
                return CGEventType.mouseMoved
            } else if button == CGMouseButton.left {
                return CGEventType.leftMouseDragged
            } else if button == CGMouseButton.right {
                return CGEventType.rightMouseDragged
            } else {
                return CGEventType.otherMouseDragged
            }
        case .drag:
            if button == CGMouseButton.left {
                return CGEventType.leftMouseDragged
            } else if button == CGMouseButton.right {
                return CGEventType.rightMouseDragged
            } else {
                return CGEventType.otherMouseDragged
            }
        }
    }

    private func resolveLocation(_ location: CGPoint) -> CGPoint {
        let currentLocation = getLocation()
        return CGPoint(
            x: location.x < 0 ? (currentLocation?.x ?? 0) : location.x,
            y: location.y < 0 ? (currentLocation?.y ?? 0) : location.y
        )
    }
}
