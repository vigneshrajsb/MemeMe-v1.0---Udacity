//
//  HomeViewController.swift
//  MemeMe v1.0 - Udacity
//
//  Created by Vigneshraj Sekar Babu on 8/28/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var memeView: UIView!
    
    
    //constraints
    @IBOutlet weak var constraintTopBartoMemeView: NSLayoutConstraint!
    @IBOutlet weak var constraintMemeViewTobottomBar: NSLayoutConstraint!
    
    
    
    let imagePicker = UIImagePickerController()
    let attributeTextDictionary : [String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
        NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40),
        NSAttributedStringKey.strokeWidth.rawValue : -2.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayoutConstraints()
        setImagePickerDelegate()
        setTextFieldDelegateAndAttribute()
        setObserversForKeyboard()
        initializeUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //removeObserversForKeyboardNotification()
    }
    
    
    func setupLayoutConstraints() {
        constraintTopBartoMemeView.constant = 116
        constraintMemeViewTobottomBar.constant = 116
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            constraintTopBartoMemeView.constant = 0
            constraintMemeViewTobottomBar.constant = 0
        } else {
            setupLayoutConstraints()
        }
    }
    
    //MARK: - Setting up delegates
    func setImagePickerDelegate() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func setTextFieldDelegateAndAttribute() {
        topTextField.delegate = self
        bottomTextField.delegate = self
    
        
        topTextField.defaultTextAttributes = attributeTextDictionary
        bottomTextField.defaultTextAttributes = attributeTextDictionary
    }
    
    
    //MARK: - Keyboard Layouts
    func setObserversForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y =  -getKeyboardHeight(for: notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(for notification : NSNotification) -> CGFloat {
        if  let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return frame.cgRectValue.height
        }
        return 0
    }
    
    func removeObserversForKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide , object: nil)
    }
    
    
    //MARK: - Initialize UI
    func initializeUI() {
        view.backgroundColor = .white
        
        //Setup Text Fields
        topTextField.borderStyle = .none
        bottomTextField.borderStyle = UITextBorderStyle.none
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        topTextField.text = "Top text for Meme"
        bottomTextField.text = "Bottom Text for Meme"
        
        //check camera source
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //setup Buttons
        if selectedImageView.image == nil {
            shareButton.isEnabled = false
            cancelButton.isEnabled = false
            topTextField.isHidden = true
            bottomTextField.isHidden = true
        } else {
            shareButton.isEnabled = true
            cancelButton.isEnabled = true
            topTextField.isHidden = false
            bottomTextField.isHidden = false
            view.bringSubview(toFront: topTextField)
            view.bringSubview(toFront: bottomTextField)
        }
    }
    
    //MARK: - Bottom Toolbar Button Actions
    @IBAction func albumSelected(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func cameraSelected(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: - Top Toolbar Button Actions
    @IBAction func actionTapped(_ sender: Any) {
        if let _ = selectedImageView.image {
            
            let meme: UIImage = createMemedImage()
            
            let activityController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        selectedImageView.image = nil
        initializeUI()
    }
    
    //MARK: - ImagePicker Delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.selectedImageView.image = image
        }
        dismiss(animated: true) {
            self.initializeUI()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {
            self.initializeUI()
        }
    }
    
    
    //MARK: - TextField Delegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func save() {
//        if let image = selectedImageView.image {
//        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: image, memedImage: image)
//        }
//    }
    
    
    func createMemedImage() -> UIImage {
        print(memeView.bounds)
        
        UIGraphicsBeginImageContextWithOptions(memeView.bounds.size, memeView.isOpaque, 0.0)
        memeView.drawHierarchy(in: memeView.bounds, afterScreenUpdates: false)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("Error with creating s Meme!")
        }
        
        UIGraphicsEndImageContext()
        return image
        
    }
    
//    @IBAction func savePressed(_ sender: Any) {
//        createMemedImage()
//    }
    
}


struct Meme {
    var topText: String
    var bottomText: String
    let originalImage: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
