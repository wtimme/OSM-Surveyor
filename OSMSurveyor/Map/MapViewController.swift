//
//  MapViewController.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 3/22/20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import OSMSurveyorFramework
import SafariServices
import TangramMap
import UIKit

class MapViewController: UIViewController {
    @IBOutlet private var mapView: TGMapView!
    @IBOutlet private var errorLabel: UILabel!
    private let mapDataDownloader: MapDataDownloading = MapDataDownloader.shared
    private var annotationManager = AnnotationManager.shared
    private var annotationLayer: AnnotationLayerProtocol?

    private var settingsCoordinator: SettingsCoordinatorProtocol?

    // MARK: Keys of `NSUserActivity` for state restoration

    private let latitudeUserActivityKey = "latitude"
    private let longitudeUserActivityKey = "longitude"
    private let zoomUserActivityKey = "zoom"
    private let bearingUserActivityKey = "bearing"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAnnotationLayer()

        annotationManager.delegate = self
        testDatabaseIntegration()
        configureMap()

        /// Make sure that the status bar has a white color.
        navigationController?.navigationBar.barStyle = .black
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setMapToInitialPosition()
    }

    private func configureMap() {
        mapView.mapViewDelegate = self
        mapView.gestureDelegate = self

        loadMapScene()
    }

    private func loadMapScene() {
        let sceneName: String
        switch traitCollection.userInterfaceStyle {
        case .dark:
            sceneName = "scene-dark"
        case .unspecified, .light:
            sceneName = "scene-light"
        @unknown default:
            sceneName = "scene-light"
        }

        guard let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "yaml", subdirectory: "map_theme") else {
            /// Unable to get the scene.
            return
        }

        mapView.loadScene(from: sceneURL, with: [])
    }

    private func setMapToInitialPosition() {
        let latitude: Double
        let longitude: Double
        let zoom: CGFloat
        let bearing: Double
        if let activityUserInfo = view.window?.windowScene?.userActivity?.userInfo,
            let latitudeFromActivity = activityUserInfo[latitudeUserActivityKey] as? Double,
            let longitudeFromActivity = activityUserInfo[longitudeUserActivityKey] as? Double,
            let zoomFromActivity = activityUserInfo[zoomUserActivityKey] as? CGFloat,
            let bearingFromActivity = activityUserInfo[bearingUserActivityKey] as? Double
        {
            latitude = latitudeFromActivity
            longitude = longitudeFromActivity
            zoom = zoomFromActivity
            bearing = bearingFromActivity
        } else {
            /// By default, use a coordinate from Hamburg, Germany.
            latitude = 53.55439
            longitude = 9.99413
            zoom = 16
            bearing = 0
        }

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let cameraPosition = TGCameraPosition(center: coordinate,
                                              zoom: zoom,
                                              bearing: bearing,
                                              pitch: TGRadiansFromDegrees(-15))!
        mapView.fly(to: cameraPosition, withDuration: 1, callback: nil)
    }

    private func setupAnnotationLayer() {
        guard let mapData = mapView.addDataLayer(TangramAnnotationLayer.Name, generateCentroid: false) else {
            return
        }

        annotationLayer = TangramAnnotationLayer(mapData: mapData)
    }

    private func testDatabaseIntegration() {
        guard let database = QuestDatabase(filename: "db.sqlite3") else {
            print("Unable to get the database")
            return
        }

        print("\(database)")
    }

    @IBAction private func showOpenStreetMapCopyrightAndLicensePage() {
        guard let url = URL(string: "https://www.openstreetmap.org/copyright") else { return }

        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true

        let viewController = SFSafariViewController(url: url, configuration: configuration)
        viewController.modalPresentationStyle = .pageSheet
        present(viewController, animated: true)
    }

    @IBAction private func didTapDownloadButton(_: AnyObject) {
        downloadQuestsInScreenArea()
    }

    @IBAction private func didTapSettingsButton() {
        settingsCoordinator = SettingsCoordinator(presentingViewController: self)

        settingsCoordinator?.start()
    }

    private func downloadQuestsInScreenArea(ignoreDownloaded: Bool = false) {
        guard let boundingBox = screenAreaToBoundingBox() else {
            updateErrorLabel("Can’t scan here. Try to zoom in further or tilt the map less.")
            return
        }

        do {
            try mapDataDownloader.download(in: boundingBox,
                                           cameraPosition: cameraPosition,
                                           ignoreDownloaded: ignoreDownloaded)

            print("All good. Would've downloaded now.")
            updateErrorLabel(nil)
        } catch MapDataDownloadError.screenAreaTooLarge {
            updateErrorLabel("Please zoom in further")
        } catch {
            assertionFailure("Unexpected error: \(error.localizedDescription)")

            updateErrorLabel("Unexpected error")
        }
    }

    /// Saves the map's current state into a `NSUserActivity` object so that it can be restored when the app is restarted.
    private func updateUserActivity() {
        var currentUserActivity = view.window?.windowScene?.userActivity
        if currentUserActivity == nil {
            currentUserActivity = NSUserActivity(activityType: "de.wtimme.OSMSurveyor.map")
        }

        currentUserActivity?.addUserInfoEntries(from: [
            latitudeUserActivityKey: mapView.cameraPosition.center.latitude,
            longitudeUserActivityKey: mapView.cameraPosition.center.longitude,
            zoomUserActivityKey: mapView.cameraPosition.zoom,
            bearingUserActivityKey: mapView.cameraPosition.bearing,
        ])

        view.window?.windowScene?.userActivity = currentUserActivity
    }
}

extension MapViewController: TGMapViewDelegate {
    func mapView(_: TGMapView, regionDidChangeAnimated _: Bool) {
        guard let boundingBox = screenAreaToBoundingBox() else { return }

        annotationManager.mapDidUpdatePosition(to: boundingBox)

        updateUserActivity()
    }

    func mapView(_: TGMapView, didSelectLabel _: TGLabelPickResult?, atScreenPosition _: CGPoint) {
        // TODO: Implement me.
    }

    private func updateErrorLabel(_ text: String?) {
        errorLabel.text = text
        errorLabel.isHidden = text?.isEmpty ?? true
    }

    private var cameraPosition: CameraPosition {
        let tangramCameraPosition = mapView.cameraPosition

        return CameraPosition(center: Coordinate(latitude: tangramCameraPosition.center.latitude,
                                                 longitude: tangramCameraPosition.center.longitude),
                              zoom: Double(tangramCameraPosition.zoom),
                              bearing: tangramCameraPosition.bearing,
                              pitch: Double(tangramCameraPosition.pitch))
    }

    struct Padding {
        let left: CGFloat
        let top: CGFloat
        let right: CGFloat
        let bottom: CGFloat

        static var zero: Padding {
            return Padding(left: 0, top: 0, right: 0, bottom: 0)
        }
    }

    private func screenAreaToBoundingBox(padding: Padding = .zero) -> BoundingBox? {
        let width = mapView.bounds.width
        let height = mapView.bounds.height

        guard width > 0, height > 0 else { return nil }

        let size = (width: width - padding.left - padding.right,
                    height: height - padding.top - padding.bottom)

        /**
          the special cases here are: map tilt and map rotation:
          * map tilt makes the screen area -> world map area into a trapezoid
          * map rotation makes the screen area -> world map area into a rotated rectangle
          dealing with tilt: this method is just not defined if the tilt is above a certain limit
         */
        guard cameraPosition.pitch <= .pi / 4 else {
            // 45°
            return nil
        }

        let positions = [
            mapView.coordinate(fromViewPosition: CGPoint(x: padding.left, y: padding.top)),
            mapView.coordinate(fromViewPosition: CGPoint(x: padding.left + size.width, y: padding.top)),
            mapView.coordinate(fromViewPosition: CGPoint(x: padding.left, y: padding.top + size.height)),
            mapView.coordinate(fromViewPosition: CGPoint(x: padding.left + size.width, y: padding.top + size.height)),
        ]

        let positionsAsCoordinates = positions.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }

        return positionsAsCoordinates.enclosingBoundingBox
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let locationSearchViewController = segue.destination as? LocationSearchViewController {
            /// Set the map view controller as the delegate, so that the map position is updated when a location was selected.
            locationSearchViewController.delegate = self
        }
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

extension MapViewController: AnnotationManagerDelegate {
    func setAnnotations(_ annotations: [Annotation]) {
        annotationLayer?.setAnnotations(annotations)
    }
}

extension MapViewController: TGRecognizerDelegate {
    func mapView(_ view: TGMapView!, recognizer _: UIGestureRecognizer!, didRecognizeSingleTapGesture location: CGPoint) {
        view.pickLabel(at: location)
    }
}

extension MapViewController: LocationSearchDelegate {
    func didSelectLocation(coordinate _: Coordinate, boundingBox: BoundingBox) {
        let cameraPosition = mapView.cameraThatFitsBounds(TGCoordinateBounds(sw: CLLocationCoordinate2D(latitude: boundingBox.maximum.latitude,
                                                                                                        longitude: boundingBox.minimum.longitude),
                                                                             ne: CLLocationCoordinate2D(latitude: boundingBox.minimum.latitude,
                                                                                                        longitude: boundingBox.maximum.longitude)),
                                                          withPadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        mapView.fly(to: cameraPosition, withDuration: 2, callback: nil)
    }
}
