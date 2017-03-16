//
//  SCCapturePreview.h
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/15.
//  Copyright © 2017年 pengweijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/**
 穿透覆盖视图
 */
@interface SCCapturePierceOverlayView : UIView
/** 冲击波图片 */
@property (nonatomic, strong) UIImage *blastWaveImage;

@end

IB_DESIGNABLE

/**
 预览视图
 */
@interface SCCapturePreview : UIView

/** 捕捉会话 */
@property (nonatomic, weak) AVCaptureSession *captureSession;
/** 穿透区域 （根据 rectOfInterest of AVCaptureMetadataOutput 而变化）*/
@property(nonatomic, assign) IBInspectable CGRect rectOfPierce;
/** 穿透框图层 */
@property (nonatomic, strong, readonly) CAShapeLayer *pierceLayer;
/** 半透明蒙版层 */
@property (nonatomic, strong, readonly) CALayer *overlayLayer;
/** 预览图层（与 session 相关连） */
@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer *previewLayer;
/** 穿透覆盖层 view */
@property (nonatomic, strong, readonly) SCCapturePierceOverlayView *pierceOverlayView;

@end
