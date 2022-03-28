//
//  LineChart.swift
//  fix
//
//  Created by martin d'hoedt on 3/28/22.
//

import SwiftUI

struct LineChart: View {
    var dataPoints: [Double]

    var highestPoint: Double {
        let max = dataPoints.max() ?? 1.0
        if max == 0 { return 1.0 }
        return max
    }

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width

            Path { path in
                path.move(to: CGPoint(x: 0, y: height * CGFloat(self.ratio(for: 0))))

                for index in 1..<dataPoints.count {
                    path.addLine(to: CGPoint(
                        x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                        y: height * CGFloat(self.ratio(for: index)))
                    )
                }
            }
            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
        }
        .padding(.vertical)
        .frame(height: 200)
        .padding(4)
        .background(Color.gray.opacity(0.1).cornerRadius(16))
        .padding()
    }

    private func ratio(for index: Int) -> Double {
        dataPoints[index] / highestPoint
    }
}

struct LineChart_Previews: PreviewProvider {
    static var dataPoints: [Double] = [10, 2, 7, 16, 32, 39, 5, 3, 25, 21]
    static var previews: some View {
        LineChart(dataPoints: dataPoints)
    }
}
