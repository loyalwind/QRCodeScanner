//
//  SCQRCodeGenerator.h
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/17.
//  Copyright © 2017年 pengweijian. All rights reserved.
//  二维码生成器

#import <UIKit/UIKit.h>
@class SCQRCodeGenerator;

NS_ASSUME_NONNULL_BEGIN

/**
 二维码生成器配置Block
 @param bgColor  二维码背景颜色(nil时，默认用代表白色)
 @param fillColor 二维码填充颜色(nil时，默认用代表黑色)
 @param imageSize 生成的二维码图片(图片大小，CGSizeZero 时用 CGSizeMake(250,250))
 */
typedef  SCQRCodeGenerator * _Nonnull (^SCQRCodeConfig)(UIColor * _Nullable bgColor ,UIColor * _Nullable fillColor,CGSize imageSize);

/**
 创建二维码图片的 block
 @param qrcodeText 二维码的实际内容
 */
typedef UIImage * _Nullable (^SCQRCodeCreate)(NSString * _Nonnull qrcodeText);

@interface SCQRCodeGenerator : NSObject

/** 配置二维码信息block */
@property (nonatomic, copy, readonly) SCQRCodeConfig configQRCode;
/** 创建二维码block */
@property (nonatomic, copy, readonly) SCQRCodeCreate createQRCode;
/** 下一步 */
@property (nonatomic, strong, readonly) SCQRCodeGenerator *next;

@end

NS_ASSUME_NONNULL_END
