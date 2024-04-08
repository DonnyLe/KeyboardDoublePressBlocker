//
//  Keys.swift
//  debounce
//
//  Created by Donny Le on 1/27/24.
//

import Foundation
import SwiftUI;

@Observable class Keys: Identifiable{
    var pressedTimeStamp: Double;
    var releasedTimeStamp: Double;
    var keyName: String;
    var doublePresses: Int;
    var doubleReleases: Int;

    var presses: Int;
    var releases: Int;
    var id = UUID()
    var delay: Double = 0.1;

    
    
    init(_ keyName: String) {
        self.keyName = keyName;
        self.pressedTimeStamp = 0;
        self.releasedTimeStamp = 0;
        self.presses = 0;
        self.doublePresses = 0;
        self.releases = 0;
        self.doubleReleases = 0;
    }
    
    func setReleasedTimeStamp(time: Double) {
        self.releasedTimeStamp = time;
    }
    
    func setPressedTimeStamp(time: Double) {
        self.pressedTimeStamp = time;
    }
    
    func isDoublePress(time: Double) -> Bool {
//        print("Prev Time: \(self.pressedTimeStamp)");
//              print("Curr Time: \(time)");
        self.presses += 1;
        if(self.releasedTimeStamp < self.pressedTimeStamp) {
//            print("entered")
            return false
        }
        if((time - self.pressedTimeStamp) < self.delay) {
            self.doublePresses += 1;
            return true;
        } else {
            return false;
        }
    }
    
    func getPercentageOfDoublePress() -> Double {
        if(self.presses > 0) {
            return Double (self.doublePresses) / Double( self.presses);
        }
        return 0;
    }
    
    
}
