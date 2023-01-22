//
//  ContentView.swift
//  Particles
//
//  Created by Jonathan Zrake on 1/15/23.
//

import SwiftUI

struct ParticlesView: View {
    var body: some View {
        VStack {
            MetalView()
            Text("Metal particles 🤘")
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
    }
}
