import Foundation

enum MouseEventType {
    case click
    case drag
}

enum MouseButton: String, CustomStringConvertible {
    case left
    case right
    case center
    case other

    var description: String {
        get {
            return self.rawValue
        }
    }
}

struct RawMouseEvent {
    let eventType: CGEventType
    let button: MouseButton
    let point: CGPoint

    init(eventType: CGEventType, button: MouseButton, point: CGPoint) {
        self.eventType = eventType
        self.button = button
        self.point = point
    }
}

struct MouseEvent {
    let eventType: MouseEventType
    let button: MouseButton
    let startPoint: CGPoint
    let endPoint: CGPoint
    let duration: TimeInterval

    init(eventType: MouseEventType, button: MouseButton, startPoint: CGPoint, endPoint: CGPoint, duration: TimeInterval) {
        self.eventType = eventType
        self.button = button
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.duration = duration
    }
}

class MouseEventProcessor {
    var events: [RawMouseEvent] = []
    var lastDate: Date = Date()

    func consumeEvent(type: CGEventType, event: CGEvent) -> MouseEvent? {
        let button = getMouseButton(type: type, event: event)
        let rawEvent = RawMouseEvent(eventType: type, button: button, point: event.location)
        var mouseEvent: MouseEvent? = nil

        switch type {
        case .leftMouseUp, .rightMouseUp, .otherMouseUp:
            switch events.last?.eventType {
            case .leftMouseDown, .rightMouseDown, .otherMouseDown:
                mouseEvent = MouseEvent(eventType: .click, button: button, startPoint: events.first!.point, endPoint: event.location, duration: -lastDate.timeIntervalSinceNow)
            case .leftMouseDragged, .rightMouseDragged, .otherMouseDragged:
                mouseEvent = MouseEvent(eventType: .drag, button: button, startPoint: events.first!.point, endPoint: event.location, duration: -lastDate.timeIntervalSinceNow)
            default:
                events.append(rawEvent)
            }

            lastDate = Date()
            events = []
        default:
            events.append(rawEvent)
        }

        return mouseEvent
    }

    private func getMouseButton(type: CGEventType, event: CGEvent) -> MouseButton {
        var button: MouseButton = .other

        switch type {
        case .leftMouseDown, .leftMouseUp, .leftMouseDragged:
            button = .left
        case .rightMouseDown, .rightMouseUp, .rightMouseDragged:
            button = .right
        case .otherMouseDown, .otherMouseUp, .otherMouseDragged:
            let buttonNumber = event.getIntegerValueField(.mouseEventButtonNumber)
            switch UInt32(buttonNumber) {
            case CGMouseButton.left.rawValue:
                button = .left
            case CGMouseButton.right.rawValue:
                button = .right
            case CGMouseButton.center.rawValue:
                button = .center
            default:
                button = .other
            }
        default:
            button = .other
        }

        return button
    }
}
