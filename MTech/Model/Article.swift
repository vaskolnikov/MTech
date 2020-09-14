//
//  Article.swift
//  MTech
//
//  Created by Adem Özsayın on 12.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation

struct Article {
    var title:String
    var date:String
    var imageUrl: String
    
    func formateDate() -> Date? {

         let inputFormatter = DateFormatter()
         inputFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"

         if let date = inputFormatter.date(from: date) {
             let outputFormatter = DateFormatter()
             outputFormatter.locale = Locale(identifier: "tr_TR")
             outputFormatter.dateFormat = "MM-dd-yyyy HH:mm"
             return date
         }
         return nil
     }
}
