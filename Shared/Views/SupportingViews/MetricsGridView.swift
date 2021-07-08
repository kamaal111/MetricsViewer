//
//  MetricsGridView.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 08/07/2021.
//

import SwiftUI

public struct MetricsGridView<Content: MetricsGridCellRenderable, GridItemView: View>: View {
    public let headerTitles: [String]
    public let data: [[Content]]
    public let viewWidth: CGFloat
    public let gridItem: (_ content: Content) -> GridItemView

    public init(
        headerTitles: [String],
        data: [[Content]],
        viewWidth: CGFloat,
        gridItem: @escaping (_ content: Content) -> GridItemView
    ) {
        self.headerTitles = headerTitles
        self.data = data
        self.viewWidth = viewWidth
        self.gridItem = gridItem
    }

    public var body: some View {
        LazyVGrid(
            columns: columns,
            alignment: .center,
            spacing: 0,
            pinnedViews: [.sectionHeaders]) {
            Section(header: GridHeaderView(viewWidth: viewWidth, headerTitles: headerTitles)) {
                ForEach(data, id: \.self) { (row: [Content]) in
                    ForEach(row, id: \.renderID) { (item: Content) in
                        gridItem(item)
                    }
                }
            }
        }
    }

    private var columns: [GridItem] {
        headerTitles.map { _ in
            GridItem(.flexible())
        }
    }
}

#if DEBUG
private struct MetricsGridRenderItem: MetricsGridCellRenderable {
    let id: UUID
    let content: String
}

@available(macOS 11.0, iOS 14.0, *)
struct MetricsGridView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsGridView(
            headerTitles: ["Title"],
            data: [[MetricsGridRenderItem(id: UUID(), content: "Content")]],
            viewWidth: 300) { content in
            Text(content.content)
        }
    }
}
#endif
