//
//  DataManager.swift
//  DatabaseLoginTest
//
//  Created by Arsen on 15.02.2023.
//

import SwiftUI
import Firebase

// класс DataManager для управления данными приложения
public class DataManager: ObservableObject {
    
    // опубликованные свойства для отслеживания изменений данных
    @Published var cartItems: [Cart] = [] // элементы корзины
    @Published var scans: [Scan] = [] // сканированные элементы
    @Published var totalprice: Double = 0.0 // общая стоимость элементов в корзине
    @Published var extraCodeValid: Bool? = nil // флаг дополнительного QR-кода
    
    // метод для получения информации о сканированных элементах из Firebase
    func fetchScans(codenumbers: String, extracode: Bool) {
        let db = Firestore.firestore() // получение экземпляра Firestore
        let ref = db.collection("Scans").document(codenumbers) // ссылка на документ в коллекции "Scans" по коду
        ref.getDocument { [self] document, error in
            guard error == nil else {
                print(error!.localizedDescription) // вывод ошибки, если она есть
                return
            }
            guard let data = document?.data() else {
                error.map { print($0.localizedDescription) } // вывод ошибки, если она есть
                return
            }
            
            // получение информации о сканированном элементе из документа Firebase
            let id = data["id"] as? String ?? ""
            guard !id.isEmpty else {
                print("Empty id")
                return
            }
            let price = data["price"] as? String ?? ""
            let information = data["information"] as? String ?? ""
            let cbzh = data["cbzh"] as? String ?? ""
            let energyprice = data["energyprice"] as? String ?? ""
            let extraqr = data["extraqr"] as? Bool ?? false
            let extraqrcode = data["extraqrcode"] as? String ?? ""
            
            // проверка наличия сканированного элемента в массиве scans
            if let existingScanIndex = scans.firstIndex(where: { $0.id == id }) {
                print("Scan already exists: \(scans[existingScanIndex])")
                return
            }
            
            // создание объекта Scan и добавление его в массив scans
            let scan = Scan(id: id, price: price, information: information, cbzh: cbzh, energyprice: energyprice, extraqr: extraqr, extraqrcode: extraqrcode)
            self.scans.append(scan)
            print(scan)
        }
    }
    
    // метод для проверки дополнительного QR-кода
    func checkExtraQRCode(_ scannedCode: String, for extraqrcode: String) {
        if scannedCode == extraqrcode {
            extraCodeValid = true
        } else {
            extraCodeValid = false
        }
    }
    
    // метод для добавления элемента в корзину
    func addToCart(scan: Scan) {
        let item = Cart(id: scan.id, price: scan.price, information: scan.information, cbzh: scan.cbzh, energyprice: scan.energyprice, extraqr: scan.extraqr, extraqrcode: scan.extraqrcode)
        self.cartItems.append(item)
        totalprice += Double(item.price) ?? 0.0
        print("total price: \(totalprice)")
    }

    // метод для удаления элемента из корзины
    func deleteFromCart(cartItem: Cart) {
        if let index = self.cartItems.firstIndex(of: cartItem) {
            totalprice -= Double(cartItem.price) ?? 0.0
            self.cartItems.remove(at: index)
        }
    }
}
