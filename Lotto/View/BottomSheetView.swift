import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    @Binding var dimOpacity: Double
    
    let cornerRadius: CGFloat = 16
    let indicatorHeight: CGFloat = 6
    let indicatorWidth: CGFloat = 60
    let snapRatio: CGFloat = 0.25
    let minHeightRatio: CGFloat = 0.1
    
    let maxHeight: CGFloat
    var content: Content
    
    private var minHeight: CGFloat {
        maxHeight * minHeightRatio
    }
    
    @GestureState private var translation: CGFloat = 0
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(.gray)
            .frame(
                width: indicatorWidth,
                height: indicatorHeight
            ).onTapGesture {
                self.isOpen.toggle()
                self.dimOpacity = isOpen ? 0.5 : 0
            }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator
                    .padding()
                
                self.content
            }
            .background(.white)
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .cornerRadius(cornerRadius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring(), value: offset)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * self.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                    self.dimOpacity = isOpen ? 0.5 : 0
                }.onChanged{ value in
                    let offsetWithTranslation = max(self.offset + value.translation.height, 0)
                    let fullTranslation = self.maxHeight - self.minHeight
                    let progress = (fullTranslation - offsetWithTranslation) / fullTranslation
                    
                    self.dimOpacity = min(max(progress, 0), 0.5)
                }
            )
        }
    }
}
