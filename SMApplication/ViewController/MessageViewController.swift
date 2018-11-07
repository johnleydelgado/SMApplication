//
//  MessageViewController.swift
//  SMApplication
//
//  Created by Rapha Solution on 11/7/18.
//  Copyright © 2018 Johnley Delgado. All rights reserved.
//

import UIKit
import JSQMessagesViewController


class MessageViewController : JSQMessagesViewController {
    var message = [JSQMessage]()
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble : JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        senderId = "1234"
        senderDisplayName = "Ley"
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        let query = ChatConstant.refs.child.queryLimited(toLast: 10)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["age"],
                let name        = data["emal"],
                let text        = data["gender"],
                !text.isEmpty
            {
                
                
                if let messages = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    
                    self?.message.append(messages)
                    
                    self?.finishReceivingMessage()
                }
            }
        })
        
      //  self.edgesForExtendedLayout = []
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let ref = ChatConstant.refs.child.childByAutoId()
        let message = ["sender_id":senderId,"name":senderDisplayName,"text":text]
        ref.setValue(message)
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
