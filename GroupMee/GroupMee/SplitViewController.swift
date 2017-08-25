//
//  SplitViewController.swift
//  GroupMee
//
//  Created by Gabriel Fernandes on 4/26/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import Cocoa
import WebKit

class SplitViewController: NSSplitViewController, NSWindowDelegate {
    
    var groupViewController:GroupViewController?
    var chatViewController:ChatViewController?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear() {
        
        for i in 0..<self.childViewControllers.count {
            let s = self.childViewControllers[i]
            if s.identifier == "ChatController" {
                chatViewController = s as! ChatViewController
            }
            if s.identifier == "GroupController" {
                groupViewController = s as! GroupViewController
            }
        }
        
        let keychain = KeychainSwift()
        if let token = keychain.get("token") {
            GroupMeClient.token = token
            groupViewController?.updateData()
        } else {
            let storyBoard = NSStoryboard(name: "Main", bundle: nil) as NSStoryboard
            let loginController = storyBoard.instantiateController(withIdentifier: "login") as! NSViewController
            
            self.presentViewControllerAsSheet(loginController)
        }
        
        NSApplication.shared().windows.first?.delegate = self
        
    }
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        
//        print(groupViewController?.view.frame.size)
        
//        if (groupViewController?.view.frame.size.width)! < CGFloat(300) {
//            print("LESS")
            groupViewController?.view.frame = NSRect(x: groupViewController!.view.frame.origin.x, y: groupViewController!.view.frame.origin.y, width: 300, height: groupViewController!.view.frame.height)
//        }
        
        return frameSize
    }
    
    public func updateScreen() {
//        let storyBoard = NSStoryboard(name: "Main", bundle: nil) as NSStoryboard
//        let groupController = storyBoard.instantiateController(withIdentifier: "group") as! GroupViewController
//        let chatController = storyBoard.instantiateController(withIdentifier: "chat") as! ChatViewController
//        
//        groupController.updateData()
    }
    
}

