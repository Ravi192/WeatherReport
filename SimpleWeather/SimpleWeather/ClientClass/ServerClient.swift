//
//  ServerClient.swift
//  SimpleWeather
//
//  Created by Ravikant Kumar on 11/03/22.
//

import Foundation

class ServerClient {
    
    func getWheatherReport(with cityName: String, completionHandler: ((WeatherModel?, Int, Error?) -> Void)? = nil) {
        let escapedcityName = cityName.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let path = "\(UrlPath.openWeatherMapBaseURL)?APPID=\(UrlPath.openWeatherMapAPIKey)&q=\(escapedcityName ?? "")"
        let weatherRequestURL = URL(string: path)!
        guard NSURLComponents(url: weatherRequestURL, resolvingAgainstBaseURL: false) != nil else {
            return
        }
        var request = URLRequest(url: weatherRequestURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let utf8Data = String(decoding: data, as: UTF8.self).data(using: .utf8),
                let httpCode = (response as? HTTPURLResponse)?.statusCode,
                let jsonResult = try? JSONDecoder().decode(WeatherModel.self, from: utf8Data)
                else {
                    var weatherData: WeatherModel?
                    let httpCode = (response as? HTTPURLResponse)?.statusCode
                    completionHandler!(weatherData, httpCode ?? 403, error)
                    return
            }
            completionHandler!(jsonResult, httpCode, error)
        }
        task.resume()
    }
}

