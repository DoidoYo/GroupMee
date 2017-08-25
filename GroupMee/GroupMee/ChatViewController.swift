//
//  ChatViewController.swift
//  GroupMee
//
//  Created by Gabriel Fernandes on 4/27/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import Cocoa

class ChatViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var messages:[Message] = [Message]()
    
    @IBOutlet weak var tableView: NSTableView!

    @IBOutlet weak var nameTextField: NSTextField!
    
    override func viewWillAppear() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func chatName(_ name:String) {
        nameTextField.stringValue = name
    }
    
    func loadChat(_ id:String) {
        print("Loading chat: " + id)
        
        GroupMeClient.getGroupMessages(id: id, completion: {
            json in
            
            if let json = json {
                let msgs = json["messages"] as! [AnyObject]
                self.messages = [Message]()
                
                for i in 0..<msgs.count {
                    let msg = msgs[i] as! [String:AnyObject]
                    
                    var message = Message()
                    
                    if let id = msg["id"] as? String {
                        message.id = id
                    }
                    
                    if let source_guid = msg["source_guid"] as? String {
                        message.source_guid = source_guid
                    }
                    
                    if let created_at = msg["created_at"] as? CLong {
                        message.created_at = created_at
                    }
                    
                    if let user_id = msg["user_id"] as? String {
                        message.user_id = user_id
                    }
                    
                    if let group_id = msg["group_id"] as? String {
                        message.group_id = group_id
                    }
                    
                    if let name = msg["name"] as? String {
                        message.name = name
                    }
                    
                    if let avatar_url = msg["avatar_url"] as? String {
                        message.avatar_url = avatar_url
                    }
                    
                    if let text = msg["text"] as? String {
                        message.text = text
                    }
                    
                    if let system = msg["system"] as? Bool {
                        message.system = system
                    }
                    
                    let favs = msg["favorited_by"] as! [String]
                    
                    for o in 0..<favs.count {
                        message.favorited_by.append(favs[o])
                    }
                    
                    let atts = msg["attachments"] as! [AnyObject]
                    
                    for o in 0..<atts.count {
                        let att = atts[o] as! [String:AnyObject]
                    }
                 
                    
//                    print(message.text)
//                    self.messages.append(message)
                    self.messages.insert(message, at: 0)
                    
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Error Loading Message Data!")
            }
        })
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.messages.count
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let message = messages[row]
        
        
        let cell = tableView.make(withIdentifier: "NewMsg", owner: nil)
        
        for i in 0..<cell!.subviews.count {
            let view = cell?.subviews[i]
            if view?.identifier == "PersonName" {
                (view as! NSTextField).stringValue = message.name
            }
            if view?.identifier == "Message" {
                (view as! NSTextField).stringValue = message.text
            }
//            if view?.identifier == "date" {
//                (view as! NSTextField).stringValue = String(group.messages.last_message_created_at)
//            }
            if view?.identifier == "PersonImg" {
                if let url = URL(string: message.avatar_url) {
                    do {
                        let data = try Data(contentsOf: url)
                        (view as! NSImageView).image = NSImage(data: data)
                    } catch {
                        print("Could not load imgage!")
                    }
                }
            }
        }
        
        return cell
    }
    
}







