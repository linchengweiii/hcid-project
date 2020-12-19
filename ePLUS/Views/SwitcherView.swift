//
//  SwitcherView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/12.
//

import SwiftUI

struct SwitcherView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var dayRouter: DayRouter
    @EnvironmentObject var userData: UserData
    
    let name: String
    let destinations: [[Destination]]
    let users: [String]
    let planId: String
    @Binding var showMenu: Bool
    @State var dayIndex: Int = 0
    @Binding var loading: Bool

    var body: some View {
//        NavigationView(){
            ZStack(alignment: .topLeading) {
                VStack {
                    switch viewRouter.currentPage {
                    case .list:
                        ListView(planId: planId, name: name, destinations: destinations, users: users)
                    case .map:
                        MapView(destinations: destinations,dayIndex:$dayRouter.dayIndex, users: users)
                    }
                }.disabled(self.showMenu ? true : false)
                VStack(alignment: .trailing, spacing: 10) {
                    HStack() {
                        Button(action: {
                            withAnimation {
                               self.showMenu.toggle()
                            }
                        }) {
                            Image(systemName: self.showMenu ? "chevron.backward.circle.fill" : "line.horizontal.3")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(UIColor.systemIndigo))
                                .imageScale(.large)
                        }
                        Spacer()
                        Button(action: {
                            viewRouter.currentPage = (viewRouter.currentPage == .map) ? .list : .map
                        }, label: {
                            (viewRouter.currentPage == .map) ? Text("LIST") : Text("Map")
                        })
                        NavigationLink(destination: AddDestinationView(planId: planId, dayIndex: dayRouter.dayIndex)) {
                            Text("+")
                        }
                    }
                    Spacer()
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            }.ignoresSafeArea(edges:.bottom)
        .navigationBarTitle("")
        .navigationBarHidden(true)
//        }
    }
}

struct SwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
            .environmentObject(ViewRouter())
            .environmentObject(DayRouter())
            .environmentObject(UserData())
    }
    struct PreviewWrapper: View {

        @State var destinations: [[Destination]] = [
            [Destination(id: "", img: "unknown_destination", name: "Test", address: "Address Test", cooridinate: Coordinate(latitude: 0.0, longitude: 0.0), comments: [], rating: 3)]
        ]
        @State var users: [String] = [
            "guest"
        ]
        @State var showMenu = false
        @State var dayIndex = 0

        var body: some View{
            SwitcherView(name: "", destinations: destinations, users: users, planId: "", showMenu: $showMenu, loading: .constant(false))
        }
    }
}
