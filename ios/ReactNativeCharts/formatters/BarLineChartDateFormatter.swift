//
//  ChartDateFormatter.swift
//  Charts
//
//  Created by lewie9021 on 2019/01/19.
//

import Foundation
import Charts

open class BarLineChartDateFormatter: NSObject, IValueFormatter, IAxisValueFormatter {
    open var chart: BarLineChartViewBase;
    open var timeUnit: String;
    
    public init(chart: BarLineChartViewBase, timeUnit: String) {
        self.chart = chart;
        self.timeUnit = timeUnit;
    }
    
    open func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return format(value)
    }
    
    open func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return format(value)
    }
    
    fileprivate func convertValueToMilliseconds(_ value: Double, _ timeUnit: String) -> Double {
        switch timeUnit {
        case "MILLISECONDS":
            return value / 1000.0
        case "SECONDS":
            return value;
        case "MINUTES":
            return value * 60
        case "HOURS":
            return value * 60 * 60
        case "DAYS":
            return value * 60 * 60 * 24
        default:
            return value / 1000.0
        }
    }
    
    fileprivate func getFormattedDate(_ date: Date, _ format: String) -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = format;
        
        return dateFormatter.string(from: date);
    }
    
    fileprivate func format(_ value: Double) -> String {
        let valueInMilliseconds = convertValueToMilliseconds(value, self.timeUnit);
        let date = Date(timeIntervalSince1970: valueInMilliseconds);
        let second = 1000.0;
        let minute = second * 60.0;
        let hour = minute * 60.0;
        let day = hour * 24.0;
        let month = day * 30.0;
        
        let chartXAxis = self.chart.xAxis;
        let yearText = String(getFormattedDate(date, "yyyy").suffix(2));
        let monthText = getFormattedDate(date, "MMM");
        
        if (chart.visibleXRange > month * 6.0) {
            chartXAxis.labelCount = 5;
            chartXAxis.axisMaxLabels = 5;
            
            return monthText + " '" + yearText;
        } else {
            chartXAxis.labelCount = 3;
            chartXAxis.axisMaxLabels = 3;
            
            let dayText = getFormattedDate(date, "d");
            
            return dayText + " " + monthText + " '" + yearText;
        }
    }
    
}
