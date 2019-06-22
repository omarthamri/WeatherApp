//
//  WeatherTableViewController.swift
//  WeatherApp
//
//  Created by MACBOOK PRO RETINA on 22/06/2019.
//  Copyright © 2019 MACBOOK PRO RETINA. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController,UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var forcastData = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        updateWeatherForLocation(location: "New York")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
        }
    }
    
    func updateWeatherForLocation(location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks: [CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location  = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: { (results: [Weather]?) in
                        if let weatherData = results {
                            self.forcastData = weatherData
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
            
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forcastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYYY"
        return dateFormatter.string(from: date!)
    }
    
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let weatherObject = forcastData[indexPath.section]
        cell.textLabel?.text = weatherObject.summary
        
        cell.detailTextLabel?.text = "\(convertToCelsius(fahrenheit: Int(weatherObject.temperature))) °C"
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        return cell
    }

}
