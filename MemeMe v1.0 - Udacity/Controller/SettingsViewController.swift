//
//  SettingsViewController.swift
//  MemeMe v1.0 - Udacity
//
//  Created by Vigneshraj Sekar Babu on 8/30/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit

//MARK: - Global variables
var attributeTextDictionary : [String:Any]  = [
    NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
    NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
    NSAttributedStringKey.font.rawValue : UIFont(name: "Impact", size: 40) ?? UIFont.systemFont(ofSize: 40),
    NSAttributedStringKey.strokeWidth.rawValue : -2.0
    ]

//Initializing values to use for default attributes
var pickedFont = "Impact"
var pickedColor = "White"
var pickedBorderColor = "Black"
var pickedBorderWidth = "2"



class SettingsViewController: UIViewController {

    @IBOutlet weak var fontTextField: CustomTextField!
    @IBOutlet weak var colorTextField: CustomTextField!
    @IBOutlet weak var borderColorTextField: CustomTextField!
    @IBOutlet weak var borderWidthTextField: CustomTextField!
    @IBOutlet weak var sampleTextField: UITextField!
    @IBOutlet weak var constraintSampleTextToSettingsStack: NSLayoutConstraint!
    let picker = UIPickerView()
    let toolbar = UIToolbar()
    
    //List of values needed for each attribute
    let fonts = ["Impact", "HelveticaNeue", "ChalkboardSE", "Futura"]
    let colorsArray = ["White", "Black", "Red", "Blue", "Green"]
    let widthArray = [-1,-2,-3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    func initializeUI() {
        setupPicker()
        setupToolbar()
        setupTextFields()
    }
    
    func setupToolbar() {
        //setting up the input accessory view
        toolbar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([space,button], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: 44.0)
    }
    
    //MARK: - Modify UI when the device changes orientation
    override func viewWillLayoutSubviews() {
        if UIDevice.current.orientation.isLandscape {
            constraintSampleTextToSettingsStack.constant = 20.0
        } else {
            constraintSampleTextToSettingsStack.constant = 55.0
        }
        
        let value = UIDevice.current.orientation.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        SettingsViewController.attemptRotationToDeviceOrientation()
    }
    
    //MARK: - Actions for Bar buttons
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Attributes Helper methods
    func getColor(fromString string: String) -> UIColor {
        var color = UIColor.white
        
        switch string {
        case "White":
            color = UIColor.white
        case "Black":
            color = UIColor.black
        case "Red":
            color = UIColor.red
        case "Blue":
            color = UIColor.blue
        case "Green":
            color = UIColor.green
        default:
            color = UIColor.white
        }
        return color
    }
    
    func getFontName(for string: String) -> String {
        var fontName = "HelveticaNeue-CondensedBlack"
        
        switch string {
        case "HelveticaNeue":
            fontName = "HelveticaNeue-CondensedBlack"
        case "ChalkboardSE":
            fontName = "ChalkboardSE-Bold"
        case "Futura":
            fontName = "Futura-CondensedExtraBold"
        case "Impact":
            fontName = "Impact"
        default:
               fontName = "HelveticaNeue-CondensedBlack"
        }
        return fontName
    }
}


extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    fileprivate func setupPicker() {
        //picker delegate & data source
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: 162.0)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if fontTextField.isFirstResponder {
            return fonts.count
        } else if colorTextField.isFirstResponder || borderColorTextField.isFirstResponder {
            return colorsArray.count
        } else if borderWidthTextField.isFirstResponder {
            return widthArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if fontTextField.isFirstResponder {
            return fonts[row]
        } else if colorTextField.isFirstResponder || borderColorTextField.isFirstResponder {
            return colorsArray[row]
        } else if borderWidthTextField.isFirstResponder {
            return String(widthArray[row] * -1)
        }
        return "Error"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Check the input text field and set corresponding attribute
        if fontTextField.isFirstResponder {
            fontTextField.text = fonts[row]
            pickedFont = fontTextField.text ?? "HelveticaNeue"
            attributeTextDictionary[NSAttributedStringKey.font.rawValue] = UIFont(name: getFontName(for: fonts[row]) , size: 40.0)
        } else if colorTextField.isFirstResponder {
            colorTextField.text = colorsArray[row]
            pickedColor = colorTextField.text ?? "White"
            attributeTextDictionary[NSAttributedStringKey.foregroundColor.rawValue] = getColor(fromString: colorsArray[row])
        } else if borderColorTextField.isFirstResponder {
            borderColorTextField.text = colorsArray[row]
            pickedBorderColor = borderColorTextField.text ?? "Black"
            attributeTextDictionary[NSAttributedStringKey.strokeColor.rawValue] = getColor(fromString: colorsArray[row])
        } else if borderWidthTextField.isFirstResponder {
            borderWidthTextField.text = String(widthArray[row] * -1)
            pickedBorderWidth = borderWidthTextField.text ?? "2"
            attributeTextDictionary[NSAttributedStringKey.strokeWidth.rawValue] = widthArray[row]
        }
        sampleTextField.defaultTextAttributes = attributeTextDictionary
    }
}


extension SettingsViewController: UITextFieldDelegate {
    
    func setupTextFields() {
        //setting up the view controller as delegates of the text fields
        fontTextField.delegate = self
        colorTextField.delegate = self
        borderColorTextField.delegate = self
        borderWidthTextField.delegate = self
        
        //assign default values for the fields when UI loads for first time
        fontTextField.text = pickedFont
        colorTextField.text = pickedColor
        borderWidthTextField.text = pickedBorderWidth
        borderColorTextField.text = pickedBorderColor
        
        //setup input views for the text fields
        fontTextField.inputView = picker
        colorTextField.inputView = picker
        borderColorTextField.inputView = picker
        borderWidthTextField.inputView = picker
        
        setupInputAccesoryForTextField()
        
        //Setup sample field's properties
        sampleTextField.textAlignment = .right
        sampleTextField.contentVerticalAlignment = .center
        sampleTextField.defaultTextAttributes = attributeTextDictionary
        sampleTextField.isUserInteractionEnabled = false
    }
    
    func setupInputAccesoryForTextField() {
        //setup input accessory views
        fontTextField.inputAccessoryView = toolbar
        colorTextField.inputAccessoryView = toolbar
        borderColorTextField.inputAccessoryView = toolbar
        borderWidthTextField.inputAccessoryView = toolbar
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var row = 0
        if fontTextField.isFirstResponder {
            row = fonts.index(of: pickedFont) ?? 0
        } else if colorTextField.isFirstResponder {
            row = colorsArray.index(of: pickedColor) ?? 0
        } else if borderColorTextField.isFirstResponder {
            row = colorsArray.index(of: pickedBorderColor) ?? 0
        } else if borderWidthTextField.isFirstResponder {
            let value = (Int(pickedBorderWidth) ?? 2) * -1
            row = widthArray.index(of: value) ?? 0
        }
        picker.selectRow(row, inComponent: 0, animated: true)
    }
    
 
}

