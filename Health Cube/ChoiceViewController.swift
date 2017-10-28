//
//  ViewController.swift
//  Health Cube
//
//  Created by Mustafa Yusuf on 28/10/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let title = (sender as? UIButton)?.currentTitle else { return	}
		
		if let destination = segue.destination as? LoginViewController {
			if title.contains("Doctor") {
				destination.setupDoctorLogin()
			} else if title.contains("Patient") {
				destination.setupPatientLogin()
			} else if title.contains("NGO") {
				destination.setupGovNGOLogin()
			} else if title.contains("Asha") {
				destination.setupAshaLogin()
			} else {
				print("\n\nInvalid entry\n\n")
			}
		}
		
	}


}

