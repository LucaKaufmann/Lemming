import SwiftUI

struct Collapsible<Header: View, Content: View>: View {
    @State var header: () -> Header
    @State var content: () -> Content
    
    @State private var collapsed: Bool = false
    
    var body: some View {
        VStack {
            Button(
                action: { self.collapsed.toggle() },
                label: {
                    HStack {
                        self.header()
                        Spacer()
                        Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
                    }
                    .padding(.bottom, 1)
                    .contentShape(Rectangle())
                }
            )
            .buttonStyle(PlainButtonStyle())
            .frame(height: 40)

            
            VStack {
                self.content()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
            .clipped()
        }
        .animation(.easeOut)
    }
}
