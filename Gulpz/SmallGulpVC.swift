//
//  SmallGulpVC.swift
//  Gulpz
//
//  Created by Jett on 1/25/19.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit

class SmallGulpVC: UIViewController, UITextFieldDelegate {
    var isFromSetting = false

    static func create() -> SmallGulpVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SmallGulpVC") as! SmallGulpVC
    }

    @IBOutlet weak var smallGulpTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBAction func tapToCloseKeyboard(_ sender: Any) {
        smallGulpTextField.resignFirstResponder()
    }
    @IBOutlet weak var keyboardCS: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // Blue Gradient
        view.setGradientBackground(colorOne: UIColor(red:0.00, green:0.47, blue:1.00, alpha:1.0), colorTwo: UIColor(red:0.00, green:0.25, blue:0.61, alpha:1.0))

        // EventListeners keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }

    func setupView() {
        UIFormatter.formatTextField(smallGulpTextField)
        UIFormatter.formatNextButton(nextButton)
        smallGulpTextField.keyboardType = .decimalPad
        smallGulpTextField.returnKeyType = .done
        smallGulpTextField.delegate = self
        nextButton.isEnabled = false

        if let unit = Setting.unit {
            let amount = "\(unit.getSmallGulpAmount().format()) \(unit.rawValue)"
            let descriptionContent = "(An avarage person’s \nsmall gulp is about \(amount))"
            descriptionLabel.text = descriptionContent
        }

        if Setting.smallGulp > 0 {
            nextButton.isEnabled = true
            smallGulpTextField.text = "\(Setting.smallGulp.format())"
        }

        if let amount = smallGulpTextField.text, let value = Double(amount) {
            nextButton.isEnabled = value > 0

            if isFromSetting {
                nextButton.setTitle("Save", for: .normal)
            }
        }
    }


    // Avoid keyboard obscuring the textfield
    @objc func keyboardWillChange(notification: Notification) {
        print("\(notification.name.rawValue)")
        guard let keyboardFrame =  notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else { return }

        let screenHeight: CGFloat = UIScreen.main.bounds.height

        UIView.animate(withDuration: 0.35, animations: {
            if keyboardFrame.origin.y == screenHeight {
                self.keyboardCS.constant = -110
            } else {
                self.keyboardCS.constant = 0
            }
            self.view.layoutIfNeeded()
        })
    }

    @IBAction func goNextScreen(_ sender: Any) {
        if let text = smallGulpTextField.text, let value = Double(text) {
            Setting.smallGulp = value

            if isFromSetting {
                navigationController?.popViewController(animated: true)
            } else {
                let controller = DrinkAmountVC.create()
                navigationController?.pushViewController(controller, animated: true)
            }

        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newText.isEmpty {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true

        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        smallGulpTextField.resignFirstResponder()
        return true
    }
}


