//
//  CityWeatherDetailViewController.swift
//  SimpleWeather
//
//  Created by Ravikant Kumar on 11/03/22.
//

import UIKit

class CityWeatherDetailViewController: UIViewController {
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var feelsLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var weatherArrayData: WeatherModel?
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(weatherArrayData?.weather?.isEmpty ?? true) {
            let tempValue = weatherArrayData?.main?.temp ?? 0.0
            tempLabel.text = String(tempValue)
            let feelsValue = weatherArrayData?.main?.feelslike ?? 0.0
            feelsLabel.text = "Feels Like:  \(feelsValue)"
            titleLabel.text = weatherArrayData?.weather?[index].main
            descriptionLabel.text = weatherArrayData?.weather?[index].description
        }
    }
}
