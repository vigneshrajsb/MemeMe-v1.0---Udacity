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
    
    //Array to save Memes
    var memeArray = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setObserversForKeyboard()
        setTextFieldAttributes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserversForKeyboard()
    }
    
    //MARK: - UI Setup methods
    func initializeUI() {
        setImagePickerDelegate()
        setTextFieldDelegateAndAttribute()
        
        view.backgroundColor = .white
        memeView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        //making Content mode as Aspect Fill as i dont know how to get square images from iPad's image picker :(. todo item
        if UIDevice.current.userInterfaceIdiom == .pad {
        selectedImageView.contentMode = .scaleAspectFill
        } else {
            selectedImageView.contentMode = .scaleAspectFit
        }
        
        //Setup Text Fields
        topTextField.borderStyle = .none
        bottomTextField.borderStyle = UITextBorderStyle.none
        bottomTextField.textAlignment = .center
        topTextField.text = "TOP TEXT"
        bottomTextField.text = "BOTTOM TEXT"
        
        //Attributed Text field's alignment
        let textAlignment = NSMutableParagraphStyle()
        textAlignment.alignment = .center
        attributeTextDictionary[NSAttributedStringKey.paragraphStyle.rawValue] = textAlignment
        
        //check if camera source is available 
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //setup Button states
        if selectedImageView.image == nil || selectedImageView.image == #imageLiteral(resourceName: "defaultImage") {
            shareButton.isEnabled = false
            cancelButton.isEnabled = false
            settingsButton.isEnabled = false
            topTextField.isHidden = true
            bottomTextField.isHidden = true
        } else {
            shareButton.isEnabled = true
            cancelButton.isEnabled = true
            settingsButton.isEnabled = true
            topTextField.isHidden = false
            bottomTextField.isHidden = false
            memeView.bringSubview(toFront: topTextField)
            memeView.bringSubview(toFront: bottomTextField)
        }
    }
    
    func setupPortraitLayoutConstraints() {
        //calculate constraints of the Meme View from sizes of other elements
        let width = view.safeAreaLayoutGuide.layoutFrame.width
        let height = view.safeAreaLayoutGuide.layoutFrame.height
        let topToolBarHeight = topToolBar.frame.height
        let bottomToolbarHeight = bottomToolbar.frame.height
        
        let const = (height - (topToolBarHeight + bottomToolbarHeight) - width) / 2
        
        //set calculated Layout
        constraintTopBartoMemeView.constant = const
        constraintMemeViewTobottomBar.constant = const
        constraintMemeViewTrailing.constant = 0
        constraintMemeViewLeading.constant = 0
    }
    
    //To be used for identifying the image size ratio to calculate autoloayout constraints. todo
    func getImageRatio() -> CGFloat {
        var imageRatio: CGFloat = 0.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageRatio = ((selectedImageView.image?.size.width ?? 0) / (selectedImageView.image?.size.height ?? 1))
        }
        return imageRatio
    }
    
    func setupLandscapeLayoutConstraints() {
        //calculate constraints of the Meme View
        let height = view.safeAreaLayoutGuide.layoutFrame.height
        let width = view.safeAreaLayoutGuide.layoutFrame.width
        let topToolbarHeight = topToolBar.frame.height
        let bottomToolbarHeight = bottomToolbar.frame.height
        
        let const = (width - (height - topToolbarHeight - bottomToolbarHeight)) / 2
        
        //set calculated Layout
        constraintTopBartoMemeView.constant = 0
        constraintMemeViewTobottomBar.constant = 0
        constraintMemeViewLeading.constant = const
        constraintMemeViewTrailing.constant = const
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            let value = UIDevice.current.orientation.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            HomeViewController.attemptRotationToDeviceOrientation()
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
    
    //MARK: - Keyboard's Observer methods
    func setObserversForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    public func removeObserversForKeyboard(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide , object: nil)
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
            activityController.completionWithItemsHandler = { (activityTypeChosen, completed , items, error) in
                if completed {
                    self.saveMeme()
                }
            }
            present(activityController, animated: true, completion: nil)
            if let popOver = activityController.popoverPresentationController {
                popOver.sourceView = self.view
                popOver.barButtonItem = self.shareButton
            }
        }
    }
    
    //MARK: - Delete press action
    @IBAction func cancelTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the current Meme?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.selectedImageView.image = #imageLiteral(resourceName: "defaultImage")
            self.initializeUI()
            self.viewWillLayoutSubviews()
        }
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Save current Meme to an array
    func saveMeme() {
        if let image = selectedImageView.image {
            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: image, memedImage: image)
            memeArray.append(meme)
        }
    }
    
    //MARK: - Create Meme Image from the View
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
        if existingText == "TOP TEXT" || existingText == "BOTTOM TEXT" {
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
    
    //Setting the attributes created for the Text Fields
    func setTextFieldAttributes() {
        topTextField.defaultTextAttributes = attributeTextDictionary
        bottomTextField.defaultTextAttributes = attributeTextDictionary
    }
}


