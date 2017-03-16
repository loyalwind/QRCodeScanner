//
//  SCQRCodeScanner.m
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/17.
//  Copyright © 2017年 pengweijian. All rights reserved.
//

#import "SCQRCodeScanner.h"
#import "SCCapturePreview.h"
#import "SCAuthorizationStatusTools.h"

@interface SCQRCodeScanner ()<AVCaptureMetadataOutputObjectsDelegate>
/** 捕捉会话  */
@property (nonatomic, strong) AVCaptureSession *session;
/** 捕捉会话的设备  */
@property (nonatomic, strong) AVCaptureDevice *device;
/** 输入设备  */
@property (nonatomic, strong) AVCaptureDeviceInput *input;
/** 输出元数据设备  */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
/** 完成的回调 */
@property (nonatomic, copy) void(^Compeletion)(NSString *qrcodeString);
/** 扫描预留视图 */
@property (nonatomic, strong) SCCapturePreview *preview;

@end

@implementation SCQRCodeScanner

- (instancetype)initWithPreviewFrame:(CGRect)previewFrame
{
    if (self = [self init]) {
        // 1.创建步骤会话
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        session.sessionPreset = (UIScreen.mainScreen.bounds.size.height<=480)?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh;
        _session = session;

        // 2.添加捕捉设备输入
        // 2.1 创建视频媒体捕捉设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _device = device;
        // 2.2 根据捕捉设备创建输入
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        // 2.3 添加捕捉设备输入
        if ([session canAddInput:input]){
            [session addInput:input];
        }
        _input = input;
        
        // 3 添加捕捉设备输出
        // 3.1 创建捕捉原始数据输出
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        // 3.2 设置代理
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        // 3.3 添加捕捉设备输出
        if ([session canAddOutput:output]){
            [session addOutput:output];
        }
        // 3.4 设置输入元数据类型（必须在输出设备添加到session之后设置，不然会奔溃）
        [SCAuthorizationStatusTools authorizeStatusForCamera:^(BOOL hasAuthorized) {
            if (hasAuthorized) {
                output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code];
            }
        }];
        _output = output;
        
        // 4 预览图层
        SCCapturePreview *preview = [[SCCapturePreview alloc] initWithFrame:previewFrame];
        // 4.1 捕捉会话
        preview.captureSession = session;
        _preview = preview;
    }
    return self;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count <= 0) return;
    AVMetadataMachineReadableCodeObject *meta = metadataObjects.firstObject;
    if (_session.isRunning) {
        NSLog(@"结果：【%@】",meta.stringValue);

        _Compeletion ? _Compeletion(meta.stringValue) : nil;
        // [self stoptScan];

    }else{
        NSLog(@"没有数据");
    }
}

- (void)startScanCompeletion:(void (^)(NSString *))compeletion
{
    [self.session startRunning];
    _Compeletion = compeletion;
    [_preview.pierceOverlayView setNeedsDisplay];
}

- (void)stoptScan
{
    [self.session stopRunning];
    _Compeletion = nil;
}
- (void)setDeviceTorchOn:(BOOL)deviceTorchOn
{
    if (![_device hasTorch])return;
    
    [_device lockForConfiguration:nil];
    _device.torchMode = deviceTorchOn ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    [_device unlockForConfiguration];
}
- (BOOL)isDeviceTorchOn
{
    if (![_device hasTorch])return NO;
    return _device.torchMode == AVCaptureTorchModeOn;
}
- (void)setDeviceTorchMode:(AVCaptureTorchMode)deviceTorchMode
{
    if (![_device hasTorch])return;
    
    [_device lockForConfiguration:nil];
    _device.torchMode = deviceTorchMode;
    [_device unlockForConfiguration];
}

- (AVCaptureTorchMode)deviceTorchMode
{
    if (![_device hasTorch])return kNilOptions;
    return _device.torchMode;
}

- (void)switchToRectOfPierce:(CGRect)rectOfPierce
{
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        
        [_session stopRunning];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _preview.rectOfPierce = rectOfPierce;
        [_session startRunning];
    });
}

@end
