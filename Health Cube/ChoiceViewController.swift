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
		guard let tag = (sender as? UIButton)?.tag else { return	}
		
		if let dest = segue.destination as? LoginViewController {
			if tag == 1 {
				dest.setupPatientLogin()
			} else if tag == 2 {
				dest.setupDoctorLogin()
			} else if tag == 3 {
				dest.setupGovNGOLogin()
			} else if tag == 4 {
				dest.setupAshaLogin()
			} else {
				print("\n\nInvalid entry\n\n")
			}
		}
	}
	
	override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
		return false
	}

}

