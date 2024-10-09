struct LocationMarkerView: View {
    let isArrived: Bool
    let headingDifference: CGFloat?
    
    var body: some View {
        Image(systemName: isArrived ? "mappin.circle" : "location.fill")
            .tint(isArrived ? .green : .black)
            .resizable()
            .frame(width: 100, height: 100)
            .rotationEffect(
                isArrived ? .zero : .radians((headingDifference ?? 0) + CGFloat.pi / 2)
            )
            .animation(.easeInOut(duration: 0.5), value: headingDifference ?? 0)
            .padding()
    }
}
