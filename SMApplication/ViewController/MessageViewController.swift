//
//  MessageViewController.swift
//  SMApplication
//
//  Created by Rapha Solution on 11/7/18.
//  Copyright © 2018 Johnley Delgado. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class MessageViewController : JSQMessagesViewController {
    var message = [JSQMessage]()
    var recieverUser = ""
    var roomname = ""
    var recieveName = ""
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble : JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        senderId = Auth.auth().currentUser!.uid
        self.senderDisplayName = recieveName
        title = recieveName
        roomname = "chatroom_\(senderId<recieverUser ? senderId+"_"+recieverUser : recieverUser+"_"+senderId)"

        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        messageBetweenUser()
    
        self.edgesForExtendedLayout = []
    }
    
    func messageBetweenUser(){
        let ref = Database.database().reference()
        if let _ = senderId {
            let query = ref.child("chatNew")
            
            _ = query.queryOrdered(byChild: "roomname").queryEqual(toValue: roomname).queryLimited(toLast: 50).observe(.childAdded, with: { [weak self] snapshot in
                print(query)
                
                if let dict = snapshot.value as? [String:Any] {
                    print(dict)
                    let id = dict["sender_id"] as! String
                    let name = dict["name"] as! String
                    let text = dict["text"] as! String
                    if let messages = JSQMessage(senderId: id, displayName: name, text: text)
                    {
                        
                        self?.message.append(messages)
                        
                        self?.finishReceivingMessage()
                    }
                }
            })
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let ref2 = ChatConstant.refs.root.child("chatNew").childByAutoId()
        let message = ["roomname":roomname,"sender_id":senderId,"name":senderDisplayName,"text":text,"recieve_id":recieverUser]
        ref2.setValue(message)
        finishSendingMessage(    )
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return message.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return message[indexPath.row]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        return message[indexPath.item].senderId == senderId ? outgoingBubble:incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        return message[indexPath.item].senderId == senderId ? nil:NSAttributedString(string: message[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
        return message[indexPath.item].senderId == senderId ? 0 : 15
    }
}

extension JSQMessagesViewController {
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
