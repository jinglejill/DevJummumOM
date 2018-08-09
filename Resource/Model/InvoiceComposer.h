//
//  InvoiceComposer.h
//  testPdf
//
//  Created by Thidaporn Kijkamjai on 1/25/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoiceComposer : NSObject
@property (retain, nonatomic) NSString * senderInfo;
@property (retain, nonatomic) NSString * dueDate;
@property (retain, nonatomic) NSString * paymentMethod;


@property (retain, nonatomic) NSString * logoImageURL;
@property (retain, nonatomic) NSString * invoiceNumber;
@property (retain, nonatomic) NSString * pdfFilename;

@property (retain, nonatomic) NSString * pathToInvoiceHtml;
@property (retain, nonatomic) NSString * pathToAbbrInvoiceHtml;
@property (retain, nonatomic) NSString * pathToBillHtml;
@property (retain, nonatomic) NSString * pathToCancelOrderBillHtml;
@property (retain, nonatomic) NSString * pathToItemsHtml;
@property (retain, nonatomic) NSString * pathToItemsTotalHtml;
@property (retain, nonatomic) NSString * pathToKitchenItemsHtml;

@property (retain, nonatomic) NSString * pathToDeliveryAddressHtml;
@property (retain, nonatomic) NSString * pathToPayByCashHtml;
@property (retain, nonatomic) NSString * pathToPayByCreditCardHtml;
@property (retain, nonatomic) NSString * pathToPayByTransferHtml;
@property (retain, nonatomic) NSString * pathToKitchenBillHtml;
@property (retain, nonatomic) NSString * pathToEndDayHtml;
@property (retain, nonatomic) NSString * pathToEndDayCustomerTypeHtml;
@property (retain, nonatomic) NSString * pathToEndDayCustomerTypeFooterHtml;
@property (retain, nonatomic) NSString * pathToEndDayCustomerTypeSummaryHtml;
@property (retain, nonatomic) NSString * pathToEndDayMenuTypeHtml;
@property (retain, nonatomic) NSString * pathToEndDaySubMenuTypeHtml;
@property (retain, nonatomic) NSString * pathToEndDayPaymentMethodHtml;



- (id)init;
- (NSString *)renderInvoiceWithCompanyName:(NSString *)companyName companyAddress:(NSString *)companyAddress phoneNo:(NSString *)phoneNo taxID:(NSString *)taxID customerName:(NSString *)customerName customerAddress:(NSString *)customerAddress customerPhoneNo:(NSString *)customerPhoneNo customerTaxID:(NSString *)customerTaxID customerType:(NSString *)customerType cashierName:(NSString *)cashierName receiptNo:(NSString *)receiptNo receiptTime:(NSString *)receiptTime totalQuantity:(NSString *)totalQuantity subTotalAmount:(NSString *)subTotalAmount discountAmount:(NSString *)discountAmount afterDiscountAmount:(NSString *)afterDiscountAmount serviceChargeAmount:(NSString *)serviceChargeAmount vatAmount:(NSString *)vatAmount roundingAmount:(NSString *)roundingAmount totalAmount:(NSString *)totalAmount cashReceive:(NSString *)cashReceive cashChanges:(NSString *)cashChanges creditCardType:(NSString *)creditCardType last4Digits:(NSString *)last4Digits creditCardAmount:(NSString *)creditCardAmount transferDate:(NSString *)transferDate transferAmount:(NSString *)transferAmount memberCode:(NSString *)memberCode totalPoint:(NSString *)totalPoint thankYou:(NSString *)thankYou items:(NSMutableArray *)items;
- (NSString *)renderInvoiceWithRestaurantName:(NSString *)restaurantName phoneNo:(NSString *)phoneNo customerType:(NSString *)customerType cashierName:(NSString *)cashierName receiptNo:(NSString *)receiptNo receiptTime:(NSString *)receiptTime totalQuantity:(NSString *)totalQuantity subTotalAmount:(NSString *)subTotalAmount discountAmount:(NSString *)discountAmount afterDiscountAmount:(NSString *)afterDiscountAmount serviceChargeAmount:(NSString *)serviceChargeAmount vatAmount:(NSString *)vatAmount roundingAmount:(NSString *)roundingAmount totalAmount:(NSString *)totalAmount cashReceive:(NSString *)cashReceive cashChanges:(NSString *)cashChanges creditCardType:(NSString *)creditCardType last4Digits:(NSString *)last4Digits creditCardAmount:(NSString *)creditCardAmount transferDate:(NSString *)transferDate transferAmount:(NSString *)transferAmount memberCode:(NSString *)memberCode totalPoint:(NSString *)totalPoint thankYou:(NSString *)thankYou items:(NSMutableArray *)items nameAndPhoneNo:(NSString *)nameAndPhoneNo address:(NSString *)address;
- (NSString *)renderBillWithRestaurantName:(NSString *)restaurantName phoneNo:(NSString *)phoneNo customerType:(NSString *)customerType cashierName:(NSString *)cashierName receiptNo:(NSString *)receiptNo receiptTime:(NSString *)receiptTime totalQuantity:(NSString *)totalQuantity subTotalAmount:(NSString *)subTotalAmount discountAmount:(NSString *)discountAmount afterDiscountAmount:(NSString *)afterDiscountAmount serviceChargeAmount:(NSString *)serviceChargeAmount vatAmount:(NSString *)vatAmount roundingAmount:(NSString *)roundingAmount totalAmount:(NSString *)totalAmount memberCode:(NSString *)memberCode totalPoint:(NSString *)totalPoint thankYou:(NSString *)thankYou items:(NSMutableArray *)items nameAndPhoneNo:(NSString *)nameAndPhoneNo address:(NSString *)address;
- (NSString *)renderCancelOrderBillWithRestaurantName:(NSString *)restaurantName customerType:(NSString *)customerType managerName:(NSString *)managerName cancelTime:(NSString *)cancelTime items:(NSMutableArray *)items;
- (NSString *)renderKitchenBillWithRestaurantName:(NSString *)restaurantName customerType:(NSString *)customerType waiterName:(NSString *)waiterName menuType:(NSString *)menuType sequenceNo:(NSString *)sequenceNo sendToKitchenTime:(NSString *)sendToKitchenTime totalQuantity:(NSString *)totalQuantity items:(NSMutableArray *)items;;
//- (NSString *)renderReportEndDayWithRestaurantName:(NSString *)restaurantName endDayDate:(NSString *)endDayDate reportEndDayList:(NSMutableArray *)reportEndDayList salesAndDiscountList:(NSMutableArray *)salesAndDiscountList countReceiptAndServingPersonList:(NSMutableArray *)countReceiptAndServingPersonList cashAmountList:(NSMutableArray *)cashAmountList creditCardAmountList:(NSMutableArray *)creditCardAmountList;
@end
