//
//  LKQrCodeVC.m
//  LKQRtest
//
//  Created by 888 on 16/8/5.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "LKQrCodeVC.h"

#import <AVFoundation/AVFoundation.h>

#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface LKQrCodeVC () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation LKQrCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor grayColor]];

    //用于扫描二维码的view
    UIView *qrView = [[UIView alloc] init];
    qrView.frame = CGRectMake(kScreenWidth / 2 - 130, 120, 260, 400);
    qrView.backgroundColor = [UIColor redColor];
    [self.view addSubview:qrView];
    
    
    // 获取 AVCaptureDevice 实例
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return ;
    }
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    static const char *QRCodeQueueName = "QRCodeQueue";
    dispatchQueue = dispatch_queue_create(QRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:qrView.layer.bounds];
    [qrView.layer addSublayer:_videoPreviewLayer];
    // 开始会话
    [_captureSession startRunning];
}

#pragma AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
            NSLog(@"二维码扫描结果是：%@",result);
        } else {
            NSLog(@"不是二维码");
        }
        
    }
}


- (void)dealloc
{
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
}

@end
