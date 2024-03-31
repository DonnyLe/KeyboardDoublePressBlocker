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
        WindowGroup {
            ContentView(appDel: appDelegate).environmentObject(viewModel)
            }
        
          
        }
        
    }
    



