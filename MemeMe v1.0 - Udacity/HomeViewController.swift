//
//  HomeViewController.swift
//  MemeMe v1.0 - Udacity
//
//  Created by Vigneshraj Sekar Babu on 8/28/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        setupImagePicker()
    }
    
    func initializeUI() {
        view.backgroundColor = .white
        if selectedImageView.image == nil {
            shareButton.isEnabled = false
            cancelButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
            cancelButton.isEnabled = true
        }
    }
    
    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    @IBAction func albumSelected(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func cameraSelected(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func actionTapped(_ sender: Any) {
        if let image = selectedImageView.image {
        let activityController = UIActivityViewController(activityItems: [image as UIImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
    }
    
    
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
    
}
