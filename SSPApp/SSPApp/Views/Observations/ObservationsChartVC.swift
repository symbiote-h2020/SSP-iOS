//
//  ObservationsChartVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 24/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit
import Charts

class ObservationsChartVC: UIViewController {
 
    @IBOutlet var chartView: LineChartView!
    var obsMam: ObservationsManager = ObservationsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Debug test
        if obsMam.currentObservations.count == 0 {
            obsMam.getTestData()
        }
        
        updateData()
    }
    

    func setObservations(_ om: ObservationsManager) {
        self.obsMam = om
    }
    
    //MARK - storybord management
    static func getViewController() -> ObservationsChartVC {
        let storyboard = UIStoryboard(name: "Observations", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ObservationsChartVC")
        return controller as! ObservationsChartVC
    }
    
    static func getNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Observations", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ObservationsChartNavigationVC")
        return controller as! UINavigationController
    }

    
    
    
    func updateData() {
        
        // labels and items
        var labels: [String] = []
        var items: [ChartDataEntry] = []
        
        
        let ithKey = Array(obsMam.observationsByName.keys)[0]
        if let valuesArr = obsMam.observationsByName[ithKey] {
            
            // fill items
            var index: Double = 0
            for obs in valuesArr {
                
                // label
                let dateString = obs.time.localizedTime()
                labels.append(dateString)
                
                let entry = ChartDataEntry(x: index, y: obs.values[0].valueDouble)
                items.append(entry)
                index += 1.0
            }
            
            // value formatter
            let nf = NumberFormatter()
            nf.minimumIntegerDigits = 1
            nf.minimumFractionDigits = 1
            nf.maximumFractionDigits = 1
            nf.decimalSeparator = "."
            
            // chart data
            let dataSet = LineChartDataSet(values: items, label: "Data")
            dataSet.drawValuesEnabled = true
            dataSet.valueFormatter = DefaultValueFormatter(formatter: nf)
            //dataSet.setColor(WFIColors.windSpeedChart)
            dataSet.drawCircleHoleEnabled = false
            //dataSet.setCircleColor(WFIColors.windSpeedChart)
            dataSet.circleRadius = 4.0
            dataSet.lineWidth = 2.0
            
            let data = LineChartData(dataSet: dataSet)
            
            
            chartView.data = data
            chartView.notifyDataSetChanged()
            chartView.setNeedsDisplay()
            
            // configure axis
            let xAxis = chartView.xAxis
            xAxis.labelPosition = .bottom
            xAxis.drawGridLinesEnabled = false
            xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
            xAxis.labelCount = labels.count
            xAxis.labelRotationAngle = -90.0
            xAxis.granularity = 1.0
            
            
            // this must be last
            chartView.centerViewTo(xValue: 0, yValue: 0, axis: .left)
           // chartView.setVisibleXRange(minXRange: 7, maxXRange: 7)
            
        }
        
        /*  //with lots of view manipulation
            
            // configure axis
            let xAxis = chartView.xAxis
            xAxis.labelPosition = .bottom
            xAxis.drawGridLinesEnabled = false
            xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
            xAxis.labelCount = labels.count
            xAxis.labelRotationAngle = -90.0
            xAxis.granularity = 1.0
            
            let yAxis = chartView.leftAxis
            yAxis.drawAxisLineEnabled = true
            yAxis.drawGridLinesEnabled = true
            yAxis.granularityEnabled = true
            
    //        let line = ChartLimitLine(limit: 5.0)
    //        //line.lineColor = WFIColors.windLineColor
    //        yAxis.addLimitLine(line)
            
            chartView.rightAxis.enabled = false
            
    //chartView.extraBottomOffset = 10.0
            
            let legend = chartView.legend
            legend.form = .line
            legend.horizontalAlignment = .center
            legend.verticalAlignment = .top
            legend.orientation = .vertical
            legend.drawInside = false
            legend.formSize = 30.0
            
            // configure chart
    //        chartView.chartDescription?.enabled = false
    //        chartView.legend.enabled = false
    //        chartView.drawGridBackgroundEnabled = false
    //        chartView.pinchZoomEnabled = false
    //        chartView.doubleTapToZoomEnabled = false
    //        chartView.scaleXEnabled = false
    //        chartView.scaleYEnabled = false
    //        
    //        chartView.highlightPerTapEnabled = false
    //        chartView.highlightPerDragEnabled = false
            
            chartView.isHidden = false
            chartView.data = data
            chartView.notifyDataSetChanged()
            chartView.setNeedsDisplay()
            
            // this must be last
            chartView.centerViewTo(xValue: 0, yValue: 0, axis: .left)
            chartView.setVisibleXRange(minXRange: 7, maxXRange: 7)
        }
 */
    }

}
