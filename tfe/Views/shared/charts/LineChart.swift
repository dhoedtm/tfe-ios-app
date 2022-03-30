//
//  LineChart.swift
//  tfe
//
//  Created by martin d'hoedt on 3/30/22.
//

import SwiftUI

struct LineChart: View {
    
    let data: [Double]
    let minY : Double
    let maxY : Double
    
    let numberOfVerticalLabels = 10
    let numberOfHorizontalLabels = 10
    
    init(data: [Double]) {
        self.data = data
        minY = data.min() ?? 0
        maxY = data.max() ?? 0
    }
    
    var body: some View {
        /// Using GeometryReader in order for the chart width to be dynamic,
        /// bound to the actual content and not the device screen width
        GeometryReader { geo in
            Path { path in
                let colWidth = geo.size.width / CGFloat(data.count)
                let yRange = maxY - minY
                
                for index in data.indices {
                    let x = CGFloat(index + 1) * colWidth
                    
                    let yOffset = data[index] - minY
                    // flipping the data points (0,0 is at the top left of the screen)
                    let yPercentage = 1 - CGFloat(yOffset / yRange)
                    // placing the data point relative to the actual container dimensions
                    let y = yPercentage * geo.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    }
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(
                Color.green,
                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: Color.gray, radius: 5, x: 3, y: 3)
        }
        .background(
            VStack {
                ForEach(getLabels().dropLast(), id: \.self) { _ in
                    Divider()
                    Spacer()
                }
                Divider()
            },
            alignment: .leading
        )
        .overlay(
            VStack {
                ForEach(getLabels().dropLast(), id: \.self) { label in
                    Text(String(label))
                        .font(.caption)
                    Spacer()
                }
                Text(String(minY.rounded(toPlaces: 3)))
                    .font(.caption)
            },
            alignment: .leading
        )
        .frame(height: UIScreen.main.bounds.height / 4)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }
    
    func getLabels() -> [Double] {
        if numberOfVerticalLabels <= 2 {
            return [maxY, minY]
        }
        
        var labels : [Double] = Array(repeating: 0, count: numberOfVerticalLabels)
        let range : Double = (maxY - minY) / Double(numberOfVerticalLabels - 1)
        var offset = minY
        for index in labels.indices {
            labels[index] = offset.rounded(toPlaces: 3)
            offset += range
        }
        return labels.reversed()
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart(data: MockData.dbhList)
    }
}
