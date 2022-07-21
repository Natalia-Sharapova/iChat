//
//  ChatsViewController.swift
//  iChat
//
//  Created by Наталья Шарапова on 19.07.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

class ChatsViewController: MessagesViewController {
    
    private let user: MUser
    private let chat: MChat
    
    private var messages = [MMessage]()
    
    private var messageListener: ListenerRegistration?
    
    init(user: MUser, chat: MChat) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        
        title = chat.friendUserName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        messageListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageInputBar()
        messagesCollectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
        }
        
        messageListener = ListenerService.shared.messageObserver(chat: chat, completion: { result in
            
            switch result {
            
            case .success(var message):
                if let url = message.downloadURL {
                    StorageService.shared.downloadImage(url: url) { [weak self] result in
                        
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let image):
                            message.image = image
                            self.insertNewMessage(message: message)
                        case .failure(let error):
                            self.showAlert(with: "Error", and: error.localizedDescription)
                        }
                    }
                    
                } else {
                    self.insertNewMessage(message: message)
                }
                
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        })
    }
        
        @objc func cameraButtonPressed() {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
            } else {
                picker.sourceType = .photoLibrary
            }
            present(picker, animated: true, completion: nil)
        }
    
    func configureMessageInputBar() {
            messageInputBar.isTranslucent = true
            messageInputBar.separatorLine.isHidden = true
            messageInputBar.backgroundView.backgroundColor = UIColor(red: 247, green: 248, blue: 253, alpha: 1)
            messageInputBar.inputTextView.backgroundColor = .white
            messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
            messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
            messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.3987493813, green: 0.3987493813, blue: 0.3987493813, alpha: 1)
            messageInputBar.inputTextView.layer.borderWidth = 0.2
            messageInputBar.inputTextView.layer.cornerRadius = 18.0
            messageInputBar.inputTextView.layer.masksToBounds = true
            messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
            
            messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            messageInputBar.layer.shadowRadius = 5
            messageInputBar.layer.shadowOpacity = 0.3
            messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        configureSendButton()
        configureCameraIcon()
        }
    
    func configureSendButton() {
           messageInputBar.sendButton.setImage(UIImage(named: "sent"), for: .normal)
           messageInputBar.sendButton.applyGradient(cornerRadius: 10)
           messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
           messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
           messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
           messageInputBar.middleContentViewPadding.right = -38
       }
    
    func configureCameraIcon() {
        
           let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .purple
        
           let cameraImage = UIImage(systemName: "camera")
           cameraItem.image = cameraImage
           
           cameraItem.addTarget(self, action: #selector(cameraButtonPressed), for: .primaryActionTriggered)
           cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
           
           messageInputBar.leftStackView.alignment = .center
           messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
           
           messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
       }
    
    func insertNewMessage(message: MMessage) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
            
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }

private func sendImage(image: UIImage) {
    
    StorageService.shared.uploadImageMessage(photo: image, to: chat) { result in
        switch result {
        
        case .success(let url):
            var message = MMessage(user: self.user, image: image)
            message.downloadURL = url
            
            FirestoreService.shared.sendMessage(chat: self.chat, message: message) { result in
                switch result {
                
                case .success():
                    self.messagesCollectionView.scrollToLastItem()
                    
                case .failure(_):
                    self.showAlert(with: "Error", and: "The image not delivered")
                }
            }
        case .failure(let error):
            self.showAlert(with: "Error", and: error.localizedDescription)
        }
    }
}
}

extension ChatsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
    }
        sendImage(image: image)
}
}
    

extension ChatsViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return Sender(senderId: user.id, displayName: user.userName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
}


extension ChatsViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.item % 4 == 0 {
            return 30
        } else {
            return 0
        }
    }
}

extension ChatsViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .purple
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? .black : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.item % 4 == 0 {
            return NSAttributedString(
                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                attributes: [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                    NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        } else {
            return nil
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
}

extension ChatsViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let message = MMessage(user: user, content: text)
        
        FirestoreService.shared.sendMessage(chat: chat, message: message) { result in
            switch result {
            
            case .success():
                self.messagesCollectionView.scrollToLastItem()
                inputBar.inputTextView.text = ""
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
        
      
        
        
    }
}
