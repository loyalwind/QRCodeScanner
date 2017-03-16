//
//  SCQRCodeGenerator.m
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/17.
//  Copyright © 2017年 pengweijian. All rights reserved.
//

#import "SCQRCodeGenerator.h"
#import <objc/runtime.h>

@interface SCQRCodeGenerator ()
/** 二维码配置 */
@property (nonatomic, strong) UIColor *bgColor;
/** 填充的颜色 */
@property (nonatomic, strong) UIColor *fillColor;
/** 二维码图片的大小 */
@property (nonatomic, assign) CGSize imageSize;
@end

@implementation SCQRCodeGenerator
- (SCQRCodeConfig)configQRCode
{
    SCQRCodeConfig config = objc_getAssociatedObject(self, _cmd);
    if (!config) {
        __weak typeof(*&self) weakSelf = self;
        config = ^SCQRCodeGenerator *(UIColor *bgColor, UIColor *fillColor, CGSize imageSize){
            if (bgColor) {
                weakSelf.bgColor = bgColor;
            }else{
                if (!weakSelf.bgColor) weakSelf.bgColor = [UIColor whiteColor];
            }
            
            if (fillColor) {
                weakSelf.fillColor = fillColor;
            }else{
                if (!weakSelf.fillColor) weakSelf.fillColor = [UIColor blackColor];
            }
            
            if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
                weakSelf.imageSize = CGSizeMake(250, 250);
            }else{
                weakSelf.imageSize = imageSize;
            }
            return weakSelf;
        };
        
        objc_setAssociatedObject(self, _cmd, config, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return config;
}

- (SCQRCodeGenerator *)next
{
    return self;
}

- (SCQRCodeCreate)createQRCode
{
    SCQRCodeCreate createQRCode = objc_getAssociatedObject(self, _cmd);

    if (!createQRCode) {
        __weak typeof(*&self) weakSelf = self;
        createQRCode = ^UIImage *(NSString *qrcodeText){
            return [weakSelf _createQRCodeWithText:qrcodeText];
        };
        objc_setAssociatedObject(self, _cmd, createQRCode, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return createQRCode;
}

/**
 根据字符串信息生成二维码图片
 @param qrcodeText 字符串信息
 @return 二维码图片
 */
- (UIImage *)_createQRCodeWithText:(NSString *)qrcodeText
{
#pragma mark - 核心代码
    if (qrcodeText.length == 0) return nil;

    // 1创建生成二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2滤镜默认设置
    [filter setDefaults];
    
    // 3设置滤镜输出信息
    NSData *qrcodeData = [qrcodeText dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:qrcodeData forKeyPath:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    // 3.1上色(不是必须的)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"inputImage"] = filter.outputImage;
    param[@"inputColor0"] = [CIColor colorWithCGColor:self.fillColor.CGColor];
    param[@"inputColor1"] = [CIColor colorWithCGColor:self.bgColor.CGColor];
    filter = [CIFilter filterWithName:@"CIFalseColor" withInputParameters:param];
    
    // 4 输出图片
    CIImage *outputImg = filter.outputImage;
//    outputImg = [outputImg imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
//    UIImage *image = [UIImage imageWithCIImage:outputImg];
    // 5图片进行高清处理
    UIImage *image = [self _createNonInterpolatedUIImageFormCIImage:outputImg withSize:self.imageSize];
    return image;
}

- (UIImage *)_createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGSize)size
{
    // 创建一个CGImage对象
    CGImageRef imgRef = [CIContext.context createCGImage:image fromRect:image.extent];
    // 开启图片上下文
    UIGraphicsBeginImageContext(size);
    // 获得当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 修改上下文质量
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    // 上下文做缩放形变（由于y方向为负的,那么其实就是旋转180°,如果为正的那么不需要旋转，如果为0，那么就是缩放没有了）;
    CGContextScaleCTM(ctx, 1.0, -1.0);
    // 在上下文绘制图片
    CGContextDrawImage(ctx, CGContextGetClipBoundingBox(ctx), imgRef);
    // 从当前上下文获得图片
    UIImage *qrcodeImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    // 释放之前创建的CGImage对象
    CGImageRelease(imgRef);
    
    return qrcodeImage;
}

- (UIImage *)_1_createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef csRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapCxtRef = CGBitmapContextCreate(nil, width, height, 8, 0, csRef, (CGBitmapInfo)kCGImageAlphaNone);
    CGImageRef imageRef = [CIContext.context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapCxtRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapCxtRef, scale, scale);
    CGContextDrawImage(bitmapCxtRef, extent, imageRef);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(bitmapCxtRef);
    UIImage *returenImage = [UIImage imageWithCGImage:scaledImageRef];
    
    // 3.释放内存
    CGContextRelease(bitmapCxtRef);
    CGImageRelease(imageRef);
    CGImageRelease(scaledImageRef);
    CGColorSpaceRelease(csRef);
    
    return returenImage;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
