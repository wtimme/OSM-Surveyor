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
}

