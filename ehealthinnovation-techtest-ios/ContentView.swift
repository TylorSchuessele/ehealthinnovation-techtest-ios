//
//  ContentView.swift
//  ehealthinnovation-techtest-ios
//
//  Created by Tylor Schuessele on 2022-04-09.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var network: Network
    
    
    init() {
      let coloredAppearance = UINavigationBarAppearance()

      coloredAppearance.backgroundColor = .systemGreen
      coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
      coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
      UINavigationBar.appearance().standardAppearance = coloredAppearance
      UINavigationBar.appearance().compactAppearance = coloredAppearance
      UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
      UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some View {

        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(network.patients) { patient in
                        HStack(alignment:.top) {
                            PatientRow(patient: patient)
                        }
                        Divider()
                        .frame(width: UIScreen.main.bounds.width * 0.95, alignment: .leading)
                        
                        .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)))
                        .cornerRadius(20)
                    }
                }
            }
            .onAppear {
                network.getPatients()
            }
            .navigationTitle("Patients")
        }
        .alert(isPresented: $network.showError) {
            Alert(title: Text("Error"), message: Text("There was an issue loading the patient records!"), dismissButton: .default(Text("OK")))
            
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(Network())
        
    }
}
