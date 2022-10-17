//
//  ContentView.swift
//  ARGeoAnchors
//
//  Created by Zaid Neurothrone on 2022-10-17.
//

import ARKit
import RealityKit
import SwiftUI

struct ContentView : View {
  @State private var isGeoTrackingSupported = true
  
  var body: some View {
    VStack {
      ARViewContainer()
        .edgesIgnoringSafeArea(.all)
        .alert(
          "GeoTracking is not supported in your region",
          isPresented: .constant(!isGeoTrackingSupported)
        ) {
          Button(role: .cancel, action: {}) {
            Text("OK")
          }
        }
    }
    .onAppear {
      ARGeoTrackingConfiguration.checkAvailability { isSupported, error in
        if let error {
          print("❌ -> Failed to check AR Geo Tracking availability. Error. \(error)")
        }
        
        if (!isSupported) {
          self.isGeoTrackingSupported = false
        }
      }
    }
  }
}

struct ARViewContainer: UIViewRepresentable {
  func makeUIView(context: Context) -> ARView {
    let arView = ARView(frame: .zero)
    
    let session = arView.session
    let config = ARGeoTrackingConfiguration()
    config.planeDetection = .horizontal
    session.run(config)
    
    arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(ARSessionCoordinator.onTap)))
    
    context.coordinator.arView = arView
    context.coordinator.setUpCoachingOverlay()
    
    return arView
  }
  
  func makeCoordinator() -> ARSessionCoordinator { .init() }
  func updateUIView(_ uiView: ARView, context: Context) {}
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
