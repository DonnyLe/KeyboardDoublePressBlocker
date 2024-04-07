//
//  debounceApp.swift
//  debounce
//
//  Created by Donny Le on 1/26/24.
//

import SwiftUI
import Cocoa

@main
struct debounceApp: App {

    
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewModel: ViewModel = ViewModel();
    var body: some Scene {
        MenuBarExtra("UtilityApp", systemImage: "hammer") {
            KeyboardViewButton()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        
        WindowGroup(id: "keyboard-view") {
            ContentView(appDel: appDelegate).environmentObject(viewModel)
        }
                
    }
    
}

struct KeyboardViewButton: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @State var showWindow: Bool = false;


    var body: some View {
        Button("Settings") {
            if(showWindow) {
                dismissWindow(id: "keyboard-view")
            } else {
                dismissWindow(id: "keyboard-view")
                openWindow(id: "keyboard-view")
            }
            self.showWindow = !self.showWindow;
            
        }
    }
}
    



