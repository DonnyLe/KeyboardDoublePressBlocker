//
//  ContentView.swift
//  debounce
//
//  Created by Donny Le on 1/26/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel;
    @State private var delay: Double = 0.1
    @EnvironmentObject var data: DatabaseManagement;
    var appDelegate: AppDelegate;
 
    
    
    
    var body: some View {

        VStack {
            Keyboard()
            HStack {
            
                let strDelay: String = String((floor(delay * 100) / 100));
                Text("Debounce Delay: " + strDelay)
                
                Slider (
                    value: $delay,
                    in: 0...1,
                    onEditingChanged: {editing in
                        viewModel.changeDelay(delay: delay)
                        
                    }
                )
            }
        }
        .padding()
    }
}



