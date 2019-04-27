//
//  ViewController.swift
//  PickImage
//
//  Created by Ahmed Almaged on 14/08/1440 AH.
//  Copyright © 1440 Ahmed Almaged. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottm: UITextField!
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottmToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!

    struct Meme {
        var top: String!
        var bottom: String!
        var originalImage: UIImage!
        var memedImage: UIImage!
    }
    
    var memedImage: UIImage!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth: -2.0,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottm.delegate = self        
        self.top.delegate = self
        prepareTextField(textField: top, defaultText:"TOP")
        prepareTextField(textField: bottm, defaultText:"BUTTOM")
        
        if imagePickerView != nil {
            shareButton.isEnabled = false
        }
        else{
            shareButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = true
        } else {
            cameraButton.isEnabled = false
        }
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    // the heigh of the keyboard when it shows
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // show the keyboard on the screen
    @objc func keyboardWillShow(_ notification:Notification) {
        if(bottm.isFirstResponder){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // to notify the keyboard will show
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // to unsubscibe from notifing the keyboard will show
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // hide the keyboard
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0;
    }
    
    // to return the keyboard and show the original screen
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.frame.origin.y = 0
        textField.resignFirstResponder()
        return true
    }
    
    // put the image on the screen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = pickedImage
            shareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // cancel the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // pic an image from library
    @IBAction func pickAnImage(_ sender: Any) {
        pickImage(sourceType: UIImagePickerController.SourceType.photoLibrary)
    }
    
    // pic an image from the camera
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            pickImage(sourceType: UIImagePickerController.SourceType.camera)
        } else {
            noCamera()
        }
    }
    
    func pickImage(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    // check if the device has no camera!
    func noCamera(){
        let alert=UIAlertController(title:"Camera Can't be open", message: "You don't have camera on your device", preferredStyle:UIAlertController.Style.alert )
        
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {
            _ in print("FOO ")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // save the meme
    func save() {
        _ = Meme(top: top.text!, bottom: bottm.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }
    
    // generate the meme image with the text
    func generateMemedImage() -> UIImage {
        
        hideToolbars(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbars(false)
        
        return memedImage
    }
    
    func hideToolbars(_ hide: Bool) {
        self.bottmToolBar.isHidden = hide
        self.topToolBar.isHidden = hide

    }
    
    // share the meme app to other devices
    @IBAction func share(_ sender: Any) {
        memedImage = generateMemedImage()
        let Controller = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        
        Controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                
                return
            }
            self.save()
        }
        present(Controller, animated: true, completion: nil)
    }
}
