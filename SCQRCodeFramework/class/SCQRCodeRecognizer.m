//
//  SCQRCodeRecognizer.m
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/17.
//  Copyright © 2017年 pengweijian. All rights reserved.
//

#import "SCQRCodeRecognizer.h"
#import <objc/runtime.h>
#import <CoreImage/CoreImage.h>

@implementation SCQRCodeRecognizer

- (SCQRCodeRecognize)recognizeQRCode
{
    SCQRCodeRecognize recognize = objc_getAssociatedObject(self, _cmd);
    
    if (!recognize) {
        __weak typeof(*&self) weakSelf = self;
        recognize = ^NSString *(UIImage *image){
            return [weakSelf _recognizeTheImage:image];
        };
        objc_setAssociatedObject(self, _cmd, recognize, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return recognize;
}

/**
 是图片中的一个二维码
 @param image 图片
 @return 二维码信息
 */
- (NSString *)_recognizeTheImage:(UIImage *)image
{
#pragma mark - 核心代码
    // 0 如果没有图片，直接返回
    if (!image) return nil;
    // 0.1 拿到二维码图片
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    if (!ciImage) return nil;
    
    NSDictionary *options = @{CIDetectorAccuracy:CIDetectorAccuracyHigh};
    // 1 创建一个二维码探测器
    CIDetector *detecor = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:options];
    // 2 如果探测结果数量为0，那么就说明图片中没有二维码
    NSArray<CIFeature *> *features = [detecor featuresInImage:ciImage];
    if (features.count == 0) return nil;
    // 3 拿到最后一个探测结果转成字符串信息
    CIQRCodeFeature *feature = (CIQRCodeFeature *)features.lastObject;
    return feature.messageString;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
