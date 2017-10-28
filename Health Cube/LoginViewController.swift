//
//  LoginViewController.swift
//  Health Cube
//
//  Created by Mustafa Yusuf on 28/10/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit
import Firebase

enum type: String {
	case patient = "patient"
	case doctor = "doctor"
	case asha = "asha"
	case GovNGO = "govNGO"
}

class LoginViewController: UIViewController {
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var loginButton: DesignableButton!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var scanButton: DesignableButton!
	@IBOutlet weak var textField: UITextField!
	
	var user = type.patient
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		activityIndicator.isHidden = true
		textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		
    }

	func setupDoctorLogin() {
		user = type.doctor
		textField.placeholder = "Doctor ID"
		passwordTextField.isUserInteractionEnabled = false
		loginButton.isUserInteractionEnabled = false
		scanButton.isUserInteractionEnabled = false
	}
	
	func setupPatientLogin() {
		user = type.patient
		textField.placeholder = "Aadhaar UID"
		passwordTextField.isUserInteractionEnabled = false
		loginButton.isUserInteractionEnabled = false
		scanButton.isUserInteractionEnabled = true
	}
	
	func setupGovNGOLogin() {
		user = type.GovNGO
		textField.placeholder = "Unique ID"
		passwordTextField.isUserInteractionEnabled = false
		loginButton.isUserInteractionEnabled = false
		scanButton.isUserInteractionEnabled = false
	}
	
	func setupAshaLogin() {
		user = type.asha
		textField.placeholder = "Asha ID"
		passwordTextField.isUserInteractionEnabled = false
		loginButton.isUserInteractionEnabled = false
		scanButton.isUserInteractionEnabled = false
	}
	
	func checkPatient(uid: String) {
		
		Database.database().reference().child("patient").child(uid).observeSingleEvent(of: .value, with: { snapshot in
			
			if snapshot.exists() {
				var user = [String: String]()
				for i in snapshot.children.allObjects as! [DataSnapshot] {
					print(i.key, "\t", i.value as? String ?? "")
					user.updateValue(i.value as? String ?? "", forKey: i.key)
				}
				
				if let p = user["password"] {
					self.passwordTextField.placeholder = "Password"
				} else {
					self.passwordTextField.placeholder = "Create password"
					if let x = UserDefaults.standard.value(forKey: "patient") as? [String: Any] {
						var y = x
						y.updateValue(status, forKey: "vaccines")
						Database.database().reference().child("patient").child(uid).updateChildValues(y)
					}
				}
				
				
			} else {
				self.passwordTextField.placeholder = "Create password"
				if let x = UserDefaults.standard.value(forKey: "patient") as? [String: Any] {
					var y = x
					y.updateValue(status, forKey: "vaccines")
					Database.database().reference().child("patient").child(uid).updateChildValues(y)
				}
				
			}
			
		})
		
//		Database.database().reference().child("patient").observeSingleEvent(of: .value, with: { snapshot in
//
//			print(snapshot.children.allObjects as? [NSDictionary] ?? "Could not parse user")
//
//		})
	}
	
	
	@objc func textFieldDidChange(_ textField: UITextField) {
		
		if user.rawValue == type.patient.rawValue {
			if textField.text?.characters.count == 12 {
				scanButton.isUserInteractionEnabled = false
				activityIndicator.isHidden = false
				activityIndicator.startAnimating()
				checkPatient(uid: textField.text!)
				//CHECK patient exist or not.
			}
		}
		
	}
	
	@IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
		dismiss(animated: true, completion: nil)
		if let x = UserDefaults.standard.value(forKey: "patient") as? [String: Any] {
			textField.text = x["uid"] as? String ?? ""
			checkPatient(uid: textField.text!)
		}
	}
	
	
	
}
