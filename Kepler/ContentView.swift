//
//  ContentView.swift
//  Kepler
//
//  Created by Jonathan Zrake on 1/20/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: String?
    @State private var time: CGFloat = 0.0

    var views: [(String, AnyView)] {
        [
            ("Welcome", AnyView(Text("Welcome"))),
            ("Circle", AnyView(Circle())),
            ("Particles", AnyView(ParticlesView())),
            ("SynodicPeriod", AnyView(SynodicPeriod(time: $time))),
        ]
    }
    var body: some View {
        HSplitView {
            NavigationStack {
                List(views, id: \.0, selection: $selection) { (name, _) in
                    Text(name)
                }
            }.frame(minWidth: 100, maxWidth: 200)
            views
                .first(where: { $0.0 == (selection ?? "Welcome") })!.1
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
