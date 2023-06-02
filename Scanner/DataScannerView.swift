//
//  DataScannerView.swift
//  ShopScanner
//
//  Created by Arsen on 02.02.2023.
//

import Foundation
import SwiftUI
import VisionKit

// структура, представляющая наше представление сканера
struct DataScannerView: UIViewControllerRepresentable {

    // привязка к массиву распознанных элементов
    @Binding var recognizedItems: [RecognizedItem]
    // тип данных, который мы хотим распознать
    let recognizedDataType: DataScannerViewController.RecognizedDataType

    // создание контроллера представления сканера
    func makeUIViewController(context: Context) -> DataScannerViewController{
        let vc = DataScannerViewController(
            recognizedDataTypes: [recognizedDataType],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        return vc
    }
    
    // обновление контроллера представления сканера
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        try? uiViewController.startScanning() // запуск сканирования
    }

    // создание координатора для обработки делегата сканера
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedItems: $recognizedItems)
    }
    
    // остановка сканирования при разборе контроллера представления сканера
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
    
    // координатор, который реализует протокол делегата сканера данных
    class Coordinator: NSObject, DataScannerViewControllerDelegate{
        
        @Binding var recognizedItems: [RecognizedItem]
        
        init(recognizedItems: Binding<[RecognizedItem]>) {
            self._recognizedItems = recognizedItems
        }
        
        // обработка нажатия на распознанный элемент
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            print("didTapOn \(item)")
        }
        
        // добавление новых распознанных элементов
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            recognizedItems.append(contentsOf: addedItems)
            print("didAddItems \(addedItems)")
        }
        
        // удаление распознанных элементов
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            self.recognizedItems = recognizedItems.filter { item in
                removedItems.contains(where: {$0.id == item.id})
            }
            print("didRemovedItems \(removedItems)")
        }
        
        // обработка ситуации, когда сканер становится недоступным
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            print("became unavailable with error \(error.localizedDescription)")
        }
    }
}
