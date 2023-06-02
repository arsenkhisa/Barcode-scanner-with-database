//
//  Scan.swift
//  DatabaseLoginTest
//
//  Created by Arsen on 15.02.2023.
//

import SwiftUI

// структура Scan для представления сканированного элемента
struct Scan: Identifiable, Equatable {
    var id: String // идентификатор сканированного элемента
    var price: String // цена сканированного элемента
    var information: String // информация о сканированном элементе
    var cbzh: String // БЖУ (белки, жиры, углеводы) сканированного элемента
    var energyprice: String // энергетическая ценность сканированного элемента
    var extraqr: Bool // флаг наличия дополнительного QR-кода для сканированного элемента
    var extraqrcode: String // дополнительный QR-код сканированного элемента
}

// структура Cart для представления элемента корзины
struct Cart: Identifiable, Equatable {
    var index = UUID() // уникальный идентификатор элемента корзины
    var id: String // идентификатор элемента корзины
    var price: String // цена элемента корзины
    var information: String // информация об элементе корзины
    var cbzh: String // БЖУ (белки, жиры, углеводы) элемента корзины
    var energyprice: String // энергетическая ценность элемента корзины
    var extraqr: Bool // флаг наличия дополнительного QR-кода для элемента корзины
    var extraqrcode: String // дополнительный QR-код элемента корзины
}
