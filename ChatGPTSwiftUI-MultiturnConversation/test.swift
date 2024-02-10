import SwiftUI

struct test: View {
    var body: some View {
        var circle  = Circle()
        circle = circle.strokeBorder()
        let capsule = Capsule()
        let combinedShape = capsule.union(circle)
        let circle2 = Circle().offset(x: 50, y: 50) // Offset to distinguish from the first circle

//        let combinedShape = circle1.union(rectangle).union(circle2)

        return Text("Hello, World!")
            .padding()
            .background {
                combinedShape
                    .stroke(Color.accentColor, lineWidth: 4)
            }
                
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
