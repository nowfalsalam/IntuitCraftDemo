//
//  chart.swift
//  IntuitCraftDemo
//
//  Created by Nowal E Salam on 27/01/20.
//

import SwiftUI

public struct ChartView : View {
    @ObservedObject var viewModel : ChartViewModel
    @State var pct: Double = 0.25
    
    public init(viewModel : ChartViewModel){
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack (){
                ArcView(pct: self.viewModel.pct, viewModel: self.viewModel, width: geometry.size.width * 0.6).frame(width : geometry.size.width * 0.6, height: geometry.size.width * 0.6)
                Text("\(self.viewModel.pct)")
                Button(action: {
                    self.viewModel.index += 1
                    self.reload()
                })
                {
                    Text("Select currency\(self.viewModel.pct)").foregroundColor(.green)
                }
                Spacer()
                .frame(height: 50)
                AnalysisView(viewModel: self.viewModel)
            }
        }
        .onAppear() {
            self.reload()
        }
    }
    
    private func reload() {
        self.viewModel.pct = 0.25
        withAnimation(.easeInOut(duration: 1.0)) {
            self.viewModel.pct = self.viewModel.scores[self.viewModel.index] + 0.25
        }
    }
}

struct ArcView : View {
    @State private var pct: Double = 0.25
    @ObservedObject private var viewModel : ChartViewModel
    private var width : CGFloat = 0.0
    private var sX : CGFloat = 0.0
    private var sY : CGFloat = 0.0
    private var eX : CGFloat = 0.0
    private var eY : CGFloat = 0.0
    
    init(pct : Double, viewModel : ChartViewModel, width : CGFloat) {
        self.width = width
        sX = width/2 + width/2 * cos(90 * 3.14 / 180)
        sY = width/2 + width/2 * sin(90 * 3.14 / 180)
        eX = width/2 + width/2 * cos(360 * 3.14 / 180)
        eY = width/2 + width/2 * sin(360 * 3.14 / 180)
        self.viewModel = viewModel
        self.pct = pct
    }
    
    var body: some View {
        ZStack {
            Path { path in
                
                path.addArc(center: CGPoint(x: self.width/2, y: self.width/2),
                            radius: self.width/2,
                            startAngle: Angle(degrees: 90),
                            endAngle: Angle(degrees: 360),
                            clockwise: false)
            }
            .stroke(Color(#colorLiteral(red: 0.9567790627, green: 0.9569165111, blue: 0.9567491412, alpha: 1)), lineWidth: 10)
            
            InnerArc(start: 90, pct: self.viewModel.pct).stroke(Color(#colorLiteral(red: 0.8142015338, green: 0.3005843461, blue: 0.2015683353, alpha: 1)), lineWidth: 10).onTapGesture {
                print("arc tapped")
            }
            Text("820").font(.title)
            Text("10")
                .frame(width: 50, height: 50, alignment: .leading)
                .position(CGPoint(x: sX, y: sY))
                .padding(EdgeInsets.init(top: 0, leading: 30, bottom: 0, trailing: 0))
            Text("10")
                .font(.body)
                .frame(width: 50, height: 50, alignment: .top)
                .position(CGPoint(x: eX, y: eY))
                .padding(EdgeInsets.init(top: 30, leading: 0, bottom: 0, trailing: 0))
        }
    }
    
}

struct InnerArc : Shape {
    var lagAmmount = 0.35
    var pct: Double = 0.25
    var start: Double = 90

    init(start : Double, pct : Double){
        self.start = start
        self.pct = pct
    }
    
    func path(in rect: CGRect) -> Path {
        
        let end = start + pct * 360 - 90
        var p = Path()
        
        p.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2),
                 radius: rect.size.width/2,
                 startAngle: Angle(degrees: start),
                 endAngle: Angle(degrees: end),
                 clockwise: false)
        return p
    }
    
    var animatableData: Double {
        get { return pct }
        set { pct = newValue }
    }
}

