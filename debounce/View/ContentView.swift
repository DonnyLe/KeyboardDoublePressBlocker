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
    @State var appDel: AppDelegate;
 
    
    
    
    var body: some View {
        
        VStack {
            

            var started: Bool = false;
            Keyboard().onTapGesture {
                
                
                if(viewModel.checkAccess() && !started) {
                    viewModel.start(appDelegate: appDel);
                    started = true;
                }
                else {
                    print("need access")
                }
            }
            HStack {
            
                var strDelay: String = String((floor(delay * 100) / 100));
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

//#Preview {
//    ContentView()
//}


