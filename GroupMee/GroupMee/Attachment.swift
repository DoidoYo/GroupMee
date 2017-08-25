//
//  Attachment.swift
//  GroupMee
//
//  Created by Gabriel Fernandes on 4/27/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation

class Attachment:NSObject {
    var type: String = ""
    var url:String = ""
    var lat:Double = 0
    var lng:Double = 0
    var name:String = ""
    var token:String = ""
    var placeholder:String = ""
    var charmap:[[Int]] = [[Int]]()
}
