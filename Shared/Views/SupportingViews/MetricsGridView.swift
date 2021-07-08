//
//  MetricsGridView.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 08/07/2021.
//

import SwiftUI

// - TODO: Put this in a seperate file
public protocol MetricsGridCellRenderable: Hashable, Identifiable {
    var content: String { get }
    var id: UUID { get }
}

extension MetricsGridCellRenderable {
    var renderID: String {
        "\(content)-\(id)"
    }
}

public struct MetricsGridView<Content: MetricsGridCellRenderable>: View {
    public let headerTitles: [String]
    public let data: [[Content]]
    public let viewWidth: CGFloat
    public let isPressable: Bool
    public let onCellPress: (_ content: Content) -> Void

    public init(
        headerTitles: [String],
        data: [[Content]],
        viewWidth: CGFloat,
        isPressable: Bool,
        onCellPress: @escaping (_ content: Content) -> Void = { _ in }) {
        self.headerTitles = headerTitles
        self.data = data
        self.viewWidth = viewWidth
        self.isPressable = isPressable
        self.onCellPress = onCellPress
    }

    public var body: some View {
        LazyVGrid(
            columns: columns,
            alignment: .center,
            spacing: 0,
            pinnedViews: [.sectionHeaders]) {
            Section(header: GridHeaderView(viewWidth: viewWidth, headerTitles: headerTitles)) {
                ForEach(data, id: \.self) { row in
                    ForEach(row, id: \.renderID) { item in
                        MetricsGridItem(
                            data: item,
                            horizontalPadding: 0,
                            isPressable: isPressable,
                            action: { onCellPress(item) })
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

private struct MetricsGridItem<Content: MetricsGridCellRenderable>: View {
    @Environment(\.colorScheme)
    private var colorScheme

    let data: Content
    let horizontalPadding: CGFloat
    let isPressable: Bool
    let action: () -> Void

    init(data: Content, horizontalPadding: CGFloat = 16, isPressable: Bool, action: @escaping () -> Void) {
        self.data = data
        self.horizontalPadding = horizontalPadding
        self.isPressable = isPressable
        self.action = action
    }

    var body: some View {
        ZStack {
            if isPressable {
                Button(action: action) {
                    Text(data.content)
                        .foregroundColor(.accentColor)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(backgroundColor)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Text(data.content)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, horizontalPadding)
    }

    private var backgroundColor: Color {
        switch colorScheme {
        case .dark: return .black
        case .light: return .white
        @unknown default: return .black
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
            headerTitles: [],
            data: [] as [[MetricsGridRenderItem]],
            viewWidth: 360,
            isPressable: false,
            onCellPress: { _ in })
    }
}
#endif
