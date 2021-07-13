//
//  GraphWidget.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import SwiftUI
import MetricsLocale

struct GraphWidget: View {
    let title: String
    let data: [Double]
    let action: () -> Void

    init(title: String, data: [Double], action: @escaping () -> Void) {
        self.title = title
        self.data = data
        self.action = action
    }

    init(title: MetricsLocale.Keys, data: [Double], action: @escaping () -> Void) {
        self.init(title: title.localized, data: data, action: action)
    }

    private let viewHeight: CGFloat = 140

    var body: some View {
        Button(action: action) {
            VStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.Background)
                GeometryReader { (proxy: GeometryProxy) -> GraphWidgetGraphView in
                    GraphWidgetGraphView(data: data, viewSize: proxy.size)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: viewHeight, maxHeight: viewHeight, alignment: .topLeading)
            .background(Color.secondary)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct GraphWidgetGraphView: View {
    let data: [Double]
    let viewSize: CGSize

    var body: some View {
        HStack {
            if idealDataset.isEmpty {
                // - TODO: LOCALIZE THIS
                Text("Not enough data points to preview")
                    .foregroundColor(.Background)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ForEach(idealDataset, id: \.id) { item in
                    Capsule()
                        .frame(
                            width: barWidth,
                            height: viewSize.height * item.value)
                        .foregroundColor(.accentColor)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }

    private var idealDataset: [IdealData] {
        guard let max = data.max() else { return [] }
        let dataset = data
            .map({ $0 / max })
        let enumeratedDataset = dataset.enumerated()
        let datasetIsAllTheSame = dataset.uniques().count < 2
        return enumeratedDataset.map({
            let value: Double
            if datasetIsAllTheSame {
                value = 0.5 * Double($0.offset)
            } else {
                value = $0.element
            }
            print(viewSize.height * value)
            print(viewSize.height)
            return IdealData(id: $0.offset, value: value)
        })
    }

    private var barWidth: CGFloat {
        20
    }
}

struct IdealData: Identifiable, Hashable {
    let id: Int
    let value: Double
}

struct GraphWidget_Previews: PreviewProvider {
    static var previews: some View {
        GraphWidget(title: "Title", data: [1, 2, 3], action: { })
    }
}
