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
	@IBOutlet weak var statisticsButton: DesignableButton!
	
	var myBool = Bool()
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		
		
    }
	
	override func viewDidAppear(_ animated: Bool) {
		statisticsButton.isHidden = myBool
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
			goButton.isUserInteractionEnabled = true
			UserDefaults.standard.set(x["uid"], forKey: "uid")
			goBtn(UIButton())
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
	
}
