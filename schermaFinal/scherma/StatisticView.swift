import SwiftUI

struct StatisticView: View {
    
    @Binding var suffered: Int
    @Binding var made: Int
    @Binding var resultB: String
    @Environment(\.presentationMode) var presentationMode2
    
    var body: some View {
        let fightpage = FightPage()
        NavigationView{
            VStack(alignment: .center) {
                Text(" \(resultB)")
                    .font(.custom("PoetsenOne-Regular", size: 40))
                    .padding(.top, -250)
                    .foregroundColor(Color(hex: 0x080851))
                    .background(Color.white)
                    .padding( )
                
                Text("attacks made: \(made)")
                    .font(.custom("PoetsenOne-Regular", size: 40))
                    .padding(.top, -250)
                    .foregroundColor(Color(hex: 0x080851))
                    .background(Color.white)
                    .padding( )
                
                
                
                Text("suffered: \(suffered)")
                    .font(.custom("PoetsenOne-Regular", size: 40))
                    .padding(.top, -220)
                    .foregroundColor(Color(hex: 0x080851))
                    .background(Color.white)
                    .padding( )
                
                
                
                Button(action: {
                    self.presentationMode2.wrappedValue.dismiss()
                   
                }) {
                    Text("EXIT")
                        .font(.custom("PoetsenOne-Regular", size: 30))
                        .foregroundStyle(Color(hex: 0x080851))
                        .background(
                            RoundedRectangle(cornerRadius: 1)
                                .stroke(Color(hex: 0x080851), lineWidth: 4)
                                .padding(-10))
                    
                    
                }
                
                
            }  .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: 0xd4dcff))
                .ignoresSafeArea()
            
           
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Statistics")
                        .font(.custom("PoetsenOne-Regular", size: 30))
                        .navigationBarTitleDisplayMode(.inline)
                        .foregroundStyle(Color(hex: 0x080851))
                    
                }
                
                
            }
//            .padding()
//            .navigationTitle("Statistic")
//            .navigationBarTitleDisplayMode(.inline)
        }
    }
        
}
#Preview {
    StatisticView(suffered: .constant(0), made: .constant(0), resultB: .constant(""))
}
