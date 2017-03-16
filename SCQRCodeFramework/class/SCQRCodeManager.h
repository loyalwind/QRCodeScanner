//
//  SCQRCodeManager.h
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/16.
//  Copyright © 2017年 pengweijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCQRCodeScanner, SCQRCodeGenerator, SCQRCodeRecognizer;

@interface SCQRCodeManager : NSObject

/** 二维码管理者 */
+ (instancetype)sharedManager;

/** 二维码生成器 */
@property (nonatomic, strong, readonly) SCQRCodeGenerator *qrCodeGenerator;

/** 二维码识别器 */
@property (nonatomic, strong, readonly) SCQRCodeRecognizer *qrCodeRecognizer;

/** 二维码扫描器 */
@property (nonatomic, strong, readonly) SCQRCodeScanner *qrCodeScanner;

@end
