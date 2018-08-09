//
//  CustomViewController.h
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/29/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "Utility.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface CustomViewController : UIViewController<HomeModelProtocol,MFMailComposeViewControllerDelegate,UITextFieldDelegate,UIWebViewDelegate>
@property (nonatomic,retain) HomeModel *homeModel;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
@property (nonatomic,retain) UIView *overlayView;
@property (nonatomic,retain) UIView *waitingView;
@property (nonatomic,retain) UIImageView *addedNotiView;
@property (nonatomic,retain) UIImageView *removedNotiView;
@property (nonatomic,retain) UILabel *lblAlertMsg;
@property (nonatomic,retain) UILabel *lblWaiting;
@property (nonatomic,retain) HomeModel *homeModelPrintKitchenBill;
@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic) NSInteger receiptKitchenBill;
@property (nonatomic) BOOL newOrderComing;
@property (nonatomic) BOOL issueComing;
@property (nonatomic) BOOL processingComing;
@property (nonatomic) BOOL deliveredComing;
@property (nonatomic) BOOL clearComing;
@property (nonatomic,retain) UIToolbar *toolBar;


-(void)setCurrentVc;
-(void) blinkAddedNotiView;
-(void) blinkRemovedNotiView;
-(void) blinkAlertMsg:(NSString *)alertMsg;
-(void)loadingOverlayView;
-(void)loadWaitingView;
-(void)removeWaitingView;
-(void)removeOverlayViews;
-(void)connectionFail;
-(void)itemsFail;
-(void)itemsInserted;
-(void)itemsUpdated;
-(void)alertMsg:(NSString *)msg;
-(void) showAlert:(NSString *)title message:(NSString *)message;
-(void) showAlert:(NSString *)title message:(NSString *)message method:(SEL)method;
-(void) showAlert:(NSString *)title message:(NSString *)message firstResponder:(UIView *)view;
-(void)loadViewProcess;
-(void)setShadow:(UIView *)view;
-(void)setShadow:(UIView *)view radius:(NSInteger)radius;
-(void)setButtonDesign:(UIView *)view;
-(void)setCornerAndShadow:(UIView *)view cornerRadius:(NSInteger)cornerRadius;
-(CGSize)suggestedSizeWithFont:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode forString:(NSString *)text;
-(void)setImageAndTitleCenter:(UIButton *)button;
-(UIImage *)pdfToImage:(NSURL *)sourcePDFUrl;
-(void)exportImpl:(NSString *)reportName;
-(void)exportCsv:(NSString*) filename;
-(void)makeBottomRightRoundedCorner:(UIView *)view;
-(void)showStatus:(NSString *)status;
-(void)hideStatus;
- (void)syncItems;
-(NSString *)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;
-(BOOL)inPeriod:(NSInteger)period;
-(NSString*) deviceName;
- (id)findFirstResponder:(UIView *)view;
-(UIImage *) generateQRCodeWithString:(NSString *)string scale:(CGFloat) scale;
-(void)removeMemberData;
-(UIImage *)combineImage:(NSArray *)arrImage;
-(UIImage *)combineImage:(UIImage *)image1 image2:(UIImage *)image2;
-(UIImage *)imageFromView:(UIView *)view;
-(NSAttributedString *)setAttributedString:(NSString *)title text:(NSString *)text;
-(void)printReceiptKitchenBill:(NSMutableArray *)receiptList;
-(void)doPrintProcess:(UIImage *)image portName:(NSString *)portName;
-(void)dismissKeyboard;
@end
