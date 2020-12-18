//
//  MenuView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/11.
//

import SwiftUI

struct DayBlock: View{
    @EnvironmentObject var dayRouter: DayRouter
    let day: Int
    @Binding var showMenu: Bool

    
    var body: some View{
        Button(action: {
            self.dayRouter.dayIndex = day - 1
            self.showMenu = false
        }) {
            Text("Day \(day)")
                .font(.system(size: 22, weight: .regular))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 16)
                .padding()
                .background(Color(UIColor.tertiarySystemBackground))
                .foregroundColor(Color(UIColor.systemIndigo))
                .opacity(0.8)
                .cornerRadius(50)
        }
    }
}

struct MenuButton: View {
    let text: String
    var body: some View{
        HStack (spacing: 20){
            Text("\(text)")
                .font(.system(size: 22, weight: .regular))
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 16)
        .padding()
        .foregroundColor(.white)
        .background(Color(red: 43/255, green: 185/255, blue: 222/255))
        .cornerRadius(50)
    }
}

struct AddDayButton: View {
    @EnvironmentObject var dayRouter: DayRouter
    @State var error = false
    let planId: String
    let destinations: [[Destination]]
    @Binding var showMenu: Bool

    var body: some View {
        Button(action: {
            self.addDay()
            self.dayRouter.dayIndex = self.destinations.count
            self.showMenu = false
        }) {
            HStack (spacing: 20){
                Text("Add a day")
                    .font(.system(size: 22, weight: .regular))
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 16)
            .padding()
            .foregroundColor(.gray)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.gray, lineWidth: 3)
            )
        }
    }
    func addDay() {
        API().addDay(planId: self.planId) { result in
            
            switch result {
            case .success:
                break
            case .failure:
                self.error = true
            }
        }
    }
}

struct MenuView: View {
    @EnvironmentObject var dayRouter: DayRouter
    @EnvironmentObject var userData: UserData
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var error = false
    let planId: String
    let users : [String]
    let destinations: [[Destination]]
    @Binding var showMenu: Bool
    @Binding var planIndex: Int
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // User icon
                ForEach(0..<users.count / 4 + 1) { i in
                    HStack{
                        ForEach(users[i*4..<min((i+1)*4, users.count)], id: \.self){ name in
                            utils().getUserImage(usernickname: name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color(UIColor.systemIndigo))
                                .clipShape(Circle())
                        }
                    }
                }
                // Invite people
                NavigationLink(destination: InviteView(planId: self.planId)) {
                    Text("Invite people")
                        .font(.system(size: 24, weight: .regular))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 24)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(UIColor.systemIndigo))
                        .cornerRadius(50)
                }
                // Days
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(destinations.indices, id: \.self){ d in
                            DayBlock(day: d+1, showMenu: $showMenu)
                        }
                    }
                }
                VStack (spacing: 12){
                    // Add a day
                    AddDayButton(
                        planId: planId,
                        destinations: destinations,
                        showMenu: $showMenu
                    )
                    
                    Menu ("switch to other plan"){
                        ForEach(userData.currentUser.plans, id: \.self) { planId in
                            Button(action: {
                                self.planIndex = userData.currentUser.plans.firstIndex(of: planId)!
                                self.showMenu = false
                            }) {
                                Text("\(planId)")
                            }
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 16)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(red: 43/255, green: 185/255, blue: 222/255))
                    .cornerRadius(50)
                    NavigationLink(destination: NewPlanView(showMenu: $showMenu, planIndex: $planIndex)) {
                        MenuButton(text: "create a new plan")
                    }
                }
                Spacer()
            }
            .padding(.top, 80)
            .padding(.horizontal, 48)
            .background(Color(UIColor.secondarySystemBackground).ignoresSafeArea())
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
    func addDay() {
        API().addDay(planId: self.planId) { result in
            
            switch result {
            case .success:
                break
            case .failure:
                self.error = true
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    struct PreviewWrapper: View {
        @State var showMenu = true
        @State var dayIndex = 0
        @State var planIndex = 0

        var body: some View{
            MenuView(planId:"", users: ["Candy", "Bob", "Alice"], destinations: [[], []], showMenu: $showMenu, planIndex: $planIndex)
        }
    }
}
