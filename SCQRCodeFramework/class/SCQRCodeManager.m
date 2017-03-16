//
//  SCQRCodeManager.m
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/16.
//  Copyright © 2017年 pengweijian. All rights reserved.
//

#import "SCQRCodeManager.h"
#import "SCQRCodeGenerator.h"
#import "SCQRCodeScanner.h"
#import "SCQRCodeRecognizer.h"

@interface SCQRCodeManager ()

/** 二维码生成器 */
@property (nonatomic, strong) SCQRCodeGenerator *qrCodeGenerator;
/** 二维码识别器 */
@property (nonatomic, strong) SCQRCodeRecognizer *qrCodeRecognizer;
/** 二维码扫描器 */
@property (nonatomic, strong) SCQRCodeScanner *qrCodeScanner;

@end

static SCQRCodeManager *_instance = nil;

@implementation SCQRCodeManager
+ (instancetype)sharedManager
{
    if (_instance)return _instance;
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    return _instance;
}

- (SCQRCodeGenerator *)qrCodeGenerator
{
    if (!_qrCodeGenerator) {
        _qrCodeGenerator = [[SCQRCodeGenerator alloc] init];
    }
    return _qrCodeGenerator;
}

- (SCQRCodeRecognizer *)qrCodeRecognizer
{
    if (!_qrCodeRecognizer) {
        _qrCodeRecognizer = [[SCQRCodeRecognizer alloc] init];
    }
    return _qrCodeRecognizer;
}

- (SCQRCodeScanner *)qrCodeScanner
{
    if (!_qrCodeScanner) {
        _qrCodeScanner = [[SCQRCodeScanner alloc] initWithPreviewFrame:[UIScreen mainScreen].bounds];
    }
    return _qrCodeScanner;
}
@end
