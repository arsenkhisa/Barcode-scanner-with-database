//
//  AppViewModel.swift
//  ShopScanner
//
//  Created by Arsen on 02.02.2023.
//

import AVKit
import Foundation
import SwiftUI
import VisionKit

// перечисление ScanType для указания типа сканирования (штрих-код или текст)
enum ScanType: String {
    case barcode, text
}

// перечисление DataScannerAccessStatusType для указания статуса доступа к сканеру данных
enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvailable
}

@MainActor
final class AppViewModel: ObservableObject {
    
    @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined // статус доступа к сканеру данных
    @Published var recognizedItems: [RecognizedItem] = [] { // массив распознанных элементов
        didSet { fetchLastScanned() } // вызывается при изменении массива распознанных элементов
    }
    @Published var scanType: ScanType = .barcode // тип сканирования по умолчанию - штрих-код
    @Published var textContentType: DataScannerViewController.TextContentType? // тип контента текста
    @Published var recognizesMultipleItems = true // флаг, указывающий на возможность распознавания нескольких элементов
    @ObservedObject var dataManager = DataManager() // объект DataManager для управления данными
    
    @Published var shouldShowQRScanner = false // флаг, указывающий на необходимость отображения сканера QR-кода
    @Published var isQRCodeValid = false // флаг, указывающий на валидность QR-кода
    
    var recognizedDataType: DataScannerViewController.RecognizedDataType { // тип распознаваемых данных
        scanType == .barcode ? .barcode() : .text(textContentType: textContentType)
    }
    var headerText: String { // текст заголовка
        if recognizedItems.isEmpty {
            return "Scanning \(scanType.rawValue)" // если массив распознанных элементов пуст, выводится текст "Scanning" + тип сканирования
        } else {
            return "Recognized item:" // иначе выводится текст "Recognized item:"
        }
    }
    var dataScannerViewId: Int { // идентификатор DataScannerView
        var hasher = Hasher()
        if let textContentType {
            hasher.combine(textContentType)
        }
        return hasher.finalize()
    }
    private var isScannerAvailable: Bool { // флаг доступности сканера данных
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    // метод для запроса статуса доступа к сканеру данных
    func requestDataScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAccessStatus = .cameraNotAvailable
            return
        }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
        case .restricted, .denied:
            dataScannerAccessStatus = .cameraAccessNotGranted
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            } else {
                dataScannerAccessStatus = .cameraAccessNotGranted
            }
        default: break
        }
    }
    
    // метод для получения последнего отсканированного элемента
    func fetchLastScanned() {
        guard
            let lastScanned = recognizedItems.last,
            case let .barcode(info) = lastScanned,
            let codenumbers = info.payloadStringValue
        else {
            return
        }
        for scan in dataManager.scans {
            if codenumbers == scan.extraqrcode {
                print("Коды совпадают")
                print("Совместимый код: \(codenumbers)")
                isQRCodeValid = true
                dataManager.fetchScans(codenumbers: codenumbers, extracode: isQRCodeValid)
                break
            }
        }
            
        dataManager.fetchScans(codenumbers: codenumbers, extracode: isQRCodeValid)
        print("Scanned barcode: \(codenumbers)") // выводится номер штрих-кода в консоль
    }
}
