//
//  SCCapturePreview.m
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/15.
//  Copyright © 2017年 pengweijian. All rights reserved.
//

#import "SCCapturePreview.h"

UIBezierPath *creatBezierPathFourAngleInRect(CGRect rect);

@interface SCCapturePierceOverlayView ()
/** 四角图层  */
@property (nonatomic, strong) CAShapeLayer *cornerLayer;
/** 冲击波view */
@property (nonatomic, strong) UIImageView *blastWaveView;
/** 冲击波外边框的frame */
@property (nonatomic, assign) CGRect offsetRect;
/** 记录是否为前后台 */
@property (nonatomic, assign, getter=isForeground) BOOL foreground;

@end

@implementation SCCapturePierceOverlayView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [self.layer addSublayer:self.cornerLayer];
        [self addSubview:({
            UIImageView *blastWaveView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 5)];
            NSString *imgName = [[NSBundle mainBundle] pathForResource:@"SCQRCodeFramework.bundle/greenBlastWave@2x.png" ofType:nil];

            blastWaveView.image = [self wj_resizeWithImageName:imgName];
            _blastWaveView = blastWaveView;
            blastWaveView;
        })];
        
        self.foreground = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (!CGRectEqualToRect(rect, CGRectZero)) {
        if (!CGRectEqualToRect(rect, self.frame)){
            CGRect cornerRect = CGRectInset(rect, -1, -1);
            UIBezierPath *path = creatBezierPathFourAngleInRect(cornerRect);
            self.cornerLayer.path = path.CGPath;
        }
    }
    
    _offsetRect = rect;
    [self startBlastWaveAnimation];
}

- (CAShapeLayer *)cornerLayer
{
    if (!_cornerLayer) {
        CAShapeLayer *cornerLayer = [[CAShapeLayer alloc] init];
        cornerLayer.backgroundColor = [UIColor clearColor].CGColor;
        cornerLayer.fillColor       = [UIColor clearColor].CGColor;
        cornerLayer.strokeColor     = [UIColor greenColor].CGColor;
        cornerLayer.lineWidth       = 2;
        _cornerLayer = cornerLayer;
    }
    return _cornerLayer;
}

- (void)setBlastWaveImage:(UIImage *)blastWaveImage
{
    _blastWaveImage = blastWaveImage;
    NSString *imgName = [[NSBundle mainBundle] pathForResource:@"SCQRCodeFramework.bundle/greenBlastWave@2x.png" ofType:nil];

    self.blastWaveView.image = blastWaveImage ? blastWaveImage : [self wj_resizeWithImageName:imgName];
}

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        if (!CGRectEqualToRect(frame, self.frame)){
            [self setNeedsDisplay];
        }
    }
    [super setFrame:frame];
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    self.foreground = YES;
    [self startBlastWaveAnimation];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.blastWaveView.frame;
    frame.size.width = self.bounds.size.width;
    self.blastWaveView.frame = frame;
}

- (void)startBlastWaveAnimation
{
    if (!self.isForeground) return;
    // 先恢复原位置
    CGRect frame = self.blastWaveView.frame;
    frame.origin.y = self.offsetRect.origin.y;
    self.blastWaveView.frame = frame;
    
    // 移除之前的动画
    [self.blastWaveView.layer removeAllAnimations];
    
    // 执行动画
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2.0 animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        [UIView setAnimationRepeatAutoreverses:YES];
        
        CGRect frame = weakSelf.blastWaveView.frame;
        frame.origin.y = CGRectGetMaxY(weakSelf.offsetRect)-5;
        weakSelf.blastWaveView.frame = frame;
    }];
}

- (void)appWillEnterForeground
{
    self.foreground = YES;
    [self startBlastWaveAnimation];
}

- (void)appDidEnterBackground
{
    self.foreground = NO;
}
- (UIImage *)wj_resizeWithImageName:(NSString *)name
{
    UIImage *normalImage = [UIImage imageNamed:name];
    
    CGFloat w = normalImage.size.width*0.5;
    CGFloat h = normalImage.size.height*0.5;
    //传入上下左右不需要拉升的边距，只拉伸/填铺中间部分
    return [normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@interface SCCapturePreview ()
/** 半透明蒙版层（蒙版，子图层）*/
@property (nonatomic, strong) CALayer *overlayLayer;
/** 穿透框图层（蒙版的中间穿透层）*/
@property (nonatomic, strong) CAShapeLayer *pierceLayer;
/** 穿透预留视图（中间小框框视图，子视图）*/
@property (nonatomic, strong) SCCapturePierceOverlayView *pierceOverlayView;

@end

@implementation SCCapturePreview

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupConfig];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupConfig];
    }
    return self;
}
- (void)setupConfig
{
    if (self.layer.sublayers.count > 0) {
        [self.layer insertSublayer:self.overlayLayer atIndex:1];
    }else{
        [self.layer addSublayer:self.overlayLayer];
    }
    [self addSubview:self.pierceOverlayView];
}

#pragma mark - setter and getter
- (void)setRectOfPierce:(CGRect)rectOfPierce
{
    _rectOfPierce = rectOfPierce;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.pierceOverlayView.frame = rectOfPierce;
    }];

    if (CGRectEqualToRect(rectOfPierce, CGRectZero)) {
        self.overlayLayer.hidden = YES;
    }else{
        self.overlayLayer.hidden = NO;
    }
    
//    CGSize scanSize = self.bounds.size;
//    CGFloat x = rectOfPierce.origin.x/scanSize.width;
//    CGFloat y = rectOfPierce.origin.y/scanSize.height;
//    CGFloat w = rectOfPierce.size.width/scanSize.width;
//    CGFloat h = rectOfPierce.size.height/scanSize.height;
//    CGRect rectOfInterest1 = CGRectMake(y, x, h, w);
    // 把范围图层坐标系下自定义的识别区域 转成 设备输出数据坐标系下的指定识别区域
    CGRect rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:rectOfPierce];
    for (AVCaptureOutput *output in self.captureSession.outputs) {
        if ([output isKindOfClass:[AVCaptureMetadataOutput class]]) {
            AVCaptureMetadataOutput *metadataOutput = (AVCaptureMetadataOutput *)output;
            metadataOutput.rectOfInterest = rectOfInterest;
        }
    }
}

- (void)setCaptureSession:(AVCaptureSession *)captureSession
{
    [(AVCaptureVideoPreviewLayer *)self.layer setSession:captureSession];
}

- (AVCaptureSession *)captureSession
{
    return [(AVCaptureVideoPreviewLayer *)self.layer session];
}

- (CAShapeLayer *)pierceLayer
{
    if (!_pierceLayer) {
        CAShapeLayer *pierceLayer = [CAShapeLayer layer];
        pierceLayer.backgroundColor = [UIColor clearColor].CGColor;
        _pierceLayer = pierceLayer;
    }
    return _pierceLayer;
}

- (CALayer *)overlayLayer
{
    if (!_overlayLayer) {
        _overlayLayer = [CALayer layer];
        _overlayLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        _overlayLayer.hidden = YES;
    }
    return _overlayLayer;
}

- (SCCapturePierceOverlayView *)pierceOverlayView
{
    if (!_pierceOverlayView) {
        SCCapturePierceOverlayView *pierceOverlayView = [[SCCapturePierceOverlayView alloc] init];
        pierceOverlayView.backgroundColor = [UIColor clearColor];
        _pierceOverlayView = pierceOverlayView;
    }
    return _pierceOverlayView;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    return (AVCaptureVideoPreviewLayer *)self.layer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    self.overlayLayer.frame = rect;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:_rectOfPierce cornerRadius:0].bezierPathByReversingPath;
    [path appendPath:path1];

    self.pierceLayer.path = path.CGPath;
    self.overlayLayer.mask = self.pierceLayer;
    self.pierceOverlayView.frame = _rectOfPierce;
}
@end

UIBezierPath * creatBezierPathFourAngleInRect(CGRect rect)
{
    // 左上角路径
    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    [leftTopPath moveToPoint: CGPointMake(rect.origin.x, rect.origin.y+15)];
    [leftTopPath addLineToPoint: CGPointMake(rect.origin.x, rect.origin.y)];
    [leftTopPath addLineToPoint: CGPointMake(rect.origin.x+15, rect.origin.y)];
    
    // 右上角路径
    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    [rightTopPath moveToPoint: CGPointMake(CGRectGetMaxX(rect)-15, rect.origin.y)];
    [rightTopPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect), rect.origin.y)];
    [rightTopPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect), rect.origin.y+15)];
    
    // 右下角路径
    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    [rightBottomPath moveToPoint: CGPointMake(CGRectGetMaxX(rect),CGRectGetMaxY(rect)-15)];
    [rightBottomPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect),CGRectGetMaxY(rect))];
    [rightBottomPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect)-15, CGRectGetMaxY(rect))];
    
    // 左下角路径
    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    [leftBottomPath moveToPoint: CGPointMake(rect.origin.x+15,CGRectGetMaxY(rect))];
    [leftBottomPath addLineToPoint: CGPointMake(rect.origin.x,CGRectGetMaxY(rect))];
    [leftBottomPath addLineToPoint: CGPointMake(rect.origin.x, CGRectGetMaxY(rect)-15)];
    
    // 合并路径
    // UIBezierPath *totalPath = [UIBezierPath bezierPath];
    [leftTopPath appendPath:leftTopPath];
    [leftTopPath appendPath:rightTopPath];
    [leftTopPath appendPath:rightBottomPath];
    [leftTopPath appendPath:leftBottomPath];
    
    return leftTopPath;
}
