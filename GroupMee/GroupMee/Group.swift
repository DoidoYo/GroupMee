//
//  Group.swift
//  GroupMee
//
//  Created by Gabriel Fernandes on 4/27/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation

class Group:NSObject {
    var id:String = ""
    var name:String = ""
    var desc:String = ""
    var image_url:String = ""
    var creator_user_id:String = ""
    var created_at:CLong = 0
    var updated_at:CLong = 0
    var members:[Member] = [Member]()
    var share_url:String = ""
    var messages: GroupsMessages = GroupsMessages()
}
