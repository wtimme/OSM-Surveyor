//
//  ViewController.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 3/22/20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit
import TangramMap
import OSMSurveyorFramework

class ViewController: UIViewController {
    
    @IBOutlet private var mapView: TGMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
    }
    
    private func configureMap() {
        
        guard let sceneURL = Bundle.main.url(forResource: "scene", withExtension: "yaml") else {
            /// Unable to get the scene.
            return
        }
        
        mapView.mapViewDelegate = self
        mapView.loadScene(from: sceneURL, with: nil)
    }


}

extension ViewController: TGMapViewDelegate {
    func mapView(_ mapView: TGMapView, didLoadScene sceneID: Int32, withError sceneError: Error?) {
        let coordinate = CLLocationCoordinate2D(latitude: 53.55439, longitude: 9.99413)
        let cameraPosition = TGCameraPosition(center: coordinate,
                                              zoom: 16,
                                              bearing: 0,
                                              pitch: TGRadiansFromDegrees(-15))!
        mapView.fly(to: cameraPosition, withDuration: 1, callback: nil)
        
        let marker = mapView.markerAdd()
        marker.stylingString = "{ style: 'points', color: 'red', size: [50px, 50px], order: 2000, collide: false }"
        marker.point = coordinate
    }
}

extension ViewController: MapViewControllerProtocol {
    func fly(to position: CameraPosition, duration: TimeInterval) {
        let center = CLLocationCoordinate2D(latitude: position.center.latitude,
                                            longitude: position.center.longitude)
        
        guard
            let cameraPosition = TGCameraPosition(center: center,
                                                  zoom: CGFloat(position.zoom),
                                                  bearing: position.bearing,
                                                  pitch: CGFloat(position.pitch))
            else {
            return
        }
        
        mapView.fly(to: cameraPosition, withDuration: duration, callback: nil)
    }
}
