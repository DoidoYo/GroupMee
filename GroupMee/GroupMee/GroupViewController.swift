//
//  GroupViewController.swift
//  GroupMee
//
//  Created by Gabriel Fernandes on 4/27/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import Cocoa
import FayeSwift

class GroupViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, FayeClientDelegate {
    
    var chatViewController:ChatViewController?
    
    var groups:[Group] = [Group]()
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBAction func logoutButtonPress(_ sender: NSButton) {
        let keychain = KeychainSwift()
        keychain.delete("token")
        
        let storyBoard = NSStoryboard(name: "Main", bundle: nil) as NSStoryboard
        let loginController = storyBoard.instantiateController(withIdentifier: "login") as! NSViewController
        
        self.presentViewControllerAsSheet(loginController)
    }
    
    override func viewDidAppear() {
        
        for i in 0..<self.parent!.childViewControllers.count {
            let s = self.parent!.childViewControllers[i]
            if s.identifier == "ChatController" {
                chatViewController = s as! ChatViewController
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        GroupMeClient.getUser(completion: {
            
            print(GroupMeClient.user_id)
            var client = FayeClient(aFayeURLString: "https://push.groupme.com/faye", channel: "/user/\(GroupMeClient.user_id)")
            client.delegate = self
            client.connectToServer()
        })
        
    }
    
    func connectedToServer(client: FayeClient) {
        println("Connected to Faye server")
    }
    func connectionFailed(client: FayeClient) {
        println("Failed to connect to Faye server!")
    }
    func disconnectedFromServer(client: FayeClient) {
        println("Disconnected from Faye server")
    }
    func didSubscribeToChannel(client: FayeClient, channel: String) {
        println("subscribed to channel \(channel)")
    }
    func didUnsubscribeFromChannel(client: FayeClient, channel: String) {
        println("UNsubscribed from channel \(channel)")
    }
    func subscriptionFailedWithError(client: FayeClient, error: subscriptionError) {
        println("SUBSCRIPTION FAILED!!!!")
    }
    func messageReceived(client: FayeClient, messageDict: NSDictionary, channel: String) {
        let text: AnyObject? = messageDict["text"]
        println("Here is the message: \(text)")
        
        self.client.unsubscribeFromChannel(channel)
    }
    
    public func updateData() {
        
        print("Updating Groups...")
        groups = [Group]()
    
        GroupMeClient.getGroups(completion: {json in
            //print(json)
            
            for i in 0..<json!.count {
                var chat = json?[i] as! [String:AnyObject]
                
                let group = Group()
                
                if let id = chat["id"] as? String {
                    group.id = id
                }
                
                if let created_at = chat["created_at"] as? CLong {
                    group.created_at = created_at
                }
                
                if let creator_user_id = chat["creator_user_id"] as? String {
                    group.creator_user_id = creator_user_id
                }
                
                if let description = chat["description"] as? String {
                    group.desc = description
                }
                
                if let image_url = chat["image_url"] as? String {
                    group.image_url = image_url
                }
                
                if let name = chat["name"] as? String {
                    group.name = name
                }
                
                if let share_url = chat["share_url"] as? String{
                    group.share_url = share_url
                }
                
                var members = chat["members"] as! [AnyObject]
                
                for o in 0..<members.count {
                    var jsonMembers = members[o] as! [String:AnyObject]
                    
                    let member  = Member()
                    
                    if let user_id = jsonMembers["user_id"] as? String {
                        member.user_id = user_id
                    }
                    
                    if let nickname = jsonMembers["nickname"] as? String {
                        member.nickname = nickname
                    }
                    
                    if let muted = jsonMembers["muted"] as? Bool {
                        member.muted = muted
                    }
                    
                    if let image_url = jsonMembers["image_url"] as? String {
                        member.image_url = image_url
                    }
                    
                    group.members.append(member)
                    
                }
                
                var jsonMessages = chat["messages"] as! [String:AnyObject]
                
                let messages = GroupsMessages()
                
                if let count = jsonMessages["count"] as? CLong{
                    messages.count = count
                }
                
                if let last_message_id = jsonMessages["last_message_id"] as? String{
                    messages.last_message_id = last_message_id
                }
                
                if let last_message_created_at = jsonMessages["last_message_created_at"] as? CLong{
                    messages.last_message_created_at = last_message_created_at
                }
                
                var jsonPreview = jsonMessages["preview"] as! [String:AnyObject]
                let preview = Preview()
                
                if let nickname = jsonPreview["nickname"] as? String {
                    preview.nickname = nickname
                }
                
                if let text = jsonPreview["text"] as? String {
                    preview.text = text
                }
                
                if let image_url = jsonPreview["image_url"] as? String {
                    preview.image_url = image_url
                }
                
                var jsonAttachments = jsonPreview["attachments"] as! [AnyObject]
                
                for o in 0..<jsonAttachments.count {
                    
                    var jsonAttachment = jsonAttachments[o] as! [String:AnyObject]
                    
                    let attachment = Attachment()
                    
                    
                    if let type = jsonAttachment["type"] as? String {
                        attachment.type = type
                    }
                    
                    if let url = jsonAttachment["url"] as? String {
                        attachment.url = url
                    }
                    
                    if let lat = jsonAttachment["lat"] as? Double {
                        attachment.lat = lat
                    }
                    
                    if let lng = jsonAttachment["lng"] as? Double {
                        attachment.lng = lng
                    }
                    
                    if let name = jsonAttachment["name"] as? String {
                        attachment.name = name
                    }
                    
                    if let token = jsonAttachment["token"] as? String {
                        attachment.token = token
                    }
                    
                    if let placeholder = jsonAttachment["placeholder"] as? String {
                        attachment.placeholder = placeholder
                    }
                    
                    
                    preview.attachments.append(attachment)
                }
                
                messages.preview = preview
                group.messages = messages
                
                self.groups.append(group)
            }
            
            //print(self.groups.count)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let set = IndexSet(integer: 0)
                self.tableView.selectRowIndexes(set, byExtendingSelection: false)
            }
        })
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.groups.count
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        chatViewController?.loadChat(groups[tableView.selectedRow].id)
        chatViewController?.chatName(groups[tableView.selectedRow].name)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let group = groups[row]
        
        
        let cell = tableView.make(withIdentifier: "GroupCell", owner: nil)
        
        for i in 0..<cell!.subviews.count {
            let view = cell?.subviews[i]
            if view?.identifier == "ChatName" {
                (view as! NSTextField).stringValue = group.name
            }
            if view?.identifier == "LastMsg" {
                (view as! NSTextField).stringValue = group.messages.preview.nickname + ": " + group.messages.preview.text
            }
            if view?.identifier == "date" {
                (view as! NSTextField).stringValue = String(group.messages.last_message_created_at)
            }
            if view?.identifier == "img" {
                if let url = URL(string: group.image_url) {
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
