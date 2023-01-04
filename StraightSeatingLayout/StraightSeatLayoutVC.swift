//
//  StraightSeatLayoutVC.swift
//  StraightSeatingLayout
//
//  Created by Ankush on 30/12/22.
//

import UIKit
protocol DataProtocol {
    
    func passSeatsData(seatsArr: [[String:String?]])
}


class StraightSeatLayoutVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet private weak var scrollView: UIScrollView!
    var delegate: DataProtocol?
    private var stageVw : UIImageView = UIImageView()
    private var layoutMainVw: UIView = UIView()
    var stageNameStr = ""
    
    var rowCount: Int = 5
    var columnCount: Int = 15
    
    var seatArr: [ROW] = []
    var ticketTypeArr: [SECTION] = []
    var buttonX = CGFloat(30)
    var buttonY = CGFloat(60)
    
    private var pickedSeatsArr : [[String:String?]] = []
    var totalSeatsCount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getData()
        self.createBgVw()
        self.setupZoom()
    }
    
    private func getData() {
        if let path = Bundle.main.path(forResource: "straightSeatLayout", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let dictOuterResponse = jsonResult as? [String: AnyObject] {
                    // do stuff
                    if let array = dictOuterResponse[ConstantKeys.SECTION]  as? [AnyObject] {
                        
                        let obj = RESPONSE(jsonArr: array)
                        print(obj)
                        self.ticketTypeArr = obj.sections ?? []
                        self.seatArr = obj.sections?.first?.rows ?? []
                    }
                   
                }
            } catch {
                // handle error
            }
        }
    }
    
    private func setupZoom() {
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = LayoutConstants.minimumZoomScale
        self.scrollView.maximumZoomScale = LayoutConstants.maximumZoomScale
        self.scrollView.setZoomScale(LayoutConstants.minimumZoomScale, animated: true)
        self.scrollView.zoomScale = LayoutConstants.minimumZoomScale

        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTapGest)
    }
}

extension StraightSeatLayoutVC {

    private func createBgVw() {

        let mainViewX = LayoutConstants.screenSize.width*2
        let mainViewY = LayoutConstants.screenSize.height*2

        self.scrollView.backgroundColor = LayoutColors.mainViewColor
        self.layoutMainVw = UIView(frame: CGRect(x: 0, y: 0, width: mainViewX, height: mainViewY))
        self.layoutMainVw.backgroundColor = LayoutColors.mainViewColor
        //Adding stage in center
        
        let imageViewX = (mainViewX)/2 - LayoutConstants.stageWidth/2
        let imageViewY = LayoutConstants.centerStageHeight - 44
        
        self.stageVw = UIImageView(frame: CGRect(x: imageViewX, y: imageViewY, width: LayoutConstants.stageWidth, height: LayoutConstants.centerStageHeight))
        self.stageVw.contentMode = .scaleAspectFill
        self.stageVw.clipsToBounds = true
        self.stageVw.backgroundColor = .red
        
        
        self.layoutMainVw.addSubview(self.stageVw)
        let label = UILabel(frame: CGRect(x: self.stageVw.center.x - 100 , y: self.stageVw.center.y - 10, width: 200, height: 21))

        label.font = UIFont(name: LayoutFonts.fontNameStr, size: 25.0)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Movie Screen"
        self.layoutMainVw.addSubview(label)
        self.addSeats()
        self.scrollView.addSubview(self.layoutMainVw)
    }

    func addSeats() {

        for i in 0...(self.ticketTypeArr.count)-1 {
            self.buttonX = CGFloat(30)
            self.buttonY += CGFloat(i * 50)
            let label = UILabel(frame: CGRect(x: self.buttonX, y: buttonY, width: 200, height: 21))

            label.font = UIFont(name: LayoutFonts.fontNameStr, size: 20.0)
            label.textColor = .black
            label.textAlignment = .center
            label.text = self.ticketTypeArr[i].title
            self.layoutMainVw.addSubview(label)
            
            self.addSectionAndSeats(innerSectionArr: self.ticketTypeArr[i].rows ?? [])
            buttonY += CGFloat(40)
        }
    }

    func addSectionAndSeats(innerSectionArr: [ROW]) {

        for i in 0...(innerSectionArr.count)-1 {
            self.buttonX = CGFloat(30)
            buttonY += CGFloat(40)
            let pointsArr = innerSectionArr[i].seats?.components(separatedBy: ",")
            for j in 0...(pointsArr?.count ?? 0) {
                self.createSeatBtns(rowIndex: j, seatsCount: 10, columnIndex: i, rowObj: pointsArr ?? [], row: innerSectionArr[i] )
            }
        }
    }

    private func createSeatBtns(rowIndex: Int, seatsCount: Int, columnIndex: Int, rowObj: [String], row: ROW) {

        
        var buttonWidth = LayoutConstants.seatButtonWidth
        let buttonHeight = LayoutConstants.seatButtonSize

        var isSeatAvailable = true

        if rowIndex != 0 {
            self.buttonX = self.buttonX + CGFloat(50)

            if let blocked = row.blocked {

                let val = blocked.contains { objInt in
                    objInt == Int(rowObj[rowIndex-1])
                }
                if val {
                    isSeatAvailable = false
                }
            }

            if rowIndex == 1 {

                self.buttonX = CGFloat(30 + (rowIndex * 50) + Int(LayoutConstants.seatButtonWidth)*2)
            }


        } else {
            isSeatAvailable = false
        }


        let frframe = CGRect(x: self.buttonX , y: buttonY , width: buttonWidth, height: buttonHeight)

        if rowIndex != 0 {
            
            if let spaceArr = row.space {
                
                for spacObj in spaceArr {
                    if spacObj.key == rowObj[rowIndex-1] {
                        self.buttonX = self.buttonX + CGFloat((Int(spacObj.value ?? 0) ?? 0) * 50)
                    }
                }
            }
        }


        let seatBtn = CustomSeatButton.init(frame: frframe)
        seatBtn.layer.borderWidth  = 1
        seatBtn.clipsToBounds      = true

        if let columnX = self.seatArr[columnIndex].title {
            seatBtn.columnIndex = columnX
        }

        if rowIndex == 0 {
            seatBtn.backgroundColor    = LayoutColors.seatRowTitleBackgroundColor
            seatBtn.layer.borderColor  = LayoutColors.seatRowTitleBorderColor
            seatBtn.setTitleColor(LayoutColors.seatRowTitleTextColor , for: .normal)
            seatBtn.setTitle(row.title, for: .normal)
            seatBtn.titleLabel!.font   = UIFont(name: LayoutFonts.fontNameStr, size: LayoutConstants.seatButtonSize/2 + 6)
        } else {
            seatBtn.rowIndex = rowObj[rowIndex-1]
            if isSeatAvailable {
                seatBtn.backgroundColor    = LayoutColors.seatUnselectedBackgroundColor
                seatBtn.layer.borderColor  = LayoutColors.seatUnselectedBorderColor
                seatBtn.setTitleColor(LayoutColors.seatUnselectedTextColor , for: .normal)
                seatBtn.setTitle("\(rowObj[rowIndex-1])", for: .normal)
                seatBtn.titleLabel!.font   = UIFont(name: LayoutFonts.fontNameStr, size: LayoutConstants.seatButtonSize/2)
            } else {
                seatBtn.backgroundColor    = LayoutColors.seatUnavailableColor
                seatBtn.layer.borderColor  = LayoutColors.seatUnselectedBorderColor
                seatBtn.setTitleColor(LayoutColors.seatUnselectedTextColor , for: .normal)
                seatBtn.setTitle("\(rowObj[rowIndex-1])", for: .normal)
                seatBtn.titleLabel!.font   = UIFont(name: LayoutFonts.fontNameStr, size: LayoutConstants.seatButtonSize/2)
            }

        }

        if isSeatAvailable {
            seatBtn.addTarget(self, action: #selector(self.seatBtnAction), for: .touchUpInside)
        }


        self.layoutMainVw.addSubview(seatBtn)
        let horizontalConstraint1    = seatBtn.centerXAnchor.constraint(equalTo: self.layoutMainVw.centerXAnchor)
        let verticalConstraint1      = seatBtn.centerYAnchor.constraint(equalTo: self.layoutMainVw.bottomAnchor)
        NSLayoutConstraint.activate([horizontalConstraint1, verticalConstraint1])
    }

    @objc func seatBtnAction(mybutton: CustomSeatButton) {

        var tempSelectedArr : [[String: String?]] = self.pickedSeatsArr
        var skipViewAll = 1
        if self.pickedSeatsArr.count == self.totalSeatsCount{

            for obj in self.pickedSeatsArr {
                if let columnS = mybutton.columnIndex {
                    if let rowS = mybutton.rowIndex {

                        if obj[ConstantKeys.ROW] == rowS && obj[ConstantKeys.COLUMN] == columnS {

                            tempSelectedArr.removeAll { newobj in
                                columnS == newobj[ConstantKeys.COLUMN] && rowS == newobj[ConstantKeys.ROW]

                            }
                            skipViewAll = 2

                            //Clear button color
                            let viewsN = self.layoutMainVw.subviews
                            for view in viewsN {

                                //Clearing all seats colors
                                if let btn : CustomSeatButton = view as? CustomSeatButton {

                                    if btn.rowIndex == rowS && btn.columnIndex == columnS {
                                        btn.backgroundColor = LayoutColors.seatUnselectedBackgroundColor
                                    }
                                }
                            }

                            break
                        }
                    }
                }
            }



            if skipViewAll == 2 {
                self.pickedSeatsArr = tempSelectedArr
            } else if skipViewAll == 1 {
                //Clear button color
                let views = self.layoutMainVw.subviews
                for view in views {

                    //Clearing all seats colors
                    if let btn : CustomSeatButton = view as? CustomSeatButton {

                        for obj in self.pickedSeatsArr {
                            if let columnS = obj[ConstantKeys.COLUMN] {
                                if let rowS = obj[ConstantKeys.ROW] {

                                    if btn.rowIndex == rowS && btn.columnIndex == columnS {
                                        btn.backgroundColor = LayoutColors.seatUnselectedBackgroundColor
                                    }
                                }
                            }
                        }
                    }
                }

                //Clearing all seats
                tempSelectedArr = []
                self.pickedSeatsArr = []

                if let columnS = mybutton.columnIndex {
                    if let rowS = mybutton.rowIndex {
                        self.pickedSeatsArr.append([ConstantKeys.COLUMN: columnS, ConstantKeys.ROW: rowS])
                    } else {
                        self.pickedSeatsArr.append([ConstantKeys.COLUMN: columnS, ConstantKeys.ROW: nil])
                    }
                }
                mybutton.backgroundColor = LayoutColors.seatSelectedBackgroundColor
            }


        } else {

            //Clear button color
            let views = self.layoutMainVw.subviews
            for view in views {

                //Clearing all seats colors
                if let btn : CustomSeatButton = view as? CustomSeatButton {

                    if let columnS = mybutton.columnIndex {
                        if let rowS = mybutton.rowIndex {

                            if btn.rowIndex == rowS && btn.columnIndex == columnS {
                                btn.backgroundColor = LayoutColors.seatUnselectedBackgroundColor
                                tempSelectedArr.removeAll { newobj in
                                    columnS == newobj[ConstantKeys.COLUMN] && rowS == newobj[ConstantKeys.ROW]
                                }

                            }
                        }
                    }
                }
            }

            if tempSelectedArr.count < self.pickedSeatsArr.count {
                self.pickedSeatsArr = tempSelectedArr
            } else {
                if let columnS = mybutton.columnIndex {
                    if let rowS = mybutton.rowIndex {
                        self.pickedSeatsArr.append([ConstantKeys.COLUMN: columnS, ConstantKeys.ROW: rowS])
                    } else {
                        self.pickedSeatsArr.append([ConstantKeys.COLUMN: columnS, ConstantKeys.ROW: nil])
                    }
                }
                mybutton.backgroundColor = LayoutColors.seatSelectedBackgroundColor
            }
        }
    }
}

//MARK: - Scroll View Gesture and functions

extension StraightSeatLayoutVC {

    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if self.scrollView.zoomScale >= 1 {
            self.scrollView.zoom(to: zoomRectForScale(scale: LayoutConstants.minimumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            self.scrollView.setZoomScale(LayoutConstants.doubleTapZoomScale, animated: true)
        }
    }

    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = self.layoutMainVw.frame.size.height / scale
        zoomRect.size.width  = self.layoutMainVw.frame.size.width  / scale
        let newCenter = self.layoutMainVw.convert(center, from: self.scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        return self.layoutMainVw
    }

}
