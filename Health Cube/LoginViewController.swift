//
//  LoginViewController.swift
//  Health Cube
//
//  Created by Mustafa Yusuf on 28/10/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit
import Firebase

enum Type: String {
	case patient = "patient"
	case doctor = "doctor"
	case asha = "asha"
	case GovNGO = "govNGO"
}

class LoginViewController: UIViewController {
	
	@IBOutlet weak var loginButton: DesignableButton!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var scanButton: DesignableButton!
	@IBOutlet weak var textField: UITextField!
	
	var user = Type.patient
	var userFetched = [String: Any]()
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		
		
		passwordTextField.isUserInteractionEnabled = false
		loginButton.isUserInteractionEnabled = false
		scanButton.isUserInteractionEnabled = false
		scanButton.isEnabled = false
		
		if user.rawValue == Type.doctor.rawValue {
			passwordTextField.isUserInteractionEnabled = true
			textField.placeholder = "Doctor ID"
		} else if user.rawValue == Type.patient.rawValue {
			textField.placeholder = "Aadhaar UID"
			scanButton.isEnabled = true
			scanButton.isUserInteractionEnabled = true
		} else if user.rawValue == Type.asha.rawValue {
			textField.placeholder = "Unique ID"
		} else if user.rawValue == Type.GovNGO.rawValue {
			textField.placeholder = "Asha ID"
		}
		
    }

	func setupDoctorLogin() {
		user = Type.doctor
	}
	
	func setupPatientLogin() {
		user = Type.patient
	}
	
	func setupGovNGOLogin() {
		user = Type.GovNGO
	}
	
	func setupAshaLogin() {
		user = Type.asha
	}
	
	func checkPatient(uid: String) {
		
		Database.database().reference().child("patient").child(uid).observeSingleEvent(of: .value, with: { snapshot in
			
			if snapshot.exists() {
				
				for i in snapshot.children.allObjects as! [DataSnapshot] {
					print(i.key, "\t", i.value as? String ?? "")
					self.userFetched.updateValue(i.value as? String ?? "", forKey: i.key)
				}
				
				if let _ = self.userFetched["password"] as? String {
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
		
	}
	
	@IBAction func loginBtn(sender: UIButton) {
		
		guard let _ = textField.text, let _ = passwordTextField else { return }
		
		if user.rawValue == Type.doctor.rawValue {
			Database.database().reference().child("doctor").child(textField.text!).observeSingleEvent(of: .value, with: { snapshot in
				
				if snapshot.exists() {
					for i in (snapshot.children.allObjects) as! [DataSnapshot] {
						if i.key == "password" {
							if i.value as? String ?? "" == self.passwordTextField.text! {
								self.performSegue(withIdentifier: "rest", sender: self)
							} else {
								self.displayAlert(title: "Incorrect Password", message: "Try again!")
							}
						}
					}
				}
				
			})
		}
		
		else if user.rawValue == Type.patient.rawValue {
			if let p = userFetched["password"] as? String {
				if passwordTextField.text == p {
					performSegue(withIdentifier: "success", sender: self)
				} else {
					self.displayAlert(title: "Incorrect Password", message: "Try again!")
				}
			} else {
				Database.database().reference().child("patient").child(userFetched["uid"] as? String ?? "").updateChildValues(["password": passwordTextField.text!])
			}
		}
		
		else if user.rawValue == Type.asha.rawValue {
			Database.database().reference().child("asha").child(textField.text!).observeSingleEvent(of: .value, with: { snapshot in
				
				if snapshot.exists() {
					for i in (snapshot.children.allObjects) as! [DataSnapshot] {
						if i.key == "password" {
							if i.value as? String ?? "" == self.passwordTextField.text! {
								self.performSegue(withIdentifier: "rest", sender: self)
							} else {
								self.displayAlert(title: "Incorrect Password", message: "Try again!")
							}
						}
					}
				}
				
			})
		}
		
		else if user.rawValue == Type.GovNGO.rawValue {
			Database.database().reference().child("govNGO").child(textField.text!).observeSingleEvent(of: .value, with: { snapshot in
				
				if snapshot.exists() {
					for i in (snapshot.children.allObjects) as! [DataSnapshot] {
						if i.key == "password" {
							if i.value as? String ?? "" == self.passwordTextField.text! {
								self.performSegue(withIdentifier: "rest", sender: self)
							} else {
								self.displayAlert(title: "Incorrect Password", message: "Try again!")
							}
						}
					}
				}
				
			})
		}

		
	}
	
	
	@objc func textFieldDidChange(_ textField: UITextField) {
		
		if user.rawValue == Type.patient.rawValue {
			if textField.text?.characters.count == 12 {
				loginButton.isUserInteractionEnabled = true
				passwordTextField.isUserInteractionEnabled = true
				checkPatient(uid: textField.text!)
				//CHECK patient exist or not.
			} else {
				loginButton.isUserInteractionEnabled = false
				passwordTextField.isUserInteractionEnabled = false
			}
		}
		
	}
	
	override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
		return true
	}
	
	@IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
		//dismiss(animated: true, completion: nil)
		if let x = UserDefaults.standard.value(forKey: "patient") as? [String: Any] {
			textField.text = x["uid"] as? String ?? ""
			passwordTextField.isUserInteractionEnabled = true
			loginButton.isUserInteractionEnabled = true
			checkPatient(uid: textField.text!)
		}
	}
	
	func displayAlert(title : String, message : String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

	
}
