//
//  BarChart.swift
//  tfe
//
//  Created by martin d'hoedt on 3/30/22.
//
// thanks to : https://github.com/BLCKBIRDS/Bar-Chart-in-SwiftUI
// https://www.youtube.com/watch?v=MX-eGceCotQ

import SwiftUI

struct BarChart: View {
    
    let title : String
    var data: [ChartData]
    
    let minValue : Double
    let maxValue : Double
    let color : Color = Color.green
    
    private let maxHeight = UIScreen.main.bounds.height / 3
    
    init(title: String, data: [ChartData]) {
        self.title = title
        self.data = data
        self.minValue = data.min()?.value ?? 0
        self.maxValue = data.max()?.value ?? 0
    }
                             
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
//                .padding(.vertical, 40)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .bottom) {
                    ForEach(data.indices, id: \.self) { index in
                        let label = data[index].label
                        let value = data[index].value
                        let height = (value / maxValue) * Double(maxHeight) * 0.5
                        
                        Bar(value: value, label: label, height: height, color: color)
                    }
                }
                .padding(.bottom)
            }
            HStack() {
                Image(systemName: "arrowtriangle.left.fill")
                Spacer()
                Image(systemName: "arrowtriangle.right.fill")
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: maxHeight)
    }
}

private struct Bar : View {
    let value : Double
    let label : String
    let height : Double
    let color : Color
    
    var body : some View {
        VStack {
            Text("\(value.rounded(toPlaces: 3))")
                .font(.caption)
            Rectangle()
                .fill(color)
                .frame(width: 20, height: CGFloat(height))
            Text("\(label)")
                .font(.caption)
//                .rotationEffect(Angle(degrees: -30))
        }
    }
}

struct BarChart_Previews: PreviewProvider {
    static private let maxHeight = UIScreen.main.bounds.height / 4
    static var previews: some View {
        BarChart(title: "My chart", data: MockData.chartData)
            .frame(maxHeight: maxHeight)
    }
}
