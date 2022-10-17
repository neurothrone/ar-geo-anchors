//
//  Coordinator.swift
//  ARGeoAnchors
//
//  Created by Zaid Neurothrone on 2022-10-17.
//

import CoreLocation
import RealityKit
import ARKit

extension simd_float4x4 {
  var translation: SIMD3<Float> {
    get {
      SIMD3<Float>(columns.3.x, columns.3.y, columns.3.z)
    }
    
    set(newValue) {
      columns.3.x = newValue.x
      columns.3.y = newValue.y
      columns.3.z = newValue.z
    }
  }
}

class ARSessionCoordinator: NSObject, CLLocationManagerDelegate, ARCoachingOverlayViewDelegate {
  var arView: ARView?
  
  let locationManager: CLLocationManager = .init()
  var currentLocation: CLLocation?
  
  override init() {
    super.init()
    
    locationManager.delegate = self
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.requestLocation()
    locationManager.startUpdatingLocation()
  }
  
  func setUpCoachingOverlay() {
    guard let arView = arView else { return }
    
    arView.addCoachingOverlay(self)
  }
  
  func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
    guard let arView = arView else { return }
    
    let coordinate = CLLocationCoordinate2D(latitude: 55.547180, longitude: 13.082990)
    let geoAnchor = ARGeoAnchor(coordinate: coordinate)
    
    let anchor = AnchorEntity(anchor: geoAnchor)
    let box = ModelEntity(mesh: .generateBox(size: 1.0), materials: [SimpleMaterial(color: .purple, isMetallic: true)])
    
    anchor.addChild(box)
    arView.session.add(anchor: geoAnchor)
    arView.scene.addAnchor(anchor)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    currentLocation = locations.first
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("❌ -> Failed to get location. Error: \(error)")
  }
  
  @objc func onTap(_ recognizer: UITapGestureRecognizer) {
    guard let arView = arView else { return }
    
    let tapLocation = recognizer.location(in: arView)
    let raycastResults = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
    
    guard let firstRaycast = raycastResults.first else { return }

    arView.session.getGeoLocation(forPoint: firstRaycast.worldTransform.translation) { coordinate, altitude, error in
      if let error {
        fatalError("❌ -> Failed to get Geo Location. Error: \(error)")
      }
      
      // If this does not work, use current location. Will use the coordinate you place the box
//      let geoAnchor = ARGeoAnchor(coordinate: coordinate, altitude: altitude)
      
      // Will use the coordinate you are standing in
      guard let currentLocation = self.currentLocation else { return }
      let geoAnchor = ARGeoAnchor(coordinate: currentLocation.coordinate, altitude: altitude)
      
      let anchor = AnchorEntity(anchor: geoAnchor)
      let box = ModelEntity(mesh: .generateBox(size: 1.0), materials: [SimpleMaterial(color: .purple, isMetallic: true)])
      
      anchor.addChild(box)
      arView.session.add(anchor: geoAnchor)
      arView.scene.addAnchor(anchor)
    }
  }
}
