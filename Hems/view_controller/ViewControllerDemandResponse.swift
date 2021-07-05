//
//  ViewControllerDemandResponse.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/07/02.
//

import UIKit

class DrCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTimeCreated: UILabel!
    @IBOutlet weak var lblKwh: UILabel!
    @IBOutlet weak var lblTimeBeginEnd: UILabel!
    @IBOutlet weak var ivNew: UIImageView!
}

class ViewControllerDemandResponse: CustomUIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tvDr: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvDr.delegate = self
        tvDr.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "DrCell", for: indexPath) as! DrCell
        
        return Cell
    }
    

    @IBAction func btnMain(_ sender: UIButton) {
        print("main button clicked...")
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    


}
