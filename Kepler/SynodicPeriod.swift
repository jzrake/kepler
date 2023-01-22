//
//  SynodicPeriod.swift
//  Kepler
//
//  Created by Jonathan Zrake on 1/22/23.
//

import SwiftUI
import Combine

private struct Segment: Shape {
    let p0: CGPoint
    let p1: CGPoint

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: p0)
            path.addLine(to: p1)
        }
    }
}

struct SynodicPeriod: View {

    let orbitalRadiusEarth: CGFloat = 1.0;
    @Binding var time: CGFloat
    @State private var timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common)
    @State private var token: Cancellable? = nil
    @State private var orbitalRadiusVenus: CGFloat = 0.71

    var body: some View {
        VStack {
            HStack {
                Button("Start / stop") {
                    if (token == nil) {
                        timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common)
                        token = timer.connect()
                    } else {
                        token!.cancel()
                        token = nil
                    }
                }
                Text("Year: \(time / (2 * .pi), specifier: "%.2f")")
                    .monospacedDigit()
            }.padding()
            GeometryReader { gr in
                ZStack {
                    sun()
                    venus()
                    earth()
                    Segment(p0: CGPoint(x: 0.0, y: 0.0), p1: (position(t: time, a: orbitalRadiusEarth))).stroke()
                    Segment(p0: CGPoint(x: 0.0, y: 0.0), p1: (position(t: time, a: orbitalRadiusVenus))).stroke()
                }.transformEffect(CGAffineTransform(translationX: 0.5 * gr.size.width, y: 0.5 * gr.size.height))
            }.onReceive(timer) { x in
                time += 0.02
            }
            HStack {
                Text("Inner planet semi-major axis: \(orbitalRadiusVenus, specifier: "%.2f")")
                Slider(value: $orbitalRadiusVenus)
            }
            .monospacedDigit()
            .padding()
        }
    }

    func sun() -> some View {
        return Circle()
            .fill(.orange)
            .frame(width: 50, height: 50)
            .position(x: 0.0, y: 0.0)
    }

    func venus() -> some View {
        return Circle()
            .fill(.white)
            .frame(width: 8, height: 8)
            .position(position(t: time, a: orbitalRadiusVenus))
    }

    func earth() -> some View {
        return Circle()
            .fill(.blue)
            .frame(width: 10, height: 10)
            .position(position(t: time, a: orbitalRadiusEarth))
    }

    func position(t: CGFloat, a: CGFloat) -> CGPoint {
        let t = time
        let w = pow(a, -1.5)
        return CGPoint(x: 300 * a * cos(w * t), y: 300 * a * sin(w * t))
    }
}
