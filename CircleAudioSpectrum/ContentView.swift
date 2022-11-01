//
//  ContentView.swift
//  CircleAudioSpectrum
//
//  Created by Masaki on 2022/10/31.
//

import SwiftUI

struct CircleSpectrum: Shape {
    @State var value: CGFloat
    
    public let maxAmplitude: CGFloat
    public let widthOfButton: CGFloat
    public let binOfSpectrumBar: Int

    private let range = 360
    private let delta_theta: CGFloat = 2.0

    func createSpectrumPath(rect: CGRect) -> Path {
        let path = UIBezierPath()
        let amplitude:CGFloat = maxAmplitude * value
        let bin = binOfSpectrumBar
        
        let x0 = rect.midX
        let y0 = rect.midY

        let theta_step = CGFloat(range / bin)
        var degree:CGFloat = 0.0
        
        for index in 0..<bin {
            let degree0 = degree
            degree = CGFloat((index + 1)) * theta_step
            let degree1 = degree - delta_theta
            let theta0 = degree0 * CGFloat.pi / 180
            let theta1 = degree1 * CGFloat.pi / 180

            let random = CGFloat.random(in: 0.0...1.0)
            let L:CGFloat = amplitude * random
            let radius = widthOfButton * 0.5
            
            let p_0 = CGPoint(x: x0 + radius * cos(theta0),
                              y: y0 - radius * sin(theta0))
            let p_1 = CGPoint(x: x0 + (radius + L) * cos(theta0),
                              y: y0 - (radius + L) * sin(theta0))
            let p_2 = CGPoint(x: x0 + (radius + L) * cos(theta1),
                              y: y0 - (radius + L) * sin(theta1))
            let p_3 = CGPoint(x: x0 + radius * cos(theta1),
                              y: y0 - radius * sin(theta1))

            path.move(to: p_0)
            path.addLine(to: p_1)
            path.addLine(to: p_2)
            path.addLine(to: p_3)
        }
        
        return Path(path.cgPath)
    }
    
    func path(in rect: CGRect) -> Path {
        return createSpectrumPath(rect: rect)
    }
}

struct CircleSpectrumButton: View {
    @State var value: CGFloat = 0
    
    public let buttonWidth: CGFloat
    public let maxHeightSpectrumBar: CGFloat
    public let binOfSpectrumBar: Int

    var body: some View {
        ZStack {
            Button {
                print("tap")
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                    self.value = CGFloat.random(in: 0.5...1)
                }
            } label: {
                Image(systemName: "mic")
                    .foregroundColor(.black)
                    .font(.system(size: 24))
                    .frame(width: buttonWidth,
                           height: buttonWidth,
                           alignment: .center)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .cornerRadius(buttonWidth*0.5)
            .shadow(color: .gray, radius: 3, x: 3, y: 3)
            
            CircleSpectrum(
                value: value,
                maxAmplitude: maxHeightSpectrumBar,
                widthOfButton: buttonWidth,
                binOfSpectrumBar: binOfSpectrumBar)
            .stroke(lineWidth: 0.5)

        }
    }
}

struct ContentView: View {
    @State var value: CGFloat = 0
    
    var body: some View {
        VStack {
            CircleSpectrumButton(
                value: value,
                buttonWidth: 60,
                maxHeightSpectrumBar: 60,
                binOfSpectrumBar: 20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
