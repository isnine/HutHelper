//
//  DataBase-Swift.swift
//  HutHelper
//
//  Created by 张驰 on 2019/11/18.
//  Copyright © 2019 nine. All rights reserved.
//

import Foundation
import UIKit
import SQLite
fileprivate let defaultss = UserDefaults.standard

func saveMomentSearch(bookname:[String]) {
    defaultss.set(bookname,forKey: "moment_search")
    defaultss.synchronize()
}
func getMomentSearch() -> [String]? {
    let content = defaultss.object(forKey: "moment_search") as? [String]
    return content
}



struct DataCenterConstant {
    static let dbName = "db.sqlite"
    static let dbFilePath = NSHomeDirectory() + "/Documents/" + DataCenterConstant.dbName
}

class DataBase {
    static let shared = DataBase()
    static var db: Connection? = {
        do {
            return try Connection(DataCenterConstant.dbFilePath)
        } catch {
            assertionFailure("Create DB Fail")
            debugPrint(error)
        }
        return nil
    }()
    
    var tagsTable = TagsTable()
    init() {
        
        tagsTable.setupTable()
        
    }
}

extension DataBase {
    // 增
    func insertNotes(with data:String) -> Int64? {

        do {
            let insertNotes = tagsTable.table.insert(
                tagsTable.content <- data)
            return try DataBase.db?.run(insertNotes)
        }catch {
            assertionFailure()
        }
        return nil
    }
    // 删
    func deleteNotesById(id:String) -> Bool {
        do {
            try DataBase.db?.run(tagsTable.table.filter(tagsTable.content == id).delete())
            return true
        }catch{
            assertionFailure()
        }
        return false
    }
    //查
    func queryNotesByTime() -> [String] {
        var datas = [String]()
        do {
            for value in Array(try DataBase.db!.prepare(tagsTable.table) ) {
                let content = value[tagsTable.content]
                let id = value[tagsTable.id]
                print(id)
                datas.append(content)
            }
        } catch {
            assertionFailure("\(error)")
        }
       // datas = datas.reversed()
        return datas
    }
}
