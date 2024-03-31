//
//  DatabaseManagement.swift
//  debounce
//
//  Created by Donny Le on 3/8/24.
//

import Foundation
import SQLite
import OrderedDictionary


class DatabaseManagement: ObservableObject{
    var db: Connection? = nil;
    let keyboards = Table("Keyboards")
    let id = Expression<Int>("id")
    let keyboardName = Expression<String>("keyboardName")

    
    let keys = Table("Keys")
    let keyboardId = Expression<Int>("keyboardId")
    let keyName = Expression<String>("keyName")
    let keyId = Expression<Int>("keyId")
    let presses = Expression<Int>("presses")
    let releases = Expression<Int>("releases")
    let doublePresses = Expression<Int>("doublePresses")
    let doubleReleases = Expression<Int>("doubleReleases")
    
    init() {
        do {
            // set the path corresponding to application support
            let path = NSSearchPathForDirectoriesInDomains(
                .applicationSupportDirectory, .userDomainMask, true
            ).first! + "/" + "debounceApp";
            
            // create parent directory inside application support if it doesn’t exist
            try FileManager.default.createDirectory(
                atPath: path, withIntermediateDirectories: true, attributes: nil
            )
            // Create a connection to the SQLite database
            self.db = try Connection("\(path)/keyInfo.db")
        
            try db!.run(keyboards.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(keyboardName) //     "id" INTEGER PRIMARY KEY NOT NULL,
            })
            
            try db!.run(keys.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                t.column(keyId) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(keyboardId) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(keyName) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(presses) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(releases) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(doublePresses) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(doubleReleases) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.foreignKey(keyboardId, references: keyboards, id)

            })
            
            
        } catch {
            
            print("Error connecting to database: \(error)")
        }
    }
    public func updateKeyData(kbId: Int, allKeys: [OrderedDictionary<Int, Keys>]) {
        
        let filteredTable = keys.filter(keyboardId == kbId)
        do {
            for keyRow in allKeys {
                for aKey in keyRow {
                        var newKey: Keys = aKey.value
                        var oldKey = filteredTable.filter(keyId == aKey.key)
                    try db!.run(oldKey.update(presses <- newKey.presses, releases <- newKey.releases, doublePresses <- newKey.doublePresses, doubleReleases <- newKey.doubleReleases))
                            
                    }
            }

            
            
        }
        catch {
            print("Error updating key data")
        }
        
        
        
        
    }
    

    
    
    public func getSavedKeyData(kbId: Int, allKeys: [OrderedDictionary<Int, Keys>]) -> [OrderedDictionary<Int, Keys>]{
        let filteredTable = keys.filter(keyboardId == kbId)
        do {
            for tableKey in try db!.prepare(filteredTable) {
                var keyId = tableKey[self.keyId]
                for keyRow in allKeys {
                    if(keyRow.containsKey(keyId)) {
                        var key: Keys = keyRow.value(forKey: keyId)!
                        key.doublePresses = tableKey[self.doublePresses];
                        key.doubleReleases = tableKey[self.doubleReleases];
                        key.presses = tableKey[self.presses];
                        key.releases = tableKey[self.releases];
                    }
                }
            }
        }
        catch {
            print("Error getting saved key data")
        }
        
        return allKeys
    }
        
    
    
    public func addKeyboard(id: Int, allKeys: [OrderedDictionary<Int, Keys>]) {

        do {
            try db?.run(keyboards.insert(keyboardName <- "Test", self.id <- id))
            for keyRow in allKeys {
                for pair in keyRow {
                    let key: Keys = pair.value;
                    try db?.run(keys.insert(keyId <- pair.key,
                                            keyboardId <- id,
                                            keyName <- key.keyName,
                                            presses <- key.presses,
                                            releases <- key.releases,
                                            doublePresses <- key.doublePresses,
                                            doubleReleases <- key.doubleReleases
                                           ))
                }
            }
        }
        catch {
            print("Error adding keyboard: \(error)")

        }
        

    }
    
    
    
    
    
    
    

}
