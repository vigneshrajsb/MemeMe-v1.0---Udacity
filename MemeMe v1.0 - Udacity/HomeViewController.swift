//
//  HomeViewController.swift
//  MemeMe v1.0 - Udacity
//
//  Created by Vigneshraj Sekar Babu on 8/28/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var memeView: UIView!
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    //constraints
    @IBOutlet weak var constraintTopBartoMemeView: NSLayoutConstraint!
    @IBOutlet weak var constraintMemeViewTobottomBar: NSLayoutConstraint!
    @IBOutlet weak var constraintMemeViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintMemeViewLeading: NSLayoutConstraint!
    
    
    let imagePicker = UIImagePickerController()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewWillLayoutSubviews()
        setImagePickerDelegate()
        setTextFieldDelegateAndAttribute()
        setObserversForKeyboard()
        initializeUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //removeObserversForKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTextFieldAttributes()
    }
    
    func setupPortraitLayoutConstraints() {
        let width = view.safeAreaLayoutGuide.layoutFrame.width
        let height = view.safeAreaLayoutGuide.layoutFrame.height
        let topToolBarHeight = topToolBar.frame.height
        let bottomToolbarHeight = bottomToolbar.frame.height
        
        let const = (height - (topToolBarHeight + bottomToolbarHeight) - width) / 2

        constraintTopBartoMemeView.constant = const
        constraintMemeViewTobottomBar.constant = const
        constraintMemeViewTrailing.constant = 0
        constraintMemeViewLeading.constant = 0
        //print("Height: \(selectedImageView.frame.height) -- Width: \(selectedImageView.frame.width)")
    }
    
    
    func setupLandscapeLayoutConstraints() {
        let height = view.safeAreaLayoutGuide.layoutFrame.height
        let width = view.safeAreaLayoutGuide.layoutFrame.width
        let topToolbarHeight = topToolBar.frame.height
        let bottomToolbarHeight = bottomToolbar.frame.height
        
        let const = (width - (height - topToolbarHeight - bottomToolbarHeight)) / 2

        constraintTopBartoMemeView.constant = 0
        constraintMemeViewTobottomBar.constant = 0
        constraintMemeViewLeading.constant = const
        constraintMemeViewTrailing.constant = const
        
        //print("Height: \(selectedImageView.frame.height) -- Width: \(selectedImageView.frame.width)")
        
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
          setupLandscapeLayoutConstraints()
        } else {
            setupPortraitLayoutConstraints()
        }
    }
    
    //MARK: - Setting up delegates
    func setImagePickerDelegate() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
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
        bottomTextField.text = "Bottom text for Meme"
        
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
    
    
    //    func save() {
    //        if let image = selectedImageView.image {
    //        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: image, memedImage: image)
    //        }
    //    }
    
    
    func createMemedImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(memeView.bounds.size, memeView.isOpaque, 0.0)
        memeView.drawHierarchy(in: memeView.bounds, afterScreenUpdates: false)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("Error with creating Meme!")
        }
        
        UIGraphicsEndImageContext()
        return image
        
    }
    
}

//MARK: - Extension for ImagePicker Delegate methods
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.selectedImageView.image = image
        }
        dismiss(animated: true) {
            self.initializeUI()
            self.setTextFieldAttributes()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {
            self.initializeUI()
        }
    }
}

//MARK: - Extension for TextField Delegate methods
extension HomeViewController: UITextFieldDelegate {
    
    func setTextFieldDelegateAndAttribute() {
        topTextField.delegate = self
        bottomTextField.delegate = self
        setTextFieldAttributes()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     
        let existingText = textField.text ?? ""
        if existingText == "Top text for Meme" || existingText == "Bottom text for Meme" {
                   textField.text = ""
        }
           setTextFieldAttributes()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let characterCount = textField.text?.count else { return false }
        setTextFieldAttributes()
        return characterCount < 40
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setTextFieldAttributes() {
        topTextField.defaultTextAttributes = attributeTextDictionary
        bottomTextField.defaultTextAttributes = attributeTextDictionary
    }
}


