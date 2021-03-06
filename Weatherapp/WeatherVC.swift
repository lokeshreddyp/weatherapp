//
//  WeatherVC.swift
//  Weatherapp
//
//  Created by lokeshreddy on 1/9/17.
//  Copyright © 2017 lokeshreddy. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController,UITableViewDataSource,UITableViewDelegate ,CLLocationManagerDelegate{

    @IBOutlet weak var dateLBL: UILabel!
    
    @IBOutlet weak var currenttempLBL: UILabel!
    
    @IBOutlet weak var locationLBL: UILabel!
    
    @IBOutlet weak var tempimage: UIImageView!
    
    @IBOutlet weak var titletempLBL: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

   var  locationanager  = CLLocationManager()
    
    var currentloctaion : CLLocation!
    
    
    
    
    var currentweather:CurrentWeather!
    var forecast:Forecast!
    var forecasts = [Forecast]()

    override func viewDidLoad() {
        
        
        locationanager.delegate = self
        //to get the best location
        locationanager.desiredAccuracy = kCLLocationAccuracyBest
        
        //when app is loaded authorization is required
        locationanager.requestWhenInUseAuthorization()
        locationanager.startMonitoringSignificantLocationChanges()
        
      currentweather = CurrentWeather()
   // forecast = Forecast(newDict)
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
     //   print(URL)
        print(😝)
       
      
    
        
       
    }
    
    
    //this will run before view loads
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
         currentloctaion = locationanager.location
         Location.sharedInstance.latitude = currentloctaion.coordinate.latitude
            Location.sharedInstance.longitude = currentloctaion.coordinate.longitude
            print("latitude is \(Location.sharedInstance.latitude) ,longitude is  \(Location.sharedInstance.longitude)")
            currentweather.weatherapicall {
                //print("got here third")
                self.forecastapicall{
                    self.jsondata()
                }
            }
            //   Location.sharedInstance.latitude
        }else {
            locationanager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
   
    func forecastapicall(completed : @escaping DownloadComplete){
        Alamofire.request(ForecastURL).responseJSON
            {
                response in
                let result = response.result
                
                if let dict = result.value as? Dictionary<String,AnyObject> {
                    if let list = dict["list"] as? [Dictionary<String,AnyObject>]
                    {
                        for obj in list {
                            let forecast  = Forecast(newDict: obj)
                            self.forecasts.append(forecast)
                            //print(obj)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
                
          completed()
                
                
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell{
            let Forecasttabledata = forecasts[indexPath.row]
            cell.configurecell(forcastapi_table: Forecasttabledata)
            return cell
        }
        else {
            return WeatherCell()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    
    func jsondata()
    {
        currenttempLBL.text = "\(currentweather.currenttemperature)"
        locationLBL.text = currentweather.cityname
        dateLBL.text = currentweather.date
        titletempLBL.text = currentweather.weathertype
        tempimage.image = UIImage(named: currentweather.weathertype)
       
        
        
    }
    
}

