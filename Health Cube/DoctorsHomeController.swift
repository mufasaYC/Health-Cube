//
//  DoctorsHomeController.swift
//  Health Cube
//
//  Created by Mustafa Yusuf on 29/10/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit
import Firebase

class DoctorsHomeController: UIViewController {

	@IBOutlet weak var scanButton: DesignableButton!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var goButton: DesignableButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@objc func textFieldDidChange(_ textField: UITextField) {
		if textField.text?.characters.count == 12 {
			goButton.isUserInteractionEnabled = true
		} else {
			goButton.isUserInteractionEnabled = false
		}
	}

    
	@IBAction func scanBtn(_ sender: UIButton) {
		
	}
	
	@IBAction func goBtn(_ sender: UIButton) {
		if textField.text?.characters.count != 12 { return }
		UserDefaults.standard.set(textField.text!, forKey: "uid")
		performSegue(withIdentifier: "show", sender: self)
	}
	
	override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
		return true
	}
	
	@IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
		//dismiss(animated: true, completion: nil)
		if let x = UserDefaults.standard.value(forKey: "patient") as? [String: Any] {
			textField.text = x["uid"] as? String ?? ""
			goButton.isUserInteractionEnabled = false
			UserDefaults.standard.set(x["uid"], forKey: "uid")
			performSegue(withIdentifier: "show", sender: self)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "show" {
			if let dest = segue.destination as? DoctorVaccineController {
				dest.fetchData()
			}
		}
	}
	
//	func fetchPatient(uid: String) {
//		guard let x = UserDefaults.standard.value(forKey: "patient") as? [String: Any] else { return }
//		Database.database().reference().child("patient").child(x["uid"] as? String ?? "").observeSingleEvent(of: .value, with: { snapshot in
//
//			if snapshot.exists() {
//
//				for i in snapshot.children.allObjects as! [DataSnapshot] {
//
//				}
//
//			}
//
//		})
//	}

	
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
