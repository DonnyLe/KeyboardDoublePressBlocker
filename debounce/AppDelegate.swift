import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var databaseManagement: DatabaseManagement
    var viewModel: ViewModel?
    override init() {
        databaseManagement = DatabaseManagement()
        super.init()

    }
    
    func addViewModelObserver(viewModel: ViewModel){
        self.viewModel = viewModel
    }
    
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        viewModel?.updateKeyInfo()


    }

}
