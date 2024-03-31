//
//  Model.swift
//  DebounceMac
//
//  Created by Donny Le on 1/21/24.
//
//Credit to several Stackoverflow articles and Githubs (ran into many bugs in getting CGEvents working:
//https://gist.github.com/osnr/23eb05b4e0bcd335c06361c4fabadd6f
//https://github.com/nobu-g/DebounceMac/blob/master/Sources/DebounceMac/main.swift
//https://stackoverflow.com/questions/5785630/modify-nsevent-to-send-a-different-key-than-the-one-that-was-pressed/5785895#5785895
//https://stackoverflow.com/questions/49716420/adding-a-global-monitor-with-nseventmaskkeydown-mask-does-not-trigger
//https://github.com/creasty/Keyboard/blob/master/keyboard/AppDelegate.swift
//https://stackoverflow.com/questions/40144259/modify-accessibility-settings-on-macos-with-swift
import OrderedDictionary
import SwiftUI
import Cocoa

class ViewModel : ObservableObject {
    @Published var allKeys: [OrderedDictionary<Int, Keys>];
    var appDelegate: AppDelegate?;
    var keyboardId: Int?
    var updatedKb: Bool
    
    init() {
        updatedKb = false
        allKeys = [ [53: Keys("esc"),
                    160: Keys("F3"),
                    177: Keys("F4"),
                    176: Keys("F5"),
                    178: Keys("F6")],
                    [50: Keys("`"),
                    18: Keys("1"),
                    19: Keys("2"),
                    20: Keys("3"),
                    21: Keys("4"),
                    23: Keys("5"),
                    22: Keys("6"),
                    26: Keys("7"),
                    28: Keys("8"),
                    25: Keys("9"),
                    29: Keys("0"),
                    27: Keys("-"),
                    24: Keys("="),
                    51: Keys("delete")],
                    [48: Keys("tab"),
                    12: Keys("Q"),
                    13: Keys("W"),
                    14: Keys("E"),
                    15: Keys("R"),
                    17: Keys("T"),
                    16: Keys("Y"),
                    32: Keys("U"),
                    34: Keys("I"),
                    31: Keys("O"),
                    35: Keys("P"),
                    33: Keys("["),
                    30: Keys("]"),
                    42: Keys("\\")],
                    [0: Keys("A"),
                    1: Keys("S"),
                    2: Keys("D"),
                    3: Keys("F"),
                    5: Keys("G"),
                    4: Keys("H"),
                    38: Keys("J"),
                    40: Keys("K"),
                    37: Keys("L"),
                    41: Keys(";"),
                    39: Keys("'"),
                    36: Keys("return")],
                    [6: Keys("Z"),
                    7: Keys("X"),
                    8: Keys("C"),
                    9: Keys("V"),
                    11: Keys("B"),
                    45: Keys("N"),
                    46: Keys("M"),
                    43: Keys(","),
                    47: Keys("."),
                    44: Keys("/")],
                    [179: Keys("fn"),
                    49: Keys("space"),
                    123: Keys("◂"),
                    126: Keys("▴"),
                    125: Keys("▾"),
                    124: Keys("▸")]]
    }
    
    
    func start (appDelegate: AppDelegate){
        self.appDelegate = appDelegate
        appDelegate.addViewModelObserver(viewModel: self)
        //callback function for key presses
        let callBackPress: CGEventTapCallBack = { (proxy, type, event, refcon: UnsafeMutableRawPointer?) in
            //to avoid "A C function pointer cannot be formed from a closure that captures context", callback function
            //is a C function, cannot use 'self'. Must have a self pointer to Logic class
            if let ptr = refcon {
                let listener = Unmanaged<ViewModel>.fromOpaque(ptr).takeUnretainedValue()
                print("Key Press: \(event.getIntegerValueField(CGEventField.keyboardEventKeycode)), Event TimeStamp: \(Double(event.timestamp) * pow(10, -9))");
                let keyCode: Int = Int(truncatingIfNeeded: event.getIntegerValueField(CGEventField.keyboardEventKeycode))
                var key: Keys?;
                for keyRow in listener.allKeys  {
                    if(keyRow[keyCode] != nil) {
                        key = keyRow[keyCode];
                        break;
                    }
                    else {
                        key = nil;
                    }
                }
                if(key == nil) {
                    return Unmanaged.passUnretained(event);
                }
                if(key?.isDoublePress(time: Double(event.timestamp) * pow(10, -9)) == true) {
                    print("Found Double Press!")
                    return nil;
                }
                key?.setPressedTimeStamp(time: (Double(event.timestamp) * pow(10, -9)))
                return Unmanaged.passUnretained(event);
            }
            return Unmanaged.passUnretained(event);
        }
        
        //callback function for key releases
        let callBackRelease: CGEventTapCallBack = { (proxy, type, event, refcon: UnsafeMutableRawPointer?) in
            //to avoid "A C function pointer cannot be formed from a closure that captures context", callback function
            //is a C function, cannot use 'self'. Must have a self pointer to Model class
            if let ptr = refcon {
                let listener = Unmanaged<ViewModel>.fromOpaque(ptr).takeUnretainedValue()
                print("Key Release: \(event.getIntegerValueField(CGEventField.keyboardEventKeycode)), Event TimeStamp: \(Double(event.timestamp) * pow(10, -9))");
                let keyCode: Int = Int(truncatingIfNeeded: event.getIntegerValueField(CGEventField.keyboardEventKeycode))
                var key: Keys?;
                for keyRow in listener.allKeys  {
                    if(keyRow[keyCode] != nil) {
                        key = keyRow[keyCode];
                        break;
                    }
                    else {
                        key = nil;
                    }
                }
                var keyboardId: CGEventSourceKeyboardType = CGEventSource(event: event)!.keyboardType
                let swiftInstance = Unmanaged<ViewModel>.fromOpaque(refcon!).takeUnretainedValue()
                swiftInstance.keyboardId = Int(keyboardId)
                if(swiftInstance.keyboardId != nil && !swiftInstance.updatedKb) {
                    print("entered")
                
                    swiftInstance.appDelegate!.databaseManagement.addKeyboard(id: swiftInstance.keyboardId!, allKeys: swiftInstance.allKeys)
                    swiftInstance.allKeys = swiftInstance.appDelegate!.databaseManagement.getSavedKeyData(kbId: swiftInstance.keyboardId!, allKeys: swiftInstance.allKeys)


                    swiftInstance.updatedKb = true
                }
                
            

            
                
                if(key == nil) {
                    return Unmanaged.passUnretained(event);
                }
                if(key?.isDoubleRelease(time: Double(event.timestamp) * pow(10, -9)) == true) {
                    return nil;
                }
                key?.setReleasedTimeStamp(time: (Double(event.timestamp) * pow(10, -9)))
                return Unmanaged.passUnretained(event);
            }
            return Unmanaged.passUnretained(event);
            }
        //convert to bit mask
        let maskPress: CGEventMask = (1 << CGEventType.keyDown.rawValue);
        let maskRelease: CGEventMask = (1 << CGEventType.keyUp.rawValue);

        
        var selfPtr: Unmanaged<ViewModel>! = Unmanaged.passRetained(self)
            
        //event tap for key press
        let keyPress: CFMachPort = CGEvent.tapCreate(tap: CGEventTapLocation.cgSessionEventTap, place: CGEventTapPlacement.headInsertEventTap, options: CGEventTapOptions.defaultTap, eventsOfInterest: maskPress,
                                  callback: callBackPress,
                                                     userInfo: selfPtr.toOpaque())!;
        
        
        //event tap for key release
        let keyRelease: CFMachPort = CGEvent.tapCreate(tap: CGEventTapLocation.cgSessionEventTap, place: CGEventTapPlacement.headInsertEventTap, options: CGEventTapOptions.defaultTap, eventsOfInterest: maskRelease,
                                  callback: callBackRelease,
                                  userInfo: selfPtr.toOpaque())!;
        
    
        let runLoopSourceRelease: CFRunLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, keyRelease, 0)
        let runLoopSourcePress: CFRunLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, keyPress, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSourcePress, CFRunLoopMode.commonModes);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSourceRelease, CFRunLoopMode.commonModes);
        CGEvent.tapEnable(tap: keyPress, enable: true)
        CGEvent.tapEnable(tap: keyRelease, enable: true)
        
        CFRunLoopRun();
        
    
    }
    
    //check for accessibility priveledges
    public func checkAccess() -> Bool{
        let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
        let options = [checkOptPrompt: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary?)
        return accessEnabled
    }
    
    public func changeDelay(delay: Double) {
        for keyRow in allKeys {
            for key in keyRow.orderedValues {
                key.delay = delay;
            }
        }
    }
    public func updateKeyInfo() {
        print(self.keyboardId)
        appDelegate?.databaseManagement.updateKeyData(kbId: self.keyboardId!, allKeys: self.allKeys)
    }
}





