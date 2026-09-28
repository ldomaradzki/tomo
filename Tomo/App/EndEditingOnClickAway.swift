import AppKit

/// Ends text editing when the user clicks anywhere that isn't a text field.
/// AppKit doesn't do this on its own: clicking a label, empty pane space, or
/// a SwiftUI grid leaves the field editor active.
///
/// Runs before the click is dispatched, so an in-progress edit commits
/// (through the field's own blur handler) before the click selects another
/// book.
enum EndEditingOnClickAway {
    static func install() {
        NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { event in
            endEditingIfClickedAway(event)
            return event
        }
    }

    private static func endEditingIfClickedAway(_ event: NSEvent) {
        guard let window = event.window,
            let editor = window.firstResponder as? NSTextView, editor.isFieldEditor,
            let contentView = window.contentView
        else { return }

        // `hitTest` takes a point in the receiver's superview's coordinates.
        let point = contentView.superview?.convert(event.locationInWindow, from: nil)
            ?? event.locationInWindow
        let hit = contentView.hitTest(point)
        let clickedTextField = sequence(first: hit, next: { $0?.superview }).contains {
            $0 is NSTextField || $0 is NSTextView
        }
        if !clickedTextField {
            window.makeFirstResponder(nil)
        }
    }
}
