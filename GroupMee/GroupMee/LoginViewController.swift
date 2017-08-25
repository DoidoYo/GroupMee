//
//  LoginViewController.swift
//  GroupMee
//
//  Created by Gabriel Fernandes on 4/26/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import WebKit
import Cocoa

class LoginViewController: NSViewController, WebFrameLoadDelegate {
    
    @IBOutlet weak var webView: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appleEventManager:NSAppleEventManager = NSAppleEventManager.shared()
        appleEventManager.setEventHandler(self, andSelector: #selector(handleGetURLEvent(event:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        let url = "https://oauth.groupme.com/oauth/authorize?client_id=3nrnueunfYQidU74dmDcAoeOYr0jqI7M8sHBeAd1nyvQqdXJ"
        
        var request = URLRequest(url: URL(string: url)!)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpShouldHandleCookies = false
        
        self.webView.mainFrame.load(request)
    }
    
    func handleGetURLEvent(event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let aeEventDescriptor = event?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) {
            if let urlStr = aeEventDescriptor.stringValue {
                let url = NSURL(string: urlStr)
                
                // do something with the URL
                let urlString = url!.absoluteString
                var token = urlString?.substring(from: (urlString?.index(of: "="))!)
                
                let index = token?.index(after: (token?.startIndex)!)
                token = token?.substring(from: index!)
                
//                print(token)
                //save token
                GroupMeClient.token = token
                let keychain = KeychainSwift()
                keychain.set(token!, forKey: "token")
                
                let storyBoard = NSStoryboard(name: "Main", bundle: nil) as NSStoryboard
                let splitController = storyBoard.instantiateController(withIdentifier: "split") as! SplitViewController
//                splitController.updateScreen()
                
                
                print("LOGIN")
                print(self.parent?.childViewControllers.count)
                print("-----")
                //remove login controller from view
                self.dismissViewController(self)
            }
        }
    }
    
}
