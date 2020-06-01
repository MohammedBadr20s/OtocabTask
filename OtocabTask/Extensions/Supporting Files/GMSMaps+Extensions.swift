//
//  GMSMaps+Extensions.swift
//  OtocabTask
//
//  Created by MGoKu on 5/5/20.
//  Copyright © 2020 MohammedBadr. All rights reserved.
//
import Foundation
import UIKit
import GoogleMaps

private struct MapPath : Decodable{
    var routes : [Route]?
}

private struct Route : Decodable{
    var overview_polyline : OverView?
}

private struct OverView : Decodable {
    var points : String?
}

extension GMSMapView {
    
    //MARK:- Call API for polygon points
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, view: UIViewController){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: ("https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&key=\(Constants.shared.GoogleAPIKey)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                displayMessage(title: "Error", message: error.localizedDescription, status: .error, forController: view)
                
            } else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        guard let routes = json["routes"] as? NSArray else {
                            displayMessage(title: "Error", message: "No Routes", status: .error, forController: view)
                            return
                        }
                        
                        if (routes.count > 0) {
                            DispatchQueue.main.async {
                                let overview_polyline = routes[0] as? NSDictionary
                                let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                                
                                let points = dictPolyline?.object(forKey: "points") as? String
                                
                                self.showPath(polyStr: points!)
                                
                                
                                
                                
                                let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 170, left: 30, bottom: 30, right: 30))
                                self.moveCamera(update)
                            }
                        }
                        else {
                            displayMessage(title: "Error", message: "No Routes", status: .error, forController: view)
                        }
                    }
                }
                catch {
                    displayMessage(title: "Error", message: "error in JSONSerialization", status: .error, forController: view)
                    
                }
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        polyline.strokeColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        polyline.map = self // Your map view
    }
    
}
