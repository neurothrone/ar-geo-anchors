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
  var body: some View {
    ARViewContainer()
      .edgesIgnoringSafeArea(.all)
  }
}

struct ARViewContainer: UIViewRepresentable {
  func makeUIView(context: Context) -> ARView {
    let arView = ARView(frame: .zero)
    arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.onTap)))
    
    return arView
  }
  
  func makeCoordinator() -> Coordinator { .init() }
  func updateUIView(_ uiView: ARView, context: Context) {}
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
