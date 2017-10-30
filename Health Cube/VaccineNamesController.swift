//
//  VaccineNamesController.swift
//  Health Cube
//
//  Created by Mustafa Yusuf on 29/10/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit

class VaccineNamesController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		tableView.delegate = self
		tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let s = (sender as? UITableViewCell)?.textLabel?.text else { return }
		if let dest = segue.destination as? GovNGOController {
			dest.key = s
		}
	}
	

}

extension VaccineNamesController: UITableViewDelegate, UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return status.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = Array(status.keys)[indexPath.row]
		return cell
	}
	
}


