# QRCodeScanner
苹果原生二维码扫描，识别，生成：使用响应式实现功能


###二维码的生成

```objc
> 大致过程，拿到二维码管理者单例对象的`二维码生成器`对象，先进行配置索要生成的二维码的信息设置block，然后调用生成二维码的生成 block,就会返回一张而二维码图片
UIImage *image = SCQRCodeManager.sharedManager.qrCodeGenerator.configQRCode(_qrcodeBgColor,_qrcodeDotColor,CGSizeZero).next.createQRCode(self.qrcodeField.text);
```

###二维码图片的识别

```objc
> 大致过程，拿到二维码管理者单例对象的`二维码识别器`对象，然后调用`二维码识别器`的识别block,就会返回识别到的信息的最后一条
NSString *string = SCQRCodeManager.sharedManager.qrCodeRecognizer.recognizeQRCode(self.qrcodeImageView.image);

```

###二维码的扫描

```objc

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 创建二维码扫描器对象
    SCQRCodeScanner *scanner = [[SCQRCodeScanner alloc] initWithPreviewFrame:self.view.bounds];
    // 添加预留视图到控制器 view上
    [self.view insertSubview:scanner.preview atIndex:0];
    // 设置扫描识别区域
    scanner.preview.rectOfPierce = CGRectMake((self.view.bounds.size.width-250)*0.5, (self.view.bounds.size.height-250)*0.3, 250, 250);
    _scanner = scanner;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 5.开始扫描
    [_scanner startScanCompeletion:^(NSString * _Nullable qrcodeString) {
    NSLog(@"扫描结果：%@",qrcodeString);
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 6.停止扫描
    [_scanner stoptScan];
}

```
### 其他设置方法
```objc
// 切换扫描识别大区域
- (IBAction)switchBigAreaAction {
    [_scanner switchToRectOfPierce:CGRectMake(100, 150, 250 ,350)];
}
// 切换扫描识别小区域
- (IBAction)switchSmallAreaAction {
    [_scanner switchToRectOfPierce:CGRectMake((self.view.bounds.size.width-250)*0.5, (self.view.bounds.size.height-250)*0.3, 250, 250)];
}
// 开关灯
- (IBAction)openFlightAction
{
    _scanner.deviceTorchOn = !_scanner.isDeviceTorchOn;
}

```
