//
//  ViewController.swift
//  MicroChat
//
//  Created by Daniel Li on 5/24/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import UIKit
import SocketIOClientSwift
import SwiftyJSON
import SlackTextViewController

class ChatViewController: SLKTextViewController {
    
    init() {
        super.init(tableViewStyle: .Plain)
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var socket: SocketIOClient!
    
    override var tableView: UITableView {
        get {
            return super.tableView!
        }
    }
    
    var chat: Chat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        
        configureSocket()
        
        rightButton.setTitle("Send", forState: .Normal)
    }
    
    private func configureSocket() {
        socket = SocketIOClient(socketURL: NSURL(string: HostURL)!, options: [.Nsp("/test")])
        
        socket.on("chat") { data, ack in
            if let message = Message(data: data) {
                self.addMessage(message)
            }
        }
        
        socket.onAny { print("Got event: " + $0.event) }
        
        socket.connect()

    }
    
    private func addMessage(message: Message) {
        dispatch_async(dispatch_get_main_queue()) {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let rowAnimation: UITableViewRowAnimation = self.inverted ? .Top : .Bottom
            let scrollPosition: UITableViewScrollPosition = self.inverted ? .Bottom : .Top
            
            self.tableView.beginUpdates()
            self.chat.messages.insert(message, atIndex: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: rowAnimation)
            self.tableView.endUpdates()
            
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: true)
        }
    }
    
    override func didPressRightButton(sender: AnyObject?) {
        socket.emit("chat", [textView.text])
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let rowAnimation: UITableViewRowAnimation = self.inverted ? .Bottom : .Top
        let scrollPosition: UITableViewScrollPosition = self.inverted ? .Bottom : .Top
        
        self.tableView.beginUpdates()
        self.chat.messages.insert(Message(content: textView.text), atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: rowAnimation)
        self.tableView.endUpdates()
        
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: true)
        
        textView.text = ""
    }
}

extension ChatViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessageCell
        cell.contentLabel.text = chat.messages[indexPath.row].content
        
        cell.transform = tableView.transform
        
        return cell
    }
}
