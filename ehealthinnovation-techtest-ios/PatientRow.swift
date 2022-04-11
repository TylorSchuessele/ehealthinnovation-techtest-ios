//
//  PatientRow.swift
//  ehealthinnovation-techtest-ios
//
//  Created by Tylor Schuessele on 2022-04-11.
//

import SwiftUI

struct PatientRow: View {
    @State private var isExpanded: Bool = false
    
    
    func expand() {
        withAnimation { isExpanded.toggle() }
    }
    func formattedDate(date: Date) -> String {
        
        let currentDate = Date()
        if (date > currentDate) {
          return ("unknown")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return (dateFormatter.string(from: date))
    }
    var patient: Patient
    var body: some View {
        VStack(alignment: .leading)  {
            HStack {
                //Patient Icon
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                    .foregroundColor(Color(red: 0.8, green: 0.9, blue: 0.9))
                
                Text(patient.name) .font(Font.custom("Title", size: 25)) .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                
                Spacer()
                
                // Different Buttons based on isExpanded
                Button(action: expand) {
                    if isExpanded {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                            .foregroundColor(Color(red: 0.8, green: 0.9, blue: 0.9))
                    }
                    else {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                            .foregroundColor(Color(red: 0.8, green: 0.9, blue: 0.9))
                    }
                }
            }
            .padding(20)
            
            // Expandable Area
            if isExpanded {
                VStack(alignment: .leading)  {
                    HStack {
                        Text("Family Name") .font(Font.custom("Title", size: 20))
                        Spacer()
                        Text(patient.familyName) .font(Font.custom("Title", size: 20)) .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    }
                    HStack {
                        Text("Gender") .font(Font.custom("Title", size: 20))
                        Spacer()
                        Text(patient.gender) .font(Font.custom("Title", size: 20)) .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    }
                    HStack() {
                        Text("Birthday").font(Font.custom("Title", size: 20))
                        Spacer()
                        Text(formattedDate(date:patient.birthday))
                            .font(Font.custom("Title", size: 20))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    }
                    
                }
                .padding(20)
            }
        }
    }
}
