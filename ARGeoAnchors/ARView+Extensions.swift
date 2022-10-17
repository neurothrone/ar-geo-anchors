//
//  ARView+Extensions.swift
//  ARGeoAnchors
//
//  Created by Zaid Neurothrone on 2022-10-17.
//

import ARKit
import RealityKit

extension ARView {
  func addCoachingOverlay(_ delegate: ARSessionCoordinator) {
    let overlay = ARCoachingOverlayView()
    overlay.goal = .geoTracking
    overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    overlay.session = self.session
    overlay.delegate = delegate
    
    self.addSubview(overlay)
  }
}
