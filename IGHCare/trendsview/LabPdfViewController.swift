//
//  LabPdfViewController.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 23/02/24.
//

import UIKit
import WebKit

class LabPdfViewController: UIViewController, WKUIDelegate  {
    
    var arrData=TrackerModel()
    var webView: WKWebView!
    var pdfString = ""
    override func loadView() {
        super.loadView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share(sender:)))
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonParsing()
    }
    
    @objc func share(sender:UIView){
        do {
            try savePdf()
            loadPDFAndShare()
        } catch  {
            print("failed to save pdf")
        }
    }
    
    func savePdf() throws {
        let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let pdfDocURL = documentsURL.appendingPathComponent("document.pdf")
        let pdfData = Data(base64Encoded: pdfString)
        try pdfData!.write(to: pdfDocURL)
    }
    
    func loadPDFAndShare(){
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let pdfDocURL = documentsURL.appendingPathComponent("document.pdf")
            
            let document = NSData(contentsOf: pdfDocURL)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [document!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView=self.view
            present(activityViewController, animated: true, completion: nil)
        } catch  {
            print("document was not found")
        }
    }
    
    
    func jsonParsing(){
        DispatchQueue.main.async {
            
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        }
        let crno:String;
        if UserDefaults.standard.object(forKey: "udCrno") != nil  {
            crno=(UserDefaults.standard.object(forKey: "udCrno") as! String)
        }else{
            let obj = UserDefaults.standard.retrieve(object: PatientDetails.self, fromKey: "patientDetails")
            crno=obj!.crno
        }
        let url = URL(string: ServiceUrl.viewPdf+crno+"&reqDNo=\(arrData.hivtnumReqDno)&hosCode="+arrData.hospitalCode)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                }
                let json = try JSON(data:data)
                for arr in json.arrayValue{
                    let baseData = arr["PDFDATA"].stringValue
                    if let decodeData = NSData(base64Encoded: baseData, options: .ignoreUnknownCharacters) {
                        DispatchQueue.main.async {
                            self.webView.load(decodeData as Data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: NSURL(fileURLWithPath: "") as URL)
                        }
                        self.pdfString = baseData
                    }
                }
            }catch{
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                }
                print("Sudeep"+error.localizedDescription)
            }
        }.resume()
    }
}




