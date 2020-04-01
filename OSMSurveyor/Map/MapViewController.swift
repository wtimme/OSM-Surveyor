//
//  MapViewController.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 3/22/20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit
import TangramMap
import OSMSurveyorFramework
import SafariServices

/// An object that provides the camera position.
protocol CameraPositionProviding {
    /// The current `CameraPosition` of the receiver.
    var cameraPosition: CameraPosition { get }
}

class MapViewController: UIViewController {
    
    @IBOutlet private var mapView: TGMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        testDatabaseIntegration()
    }
    
    private func configureMap() {
        guard let apiKey = nextzenApiKey else {
            assertionFailure("Unable to load map: Missing API key for Nextzen")
            return
        }
        
        guard let sceneURL = Bundle.main.url(forResource: "scene", withExtension: "yaml") else {
            /// Unable to get the scene.
            return
        }
        
        mapView.mapViewDelegate = self
        mapView.loadScene(from: sceneURL, with: [TGSceneUpdate(path: "global.api_key", value: apiKey)])
    }
    
    private func testDatabaseIntegration() {
        guard let database = QuestDatabase(filename: "db.sqlite3") else {
            print("Unable to get the database")
            return
        }
        
        print("\(database)")
    }
    
    private var nextzenApiKey: String? {
        guard
            let secretsPlistPath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let secretsAsDictionary = NSDictionary(contentsOfFile: secretsPlistPath)
        else {
            assertionFailure("Unable to read the property list")
            return nil
        }
        
        return secretsAsDictionary.object(forKey: "Nextzen API Key") as? String
    }

    @IBAction private func showOpenStreetMapCopyrightAndLicensePage() {
        guard let url = URL(string: "https://www.openstreetmap.org/copyright") else { return }
        
        let viewController = SFSafariViewController(url: url)
        viewController.modalPresentationStyle = .pageSheet
        present(viewController, animated: true)
    }
}

extension MapViewController: TGMapViewDelegate {
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

extension MapViewController: MapViewControllerProtocol {
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

extension MapViewController: CameraPositionProviding {
    var cameraPosition: CameraPosition {
        let tangramCameraPosition = mapView.cameraPosition
        
        return CameraPosition(center: Coordinate(latitude: tangramCameraPosition.center.latitude,
                                                 longitude: tangramCameraPosition.center.longitude),
                              zoom: Double(tangramCameraPosition.zoom),
                              bearing: tangramCameraPosition.bearing,
                              pitch: Double(tangramCameraPosition.pitch))
    }
}
