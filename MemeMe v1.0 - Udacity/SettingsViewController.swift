//
//  SettingsViewController.swift
//  MemeMe v1.0 - Udacity
//
//  Created by Vigneshraj Sekar Babu on 8/30/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit

var attributeTextDictionary : [String:Any]  = [
    NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
    NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
    NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) ?? UIFont.systemFont(ofSize: 40),
    NSAttributedStringKey.strokeWidth.rawValue : -2.0
]

var pickedFont = "HelveticaNeue"
var pickedColor = "White"
var pickedBorderColor = "Black"
var pickedBorderWidth = "2"

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var sampleLabel: UILabel!
    @IBOutlet weak var fontTextField: CustomTextField!
    @IBOutlet weak var colorTextField: CustomTextField!
    @IBOutlet weak var borderColorTextField: CustomTextField!
    @IBOutlet weak var borderWidthTextField: CustomTextField!
    @IBOutlet weak var landscapeDoneButton: UIBarButtonItem!
    
    @IBOutlet weak var sampleTextField: UITextField!
    
    
    let picker = UIPickerView()
    let toolbar = UIToolbar()
    
    let fonts = ["HelveticaNeue", "ChalkboardSE", "Futura"]
    let colorsArray = ["White", "Black", "Red", "Blue"]
    let widthArray = [-1,-2,-3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
//        sampleLabel.attributedText = NSAttributedString(string: "Sample Text", attributes: attributeTextDictionary )
     
        picker.delegate = self
        picker.dataSource = self
        fontTextField.inputView = picker
        colorTextField.inputView = picker
        borderColorTextField.inputView = picker
        borderWidthTextField.inputView = picker
        setupToolbar()
        
        fontTextField.delegate = self
        colorTextField.delegate = self
        borderColorTextField.delegate = self
        borderWidthTextField.delegate = self
        
        fontTextField.text = pickedFont
        colorTextField.text = pickedColor
        borderWidthTextField.text = pickedBorderWidth
        borderColorTextField.text = pickedBorderColor
        
        sampleTextField.textAlignment = .right
        sampleTextField.contentVerticalAlignment = .center
        sampleTextField.defaultTextAttributes = attributeTextDictionary
        sampleTextField.isUserInteractionEnabled = false
        
        print(Width.Light.rawValue)
        
        print("\(pickedFont) -- \(pickedColor) -- \(pickedBorderColor) -- \(pickedBorderWidth)")
        
    }
    
    override func viewDidLayoutSubviews() {
        fontTextField.text = pickedFont
        colorTextField.text = pickedColor
        borderWidthTextField.text = pickedBorderWidth
        borderColorTextField.text = pickedBorderColor
        
        sampleTextField.textAlignment = .right
        sampleTextField.contentVerticalAlignment = .center
        sampleTextField.defaultTextAttributes = attributeTextDictionary
        sampleTextField.isUserInteractionEnabled = false
    }
    
    

    func setupToolbar() {
        toolbar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([space,button], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        fontTextField.inputAccessoryView = toolbar
        colorTextField.inputAccessoryView = toolbar
        borderColorTextField.inputAccessoryView = toolbar
        borderWidthTextField.inputAccessoryView = toolbar
    }
    
    override func viewWillLayoutSubviews() {
        let isLandscape = UIDevice.current.orientation.isLandscape
        landscapeDoneButton.isEnabled = isLandscape
        landscapeDoneButton.tintColor = isLandscape ? nil : .clear
        fontTextField.inputAccessoryView = isLandscape ? nil : toolbar
            colorTextField.inputAccessoryView = isLandscape ? nil : toolbar
            borderColorTextField.inputAccessoryView = isLandscape ? nil : toolbar
            borderWidthTextField.inputAccessoryView = isLandscape ? nil : toolbar
    
        
    }
    
    
    @IBAction func doneTapped(_ sender: Any) {
       
       
    
        dismissKeyboard()
    }
    
    @objc func dismissKeyboard() {
        picker.selectRow(0, inComponent: 0, animated: true)
        view.endEditing(true)
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
//             sampleLabel.attributedText = NSAttributedString(string: "Sample Text", attributes: attributeTextDictionary )
        sampleTextField.text = "Sample Text"
        sampleTextField.defaultTextAttributes = attributeTextDictionary
    }

    
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
        default:
               fontName = "HelveticaNeue-CondensedBlack"
        }
        
        return fontName
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
            let value = Int(pickedBorderWidth) ?? 2 * -1
            row = widthArray.index(of: value) ?? 0
        }
        
        picker.selectRow(row, inComponent: 0, animated: true)
        
    }
}


enum Width : Int {
    case Light = 1
    case Medium = 2
    case Thick = 3
}

