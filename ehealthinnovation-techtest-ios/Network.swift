//
//  Network.swift
//  ehealthinnovation-techtest-ios
//
//  Created by Tylor Schuessele on 2022-04-09.
//
import SwiftUI
import SwiftyJSON

class Network: ObservableObject {
    @Published var patients: [Patient] = []
    @Published var showError = false
    
    // Tester Patients
    func getTestPatients() -> [Patient] {
        var testPatients = [Patient]()
        
        // Special Characters
        testPatients.append(Patient(id: 34589576, name: "&^&*()(*&^/", familyName: "$#@!&^&*()(*&^/", gender: "&^&*()(*&^/", birthday: Date()))
        // Long Name / Fields
        testPatients.append(Patient(id: 34589577, name: "aaqwertyuiopasdfghjklzxcvbnm", familyName: "aaqwertyuiopasdfghjklzxcvbnmqwertyuio", gender: "aaqwertyuiopasdfghjklzxcvbnmqwertyuio", birthday: Date()))
        return (testPatients)
    }
    
    func getPatients() {
        guard let url = URL(string: "http://hapi.fhir.org/baseDstu3/Patient?_pretty=true") else { fatalError("Missing URL") }
        
        // test wrong url
        // guard let url = URL(string: "http://hapiii.fhir.org/baseDstu3/Patient?_pretty=true") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                self.showError = true
                return
            }
            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        // Converts data to JSON Object
                        let jsonData = try JSON(data: data)
                        // Singling out patients
                        let patientsData = jsonData["entry"]

                        var decodedPatients = [Patient]()
                        var namelessUsers = [Patient]()
                        // Format for patient birthdays
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        // Tomorrows date as placeholder for birthdates that are not specified
                        // View should account for this
                        let currentDate = Date()
                        let futureDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!)
                        
                        // Uncomment for sample test cases
                        // decodedPatients = self.getTestPatients()
                        
                        // Loop Through All Patients
                        for p in 0...patientsData.count-1 {
                            
                            var patient = Patient(
                                id: p,
                                name: (patientsData[p]["resource"]["name"][0]["given"][0].string ?? "").trimmingCharacters(in: .whitespacesAndNewlines),
                                familyName: (patientsData[p]["resource"]["name"][0]["family"].string ?? "unknown").trimmingCharacters(in: .whitespacesAndNewlines),
                                gender: patientsData[p]["resource"]["gender"].string ?? "unknown",
                                birthday: dateFormatter.date(from: patientsData[p]["resource"]["birthDate"].string ?? futureDate)!
                                                            
                            )
                            
                            // Puts users without name in different list to ensure they are at the bottom
                            if (patient.name == ""){
                                patient.name = "unknown"
                                namelessUsers.append(patient)
                            } else {
                                decodedPatients.append(patient)
                            }
                            
                        }
                        decodedPatients[0].birthday = dateFormatter.date(from: futureDate)!
                        self.patients =  decodedPatients.sorted { $0.name.lowercased() < $1.name.lowercased() } + namelessUsers
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }

}
