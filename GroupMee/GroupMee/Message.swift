//
//  Messages.swift
//  GroupMee
//
//  Created by Gabriel Fernandes on 5/5/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation


class Message:NSObject {
    var id:String = ""
    var source_guid:String = ""
    var created_at:CLong = 0
    var user_id:String = ""
    var group_id:String = ""
    var name:String = ""
    var avatar_url:String = ""
    var text:String = ""
    var system:Bool = false
    var favorited_by:[String] = [String]()
    var attachments: [Attachment] = [Attachment]()
}
