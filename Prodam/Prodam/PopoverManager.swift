import Cocoa

@objc protocol PopoverManagerDelegate {
    optional func openThatPopover()
    optional func closeThatPopover()
}

class PopoverManager: NSObject, ViewClicked, PopoverManagerDelegate {

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let popoverView = PopoverView()
    var popoverController = PopoverWindowController()
    var breakController = BreakWindowController()
    var popoverIsActive = false
    var delegate: PopoverManagerDelegate?

    // MARK: View lifecycle

    override init() {
        super.init()

        let iconMenu = NSImage(named: "menu-logo")
        iconMenu?.setTemplate(true)

        self.popoverView.frame = NSMakeRect(0, 0, NSStatusBar.systemStatusBar().thickness + 3, NSStatusBar.systemStatusBar().thickness)
        self.popoverView.delegate = self
        let imageView = NSImageView(frame: NSMakeRect(0, 0, NSStatusBar.systemStatusBar().thickness, NSStatusBar.systemStatusBar().thickness))
        imageView.image = iconMenu
        self.popoverView.addSubview(imageView)

        self.popoverController.popoverManager = self
        self.popoverController.loadWindow()
        self.delegate = self

        self.statusItem.view = self.popoverView
        openThatPopover()
    }

    // MARK: Icon clicked handlers

    func buttonClicked() {
        if self.popoverIsActive == false {
            openThatPopover()
        } else if self.popoverIsActive == true {
            closeThatPopover()
        }
    }

    // MARK: Delegate methods

    func openThatPopover() {
        self.popoverIsActive = true
        self.popoverController.popover.showRelativeToRect(NSMakeRect(self.popoverView.frame.origin.x, self.popoverView.frame.origin.y - 5, self.popoverView.frame.width, self.popoverView.frame.height), ofView: self.popoverView, preferredEdge: NSMaxYEdge)
        NSApp.activateIgnoringOtherApps(true)
        self.popoverController.window?.makeMainWindow()
        self.popoverController.popoverController.view.window?.makeFirstResponder(self.popoverController.popoverController.editableTimerTextField)
    }

    func closeThatPopover() {
        self.popoverIsActive = false
        self.popoverController.window?.resignMainWindow()
        self.popoverController.window?.resignKeyWindow()
        self.popoverController.window?.makeFirstResponder(nil)
        self.popoverController.popover.close()
    }
}
