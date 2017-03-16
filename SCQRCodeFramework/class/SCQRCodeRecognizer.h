//
//  SCQRCodeRecognizer.h
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/17.
//  Copyright © 2017年 pengweijian. All rights reserved.
//  二维码识别器

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 二维码识别 block
 @param image  需要识别的二维码图片
 */
typedef  NSString * _Nonnull (^SCQRCodeRecognize)(UIImage * _Nonnull image);

@interface SCQRCodeRecognizer : NSObject

/** 二维码识别 block */
@property (nonatomic, copy, readonly) SCQRCodeRecognize recognizeQRCode;

@end

NS_ASSUME_NONNULL_END
