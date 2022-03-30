//
//  ChartCell.swift
//  tfe
//
//  Created by martin d'hoedt on 3/31/22.
//
// thanks to : https://github.com/BLCKBIRDS/Bar-Chart-in-SwiftUI

import SwiftUI

struct BarChartCell: View {
    
    var value: Double
    var barColor: Color
                             
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 5)
                .fill(barColor)
                .scaleEffect(CGSize(width: 1, height: value), anchor: .bottom)
            Text(String(format: "%.2f", value))
                .font(.caption2)
                .padding(.bottom)
        }
    }
}

struct BarChartCell_Previews: PreviewProvider {
    static var previews: some View {
        BarChartCell(value: 1, barColor: .blue)
            .previewLayout(.sizeThatFits)
    }
}
