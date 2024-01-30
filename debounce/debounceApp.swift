//
//  debounceApp.swift
//  debounce
//
//  Created by Donny Le on 1/26/24.
//

import SwiftUI

@main
struct debounceApp: App {
    @StateObject var model: Model = Model();
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
        }
    }
}


