//
//  CityViewController.swift
//  SimpleWeather
//
//  Created by Ravikant Kumar on 11/03/22.
//

import UIKit

class CityViewController: UIViewController {
    
    @IBOutlet weak var cityTableView: UITableView!
    
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    private var serverClient: ServerClient?
    var weatherArray: [weatherList] = []
    var weatherArrayData: WeatherModel?
    var enteredCityName: String = ""
    var indicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "City Name", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        let nib = UINib(nibName: "WeatherCell", bundle: nil)
        cityTableView.register(nib, forCellReuseIdentifier: "weatherCell")
        cityTableView.delegate = self
        cityTableView.dataSource = self
        cityTableView.tableFooterView = UIView(frame: .zero)
        weatherReportFetch()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Activity Indicator while loading data
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func weatherReportFetch () {
        activityIndicator()
        indicator.startAnimating()
        serverClient = ServerClient()
        serverClient?.getWheatherReport(with: enteredCityName, completionHandler: { weatherData, http, error in
            if http == 200 {
                if weatherData?.weather?.count ?? 0 > 0 {
                    self.weatherArrayData = weatherData
                    self.weatherArray = weatherData?.weather ?? []
                    DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.cityTableView.reloadData()
                    }
                }
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Something went wrong, Please try after sometime...", preferredStyle: UIAlertController.Style.alert)

               alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.async {
                self.indicator.stopAnimating()
                }
            }
        })
    }
    
    func tableTapped(tappedWeather: weatherList?, Index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "cityDetails") as! CityWeatherDetailViewController
        vc.weatherArrayData = weatherArrayData
        vc.index = Index
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherArrayData?.weather?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as? WeatherCell else {
            
            return tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
        }
        cell.selectionStyle = .none
        cell.setupCellData(weatherList: weatherArrayData?.weather?[indexPath.row], weaterReport: weatherArrayData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableTapped(tappedWeather: weatherArrayData?.weather?[indexPath.row], Index: indexPath.row)
    }
    
    
}
