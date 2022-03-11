//
//  WeatherCell.swift
//  SimpleWeather
//
//  Created by Ravikant Kumar on 11/03/22.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCellData(weatherList: weatherList?,weaterReport: WeatherModel?) {
        weatherLabel.text = weatherList?.main
        let teampVal = weaterReport?.main?.temp ?? 0.0
        tempLabel.text = "Temp: \(teampVal)"
    }
}
