//
//  ChatsViewController.swift
//  MicroChat
//
//  Created by Daniel Li on 5/25/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {

    var tableView: UITableView!
    
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chats"
        let chat = Chat(name: "Test", users: [])
        chats.append(chat)
        
        setupTableView()
        setupBarButtons()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.frame, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        
        view.addSubview(tableView)
    }
    
    func setupBarButtons() {
        let newChatButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(newChatButtonPressed))
        navigationItem.rightBarButtonItem = newChatButton
    }
    
    func newChatButtonPressed() {
        let navigationController = UINavigationController(rootViewController: NewChatViewController())
        presentViewController(navigationController, animated: true, completion: nil)
    }
}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! ChatCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let chatViewController = ChatViewController()
        chatViewController.chat = chats[indexPath.row]
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
}
