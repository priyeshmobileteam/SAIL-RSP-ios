//
//  QMSViewController.swift
//  IGHCare
//
//  Created by HICDAC on 18/09/24.
//

import UIKit

class QMSViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, QmsTableViewCellDelegate, URLSessionDelegate {
     
    struct Counter: Decodable {
            let GBLNUM_MODULE_ID: String
            let GBLSTR_IP_ADDR: String
            let GBLSTR_COUNTER_NAME: String
            let GDT_EFFECTIVE_FRM: String
            let GDT_LSTMOD_DATE: String
            let GNUM_LSTMOD_SEATID: String
            let GNUM_SEATID: String
            let GDT_ENTRY_DATE: String
            let GNUM_ISVALID: String
            let NUM_BLOCK_ID: String
            let NUM_FLOOR_ID: String
            let GBLNUM_COUNTER_ID: String
            let GNUM_HOSPITAL_CODE: String
            let GBLSTR_LOCATION: String
            let GSTR_SERVICE_MODULE_NAME: String
            let GSTR_GENDER_CODE: String
            let GNUM_ORS_PRS_COUNTER: String
            let GSTR_DEPT_CODE: String
            let GSTR_PATIENT_CAT_CODE: String
            let GSTR_SPECIAL_COUNTER: String
            let GSTR_FAMILY_COUNTER: String

        }
        
        struct CounterResponse: Decodable {
            let status: String
            let data: [Counter]
        }
    // Outlets for the two UITableViews
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    var arrServiceType=[ServiceTypeModel]()
    var arrTokenList=[TokenListModel]()

    // Data for the two tables


    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the delegate and dataSource for both tables
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.rowHeight = UITableView.automaticDimension
        tableView2.estimatedRowHeight = 340

        // Optionally, set table view tags to differentiate if necessary
        tableView1.tag = 100
        tableView2.tag = 200
        getServiceType()
        getPatientwiseTokenlist()
        
    }

    func found(code: String) {
        print(code)
        
        if code.lowercased().range(of:"key") != nil {
            print("exists")
            
            let json =  JSON(parseJSON:code)
            var tokenQty = "1"

            let key=json["key"].stringValue;
            let arKey=key.components(separatedBy: "$")
            let counterId=arKey[0]
            let hospCode = counterId.substring(toIndex: 5)
//            let serviceId = counterId.substring(fromIndex: 5).substring(toIndex: 7)
            let serviceId="63"
            let isGender=arKey[1]
            let isSeniorCitizen = arKey[2];
            let isFamily:String=arKey[3];
            if(!(isFamily=="0"))
            {
                tokenQty = "4";
            }
            print("counterId : \(counterId) hospCode: \(hospCode) serviceId: \(serviceId) isGender: \(isGender) isSeniorCitizen: \(isSeniorCitizen) isFamily: \(isFamily)")
            
            let obj = UserDefaults.standard.retrieve(object: PatientDetails.self, fromKey: "patientDetails")
           
            let crno=obj!.crno
            let url:String = ServiceUrl.ip + "HQMS/services/restful/QmsServiceMobile/generateToken?crno=" + crno + "&hospCode=" + hospCode + "&counterId=" + counterId + "&serviceId=" + serviceId + "&isGender=" + isGender + "&isFamily=" + isFamily + "&isSeniorCtz=" + isSeniorCitizen + "&familyCount=" + tokenQty
print(url)
            callStampingService(data: url)
        }else{
            showAlert(title: "Invalid QR Code.", message: "Please scan a valid QR code.");
        }
        
    }

    
    
    func callStampingService(data:String)
    {
        let url = URL(string: data)
       
        var request = URLRequest(url: url!)
      //  request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        
       
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        
    urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do{
                let json = try JSON(data:data)
                
                print("data \(data)")
                let status = json["status"].stringValue
                print("status :::: \(status)")
                
                if status=="1"
                {
                    let message=json["data"][0]["MSG"].stringValue
                    DispatchQueue.main.async {
                    self.showAlert(title:"Token Generation", message: message);
                    }
                }
                else{
                    //let stringData=String(data: data, encoding: String.Encoding.utf8) as String?
                   // let json = JSON.init(parseJSON: stringData!)
                    DispatchQueue.main.async {
                        let message = "Sorry! unable to generate token.";

                    self.showAlert(title:"Token Generation", message:  message);
                    }
                    
                }
               
                
                
            }catch{
                print("error"+error.localizedDescription)
                DispatchQueue.main.async {
                    let message = "Sorry! unable to generate token.";

                self.showAlert(title:"Token Generation", message:  message);
                }
            }
            }.resume()
    }
    func showAlert(title:String,message:String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler:{ (action: UIAlertAction!) in
                //                print("Handle Ok logic here")
                self.navigationController?.popToRootViewController(animated: true)
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        
    }
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100 {
            return arrServiceType.count
        } else if tableView.tag == 200 {
            return arrTokenList.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as!QmsTableViewCell
            // Set the delegate
            cell.delegate = self
            cell.serviceTypeBtn.setTitle(arrServiceType[indexPath.row].moduleName, for: .normal)

            return cell
        } else if tableView.tag == 200 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! TokenListTableViewCell
            //rounded border
            cell.que_no_lbl.layer.masksToBounds = true
            cell.que_no_lbl.layer.cornerRadius = 5
            cell.que_no_lbl.layer.borderWidth = 1
            cell.que_no_lbl.layer.borderColor = UIColor.black.cgColor
            
            cell.name_lbl.text = arrTokenList[indexPath.row].COUNTER_NAME
            cell.que_no_title.text = "Token No."
            cell.que_no_lbl.text = arrTokenList[indexPath.row].TOKEN_NO
            cell.name_lbl.text = arrTokenList[indexPath.row].COUNTER_NAME
            cell.hosp_name_lbl.text = arrTokenList[indexPath.row].HOSP_NAME
            cell.status_lbl.text = arrTokenList[indexPath.row].TOKEN_STATUS
            
            if(arrTokenList[indexPath.row].TOKEN_STATUS == "Waiting"){
                cell.status_lbl.textColor = UIColor.red
            }else if(arrTokenList[indexPath.row].TOKEN_STATUS == "Attended"){
                cell.status_lbl.textColor = UIColor.green
            }else if(arrTokenList[indexPath.row].TOKEN_STATUS == "Stand By"){
                cell.status_lbl.textColor = UIColor.black
                cell.status_lbl.backgroundColor = UIColor.systemYellow
            }
            return cell
        }
        return UITableViewCell()
    }

    // UITableViewDelegate Methods (optional)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 100 {
            print("Selected \(arrServiceType[indexPath.row]) from Table 1")
        } else if tableView.tag == 200 {
            print("Selected \(arrTokenList[indexPath.row]) from Table 2")
        }
    }
    // Delegate method: Handle the image tap
    func didTapImage(in cell: QmsTableViewCell, modeval: Int) {
        if(modeval == 1){
            // Fetch data dynamically from the API
            fetchCounterDetails()
        }else{
            // Now you can access navigationController and perform navigation
            if let indexPath = tableView1.indexPath(for: cell) {
                print("Image tapped at row \(indexPath.row)")
                let vc = (UIStoryboard.init(name: "Main2", bundle: Bundle.main).instantiateViewController(withIdentifier: "TokenGenerationViewController") as? TokenGenerationViewController)!
                vc.view.backgroundColor = .white
    //            self.navigationController!.pushViewController( vc, animated: true)
                self.present(vc, animated: true, completion: nil)
        }
       }
    }
    
        func fetchCounterDetails() {
            // API URL
            let urlString = "https://hmissail.uat.dcservices.in/HQMS/services/restful/QmsServiceMobile/getCounterDtls?hosp_code=21101&moduleId=63"
            
            guard let url = URL(string: urlString) else { return }

            // Create a URLSession data task to fetch the data
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Failed to fetch data: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }

                do {
                    // Decode the JSON response
                    let counterResponse = try JSONDecoder().decode(CounterResponse.self, from: data)
                    
                    // Update UI on main thread
                    DispatchQueue.main.async {
                        self.showCounterListPopUp(counters: counterResponse.data)
                    }
                    
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }.resume()  // Start the task
        }

        // Function to show dynamic pop-up with counter names and IDs
        func showCounterListPopUp(counters: [Counter]) {
            let alertController = UIAlertController(title: "Select Counter", message: "Choose a counter from the list", preferredStyle: .alert)
            
            // Add actions for each counter
            for counter in counters {
                let action = UIAlertAction(title: "\(counter.GBLSTR_COUNTER_NAME) - \(counter.GBLNUM_COUNTER_ID)", style: .default) { _ in
                    print("Selected: \(counter.GBLSTR_COUNTER_NAME) with ID: \(counter.GBLNUM_COUNTER_ID)")
                }
                alertController.addAction(action)
            }
            
            // Option to cancel
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // Present the alert controller
            present(alertController, animated: true, completion: nil)
        }
    func showCounterListPopUp() {
          // Create an alert controller
          let alertController = UIAlertController(title: "Select Counter", message: "Choose a counter from the list", preferredStyle: .alert)
          
          // List of counters with IDs
          let counters = [("Counter 1", "01"), ("Counter 2", "02"), ("Counter 3", "03"), ("Counter 4", "04")]
          
          // Add actions for each counter name and ID
          for (counterName, counterID) in counters {
              let action = UIAlertAction(title: "\(counterName) - \(counterID)", style: .default) { _ in
                  print("Selected: \(counterName) with ID: \(counterID)")
              }
              alertController.addAction(action)
          }
          
          // Option to cancel
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          alertController.addAction(cancelAction)
          
          // Present the alert controller
          present(alertController, animated: true, completion: nil)
      }
    func getServiceType(){
        DispatchQueue.main.async {
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        }
        let obj = UserDefaults.standard.retrieve(object: PatientDetails.self, fromKey: "patientDetails")
        let strUrl = "https://hmissail.uat.dcservices.in/HQMS/services/restful/QmsServiceMobile/getServiceType"
//        let strUrl = "\(ServiceUrl.getGuarantorDtl)\(obj!.hospCode)&empId=\(obj!.umidNo.prefix(6))"
        let url = URL(string: strUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                let json = try JSON(data:data)
                print(json)
        
            let status = json["status"].stringValue
                if (status == "1"){
                    
                let jarr=json["data"]
                    print("json- \(jarr)")
                    if jarr.count==0
                    {
                        self.alert(title: "No Record Found!", message: "No Service Type found for the selected patient.")
                    }else{
                    for arr in jarr.arrayValue{
                        self.arrServiceType.append(ServiceTypeModel(json: arr))
                   }
                }
                }
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                    self.tableView1.reloadData()
                }
                
            }catch{
                print("error:: "+error.localizedDescription)
            }
            }.resume()
    }
    
   
    func getPatientwiseTokenlist(){
        DispatchQueue.main.async {
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        }
        let obj = UserDefaults.standard.retrieve(object: PatientDetails.self, fromKey: "patientDetails")
        let strUrl = "https://hmissail.uat.dcservices.in/HQMS/services/restful/QmsServiceMobile/getPatientwiseTokenlist?crno=221012400004091"
    
//        let strUrl = "\(ServiceUrl.getGuarantorDtl)\(obj!.hospCode)&empId=\(obj!.umidNo.prefix(6))"
        let url = URL(string: strUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                let json = try JSON(data:data)
                print(json)
        
            let status = json["status"].stringValue
                if (status == "1"){
                    
                let jarr=json["data"]
                    print("json- \(jarr)")
                    if jarr.count==0
                    {
//                        self.alert(title: "No Record Found!", message: "No Token List found for the selected patient.")
                    }else{
                    for arr in jarr.arrayValue{
                        self.arrTokenList.append(TokenListModel(json: arr))
                   }
                }
                }
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                    self.tableView2.reloadData()
                }
                
            }catch{
                print("error:: "+error.localizedDescription)
            }
            }.resume()
    }
    
    
    func getCounterDtls(){
        DispatchQueue.main.async {
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        }
        let obj = UserDefaults.standard.retrieve(object: PatientDetails.self, fromKey: "patientDetails")
        let strUrl = "https://hmissail.uat.dcservices.in/HQMS/services/restful/QmsServiceMobile/getCounterDtls?hosp_code=21101&moduleId=63"
    
//        let strUrl = "\(ServiceUrl.getGuarantorDtl)\(obj!.hospCode)&empId=\(obj!.umidNo.prefix(6))"
        let url = URL(string: strUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                let json = try JSON(data:data)
                print(json)
        
            let status = json["status"].stringValue
                if (status == "1"){
                    
                let jarr=json["data"]
                    print("json- \(jarr)")
                    if jarr.count==0
                    {
                        self.alert(title: "No Record Found!", message: "Counter List not found!")
                    }else{
                    for arr in jarr.arrayValue{
                        self.arrTokenList.append(TokenListModel(json: arr))
                   }
                }
                }
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                    self.tableView2.reloadData()
                }
                
            }catch{
                print("error:: "+error.localizedDescription)
            }
            }.resume()
    }
   
    func alert(title:String,message:String)
    {
        DispatchQueue.main.async {
           
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler:{ (action: UIAlertAction!) in
            //                print("Handle Ok logic here")
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
            
        }
    }
}
	
