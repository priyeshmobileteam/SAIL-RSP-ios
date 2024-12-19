//
//  SmartReportMainViewController.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 15/02/24.
//

import UIKit
import SwiftUI

class SmartReportMainViewController: UIViewController {
    @IBOutlet weak var tab_stack: UIStackView!
    @IBOutlet weak var tab_lbl1: UILabel!
    @IBOutlet weak var tab_lbl2: UILabel!
    
    @IBOutlet weak var smartReportView: UIView!
    @IBOutlet weak var TrackDownloadReportView: UIView!
    ///Smart report start
    @IBOutlet weak var sampleWiseTableView: UITableView!
    var arrDataSampleWise=[SampleWiseModel]()
    ///Smart report end
    ///Track start
    @IBOutlet weak var ReportListTableView: UITableView!
    var crno=""
    var hospCode=""
    var arrData=[TrackerModel]()
    ///Track end
    
    @IBOutlet var lblNoReportsFound: UILabel!
    var obj:PatientDetails!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "udCrno") != nil  {
            self.crno=(UserDefaults.standard.object(forKey: "udCrno") as! String)
            self.hospCode=(UserDefaults.standard.object(forKey: "udHospCode") as! String)
        }else{
            obj = UserDefaults.standard.retrieve(object: PatientDetails.self, fromKey: "patientDetails")
            self.crno=obj!.crno
            self.hospCode=obj!.hospCode
        }
        
        tab_stack.translatesAutoresizingMaskIntoConstraints = false
        tab_stack.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        tab_stack.isLayoutMarginsRelativeArrangement = true
        tab_stack.spacing = 2
        
        tab_lbl1.isUserInteractionEnabled = true
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(smartReportTapped))
        tab_lbl1.addGestureRecognizer(tapGesture1)
        
        tab_lbl2.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(trackDownloadTapped))
        tab_lbl2.addGestureRecognizer(tapGesture2)
        
        // Remove separator insets
        sampleWiseTableView.separatorInset = UIEdgeInsets.zero
        sampleWiseTableView.layoutMargins = UIEdgeInsets.zero
        
        ReportListTableView.separatorInset = UIEdgeInsets.zero
        ReportListTableView.layoutMargins = UIEdgeInsets.zero
        
        
        smartReportdefault()
    }
    
    @objc func smartReportTapped() {
        smartReportdefault()
        print("smartReportdefault:")
    }
    @objc func trackDownloadTapped() {
        trackDownload()
        print("trackDownloadTapped:")
    }
    
    func smartReportdefault(){
        smartReportView.isHidden = false
        TrackDownloadReportView.isHidden = true
        
        tab_lbl1.clipsToBounds = true
        tab_lbl1.backgroundColor = UIColor.blue
        tab_lbl1.textColor = UIColor.white
        tab_lbl1.layer.cornerRadius = 16
        tab_lbl1.layer.borderWidth = 1
        
        tab_lbl2.layer.cornerRadius = 0
        tab_lbl2.layer.borderWidth = 0
        tab_lbl2.backgroundColor = UIColor.white
        tab_lbl2.textColor = UIColor.blue
        smartReportJson()
    }
    func trackDownload(){
        smartReportView.isHidden = true
        TrackDownloadReportView.isHidden = false
        
        tab_lbl2.clipsToBounds = true
        tab_lbl2.backgroundColor = UIColor.blue
        tab_lbl2.textColor = UIColor.white
        tab_lbl2.layer.cornerRadius = 16
        tab_lbl2.layer.borderWidth = 1
        
        tab_lbl1.layer.cornerRadius = 0
        tab_lbl1.layer.borderWidth = 0
        tab_lbl1.backgroundColor = UIColor.white
        tab_lbl1.textColor = UIColor.blue
        openTrackDownload()
    }
    func openTrackDownload(){
        ReportListTableView.rowHeight = UITableView.automaticDimension
        ReportListTableView.estimatedRowHeight = 44
        trackDownladJson()
    }
    func smartReportJson(){
        self.arrDataSampleWise.removeAll()
        DispatchQueue.main.async {
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        }
        let strUrl = "\(ServiceUrl.sampleWiseDataList)\(crno)&hosCode=\(hospCode)"
        let url = URL(string: strUrl)
        print("url "+strUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                let json = try JSON(data:data)
                if json.count == 0
                {
                    DispatchQueue.main.async {
                        self.sampleWiseTableView.backgroundView=self.lblNoReportsFound
                        self.sampleWiseTableView.separatorStyle = .none
                        self.sampleWiseTableView.reloadData()
                    }
                }
                else{
                    for arr in json.arrayValue{
                        self.arrDataSampleWise.append(SampleWiseModel(json: arr))
                    }
                    DispatchQueue.main.async {
                        self.sampleWiseTableView.backgroundView=nil
                        self.sampleWiseTableView.separatorStyle = .singleLine
                        self.sampleWiseTableView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                }
            }catch{
                print("Sudeep"+error.localizedDescription)
            }
        }.resume()
    }
    
    func trackDownladJson(){
        self.arrData.removeAll()
        DispatchQueue.main.async {
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        }
        let strUrl = "\(ServiceUrl.investigationTracker)\(hospCode)&crno=\(crno)"
        let url = URL(string: strUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                var json = try JSON(data:data)
                //  print(url)
                json=json["INVESTIGATION_DETAILS"]
                print(json)
                if json.count == 0
                {
                    DispatchQueue.main.async {
                        self.ReportListTableView.backgroundView=self.lblNoReportsFound
                        self.ReportListTableView.separatorStyle = .none
                        self.ReportListTableView.reloadData()
                    }
                }
                else{
                    for arr in json.arrayValue{
                        self.arrData.append(TrackerModel(json: arr))
                    }
                    DispatchQueue.main.async {
                        self.ReportListTableView.backgroundView=nil
                        self.ReportListTableView.separatorStyle = .singleLine
                        self.ReportListTableView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                }
            }catch{
                print("Sudeep"+error.localizedDescription)
            }
        }.resume()
    }
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.previousFailureCount == 0 else {
            challenge.sender?.cancel(challenge)
            // Inform the user that the user name and password are incorrect
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Within your authentication handler delegate method, you should check to see if the challenge protection space has an authentication type of NSURLAuthenticationMethodServerTrust
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
            // and if so, obtain the serverTrust information from that protection space.
            && challenge.protectionSpace.serverTrust != nil
            && challenge.protectionSpace.host == ServiceUrl.hostName {
            let proposedCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, proposedCredential)
        }
    }
    
}

extension SmartReportMainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.sampleWiseTableView {
            return arrDataSampleWise.count
        }else{
            return arrData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.sampleWiseTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrackDownloadTableViewCell
            cell.lblTestNAme.text = "Lab/Sample No: "+arrDataSampleWise[indexPath.row].sampleno
            cell.lblReqNumber.text = ""+arrDataSampleWise[indexPath.row].acceptancedatetime
            cell.lblReportDate.text = ""
            cell.accessoryType = .disclosureIndicator
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrackDownloadTableViewCell
            cell.lblTestNAme.text = arrData[indexPath.row].testName
            cell.lblReqNumber.text = "Visit Date: "+arrData[indexPath.row].reqDate
            cell.lblReportDate.text = "Status: "+arrData[indexPath.row].status
            let currentItem:TrackerModel = arrData[indexPath.row]
            if (currentItem.statusNo == "6" && currentItem.gnumSamoleCode == "-1"){
                cell.lblReportDate.text = "Status: "+"Patient Accepted"
            }else {
                cell.lblReportDate.text = "Status: "+currentItem.status
            }
            if (currentItem.statusNo == "14" || currentItem.statusNo == "26" ) {
                cell.lblReportDate.textColor  = UIColor(hex: 0x00735C)
            } else {
                cell.lblReportDate.textColor  = UIColor(hex: 0x122d4a)
            }
            cell.accessoryType = .disclosureIndicator
            cell.layoutMargins = UIEdgeInsets.zero

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.sampleWiseTableView {
            let vc = (UIStoryboard.init(name: "trendsview", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportDetailChartMainViewController") as? ReportDetailChartMainViewController)!
            vc.sampleNo=arrDataSampleWise[indexPath.row].sampleno
            vc.isSampleNoEmpty=arrDataSampleWise[indexPath.row].issamplenoempty
            self.navigationController!.pushViewController( vc, animated: true)
        }else{
            if (arrData[indexPath.row].statusNo == "14" || arrData[indexPath.row].statusNo == "26") {
                let vc = (UIStoryboard.init(name: "trendsview", bundle: Bundle.main).instantiateViewController(withIdentifier: "LabPdfViewController") as? LabPdfViewController)!
                vc.arrData=arrData[indexPath.row]
                self.navigationController!.pushViewController( vc, animated: true)
            } else {
                let vc = UIStoryboard(name: "trendsview", bundle: nil).instantiateViewController(withIdentifier: "TrackerController") as! TrackerController
                vc.arrData=[arrData[indexPath.row]]
                vc.position=indexPath.row
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
}
extension UIColor {
    convenience init(hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}


