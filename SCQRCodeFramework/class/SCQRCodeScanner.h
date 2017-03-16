//
//  SCQRCodeScanner.h
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/17.
//  Copyright © 2017年 pengweijian. All rights reserved.
//  二维码扫描器

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class SCCapturePreview;

NS_ASSUME_NONNULL_BEGIN

@interface SCQRCodeScanner : NSObject

/** 扫描预留视图 */
@property (nonatomic, strong, readonly) SCCapturePreview *preview;

/** 设备闪光灯是否开着的 */
@property (nonatomic, assign, getter=isDeviceTorchOn) BOOL deviceTorchOn;

/**
 根据指定预览视图范围创建扫描对象
 @param previewFrame 知道预览视图范围
 */
- (instancetype)initWithPreviewFrame:(CGRect)previewFrame;

/**
 开始扫描
 @param compeletion 扫描完成的回调
 */
- (void)startScanCompeletion:(void(^_Nullable)(NSString * _Nullable qrcodeString))compeletion;

/** 停止扫描 */
- (void)stoptScan;

/**
 切换到指定穿透扫描区域
 @param rectOfPierce 需要指定的区域
 */
- (void)switchToRectOfPierce:(CGRect)rectOfPierce;

@end

NS_ASSUME_NONNULL_END
