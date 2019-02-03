//
//  PrinterSetting.h
//  ObjectiveC SDK
//
//  Copyright (c) 2018 Star Micronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StarIO_Extension/StarIoExt.h>

#import "ModelCapability.h"

typedef NS_ENUM(NSInteger, PaperSizeIndex) {
    PaperSizeIndexNone = 0,
    PaperSizeIndexTwoInch = 384,
    PaperSizeIndexThreeInch = 576,
    PaperSizeIndexFourInch = 832,
    PaperSizeIndexEscPosThreeInch = 512,
    PaperSizeIndexDotImpactThreeInch = 210
};


@interface PrinterSetting : NSObject<NSCoding>

- (nullable instancetype)initWithPortName:(nonnull NSString *)portName
                             portSettings:(nonnull NSString *)portSettings
                                modelName:(nonnull NSString *)modelName
                               macAddress:(nonnull NSString *)macAddress
                               printerBrand:(nonnull NSString *)printerBrand
                                emulation:(StarIoExtEmulation)emulation
                 cashDrawerOpenActiveHigh:(BOOL)cashDrawerOpenActiveHigh
                      allReceiptsSettings:(NSInteger)allReceiptsSettings
                        selectedPaperSize:(NSInteger)selectedPaperSize
                       selectedModelIndex:(NSInteger)selectedModelIndex;

@property (nonatomic) NSString *printerBrand; //1=star,2=epson,3=gprinter

@property (nonatomic) NSString *portName;

@property (nonatomic) NSString *portSettings;

@property (nonatomic) NSString *modelName;

@property (nonatomic) NSString *macAddress;

@property (nonatomic) StarIoExtEmulation emulation;

@property (nonatomic) BOOL cashDrawerOpenActiveHigh;

@property (nonatomic) NSInteger allReceiptsSettings;

@property (nonatomic) PaperSizeIndex selectedPaperSize;

@property (nonatomic) ModelIndex selectedModelIndex;

- (BOOL)isNull;

@end


@interface NullPrinterSetting: PrinterSetting

- (instancetype)initWithPortName:(NSString *)portName
                    portSettings:(NSString *)portSettings
                       modelName:(NSString *)modelName
                      macAddress:(NSString *)macAddress
                       emulation:(StarIoExtEmulation)emulation
        cashDrawerOpenActiveHigh:(BOOL)cashDrawerOpenActiveHigh
             allReceiptsSettings:(NSInteger)allReceiptsSettings
               selectedPaperSize:(NSInteger)selectedPaperSize
              selectedModelIndex:(NSInteger)selectedModelIndex __unavailable;

@end
