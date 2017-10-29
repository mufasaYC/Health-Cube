//
//  ViewController.swift
//  Health Cube
//
//  Created by Mustafa Yusuf on 29/10/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var carouselView: iCarousel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		carouselView.delegate = self
		carouselView.dataSource = self
		carouselView.type = .linear
		carouselView.reloadData()
		carouselView.bounces = false
		carouselView.isPagingEnabled = true
		
		pageControl.numberOfPages = age.count
		
		if let x = UserDefaults.standard.value(forKey: "patient") as? [String: Any] {
			nameLabel.text = x["name"] as? String ?? ""
		}
		
	}
	
	
	func numberOfItems(in carousel: iCarousel) -> Int {
		return age.count
	}
	
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
		pageControl.currentPage = carouselView.currentItemIndex
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		
		var itemView: CustomView
		if (view == nil) {
			itemView = CustomView(frame: CGRect(x:0, y:0, width: carouselView.bounds.width, height: carouselView.bounds.height))
			itemView.backgroundImage.image = UIImage(named: age[index])
			itemView.dateLabel.text = ""
			
			for i in vaccines[index][age[index]]! {
				itemView.dateLabel.text = itemView.dateLabel.text! + "\n\(i)"
			}
			
			itemView.timeLabel.text = dateDifference(months: ageMonths[index])
			
			if let s = status[(vaccines[index][age[index]]?.first)!]  {
				if s == false {
					itemView.vaccinatedView.isHidden = true
					itemView.timeLabel.isHidden = false
				} else {
					itemView.vaccinatedView.isHidden = false
					itemView.timeLabel.isHidden = true
				}
			}
			
			itemView.titleLabel.text = age[index]
			
		} else {
			
			itemView = view! as! CustomView
			itemView.backgroundImage.image = UIImage(named: age[index])
			itemView.dateLabel.text = ""
			if let s = status[(vaccines[index][age[index]]?.first)!]  {
				if s == false {
					itemView.vaccinatedView.isHidden = true
					itemView.timeLabel.isHidden = false
				} else {
					itemView.vaccinatedView.isHidden = false
					itemView.timeLabel.isHidden = true
				}
			}
			itemView.timeLabel.text = dateDifference(months: ageMonths[index])
			for i in vaccines[index][age[index]]! {
				itemView.dateLabel.text = itemView.dateLabel.text! + "\n\(i)"
			}
			
			itemView.titleLabel.text = age[index]
		}
		return itemView
	}
	@IBAction func pageControlAction(_ sender: Any) {
		carouselView.scrollToItem(at: pageControl.currentPage, animated: true)
	}
	
	func dateDifference(months: Int) -> String {
		var dateRangeStart = Date()
		if let d = UserDefaults.standard.value(forKey: "patient") as? [String: Any] {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd-mm-yyyy"
			dateRangeStart = dateFormatter.date(from: "29-04-2017")!
		}
		//		let dateRangeStart = Date() //DOB
		let dateToday = Date() //TODAY
		print(months)
		var dateRangeEnd = Calendar.current.date(byAdding: .month, value: months%12, to: dateRangeStart) //DATE OF VACCINE
		dateRangeEnd = Calendar.current.date(byAdding: .year, value: months/12, to: dateRangeEnd!)
		let components = Calendar.current.dateComponents([.weekOfYear, .month, .year], from: dateToday, to: dateRangeEnd!)
		
		print(dateToday)
		print(dateRangeEnd!)
		if components.year ?? 0 == 0 && components.month ?? 0 == 0 {
			return "Get it done now!"
		}
		if components.month ?? 0 < 0 {
			return "You're late by \((components.year ?? 0) * -1) years and \((components.month ?? 0) * -1) months"
		}
		return "\(components.year ?? 0) years and \(components.month ?? 0) months"
		
		//		let months = components.month ?? 0
		//		let weeks = components.weekOfYear ?? 0
	}

	
}


