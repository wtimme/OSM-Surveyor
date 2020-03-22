//
//  ViewController.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 3/22/20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit
import TangramMap

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
    }
}

