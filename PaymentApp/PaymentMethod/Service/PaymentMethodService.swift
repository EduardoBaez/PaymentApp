import UIKit
import Alamofire

class PaymentMethodService {
    static var paymentMethods: [PaymentMethodModel]?
    static let URL = Paths.basePath+Paths.paymentMethods
    
    static func parameters() -> [String: String] {
        return ["public_key": Paths.PUBLIC_KEY]
    }
    
    static func getJson(data: Data) -> [PaymentMethodModel]? {
        do { paymentMethods = try JSONDecoder().decode([PaymentMethodModel].self, from: data) }
        catch let error { print("PaymenthMethodService error: \(error.localizedDescription)") }
        return paymentMethods?.filter({ paymentMethod -> Bool in
            // Filter payment methods by credit_card
            paymentMethod.payment_type_id == "credit_card"
        }).sorted(by: { (lhs, rhs) -> Bool in lhs.name ?? "" < rhs.name ?? "" })
    }
    
    static func getPaymentMethods(completion: @escaping ([PaymentMethodModel]?) -> Void) {
        AF.request(URL, method: .get, parameters: parameters(), encoding: URLEncoding.default).response {
            response in
            if let data = response.data {
                completion(getJson(data: data))
            }
        }
    }
    
}
