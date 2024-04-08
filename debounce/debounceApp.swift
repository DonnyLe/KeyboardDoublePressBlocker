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

    @Environment(\.openWindow) private var openWindow
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewModel: ViewModel = ViewModel();
    @State var started: Bool = false;
    var body: some Scene {
        
        WindowGroup(id: "keyboard-view") {
            ContentView(appDelegate: appDelegate).environmentObject(viewModel).task { if(viewModel.checkAccess() && !started) {
                viewModel.start(appDelegate: appDelegate);
                started = true;
            }
                else {
                    print("need access")
                }
                
            }}
        MenuBarExtra("DebounceApp", systemImage: "hammer") {
            KeyboardViewButton()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            Button("Reset") {
                viewModel.resetKBData()
            }
        }
                
    }
    
}

struct KeyboardViewButton: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @State var showWindow: Bool = true;
     
    

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
    



