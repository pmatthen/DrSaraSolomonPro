//
//  BarcodeViewController.m
//  Dr Sara Solomon Pro
//
//  Created by Apple on 02/03/15.
//  Copyright (c) 2015 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "BarcodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AddFoodViewControllerStep2.h"
#import "Barcode.h"

@interface BarcodeViewController () <UIAlertViewDelegate> {
//    AVCaptureSession *_session;
//    AVCaptureDevice *_device;
//    AVCaptureDeviceInput *_input;
//    AVCaptureMetadataOutput *_output;
//    AVCaptureVideoPreviewLayer *_prevLayer;
//    
//    UIView *_highlightView;
//    UILabel *_label;
//    
//    NSString *detectionString;
//    NSDictionary *json;
}

@end

@implementation BarcodeViewController {
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    BOOL _running;
    AVCaptureMetadataOutput *_metadataOutput;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCaptureSession];
    _previewLayer.frame = _previewView.bounds;
    [_previewView.layer addSublayer:_previewLayer];
    self.foundBarcodes = [[NSMutableArray alloc] init];
    
    // listen for going into the background and stop the session
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    
    // set default allowed barcode types, remove types via setings menu if you don't want them to be able to be scanned
    self.allowedBarcodeTypes = [NSMutableArray new];
    [self.allowedBarcodeTypes addObject:@"org.iso.QRCode"];
    [self.allowedBarcodeTypes addObject:@"org.iso.PDF417"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.UPC-E"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Aztec"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39Mod43"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-13"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-8"];
    [self.allowedBarcodeTypes addObject:@"com.intermec.Code93"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code128"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startRunning];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - AV capture methods

- (void)setupCaptureSession {
    // 1
    if (_captureSession) return;
    // 2
    _videoDevice = [AVCaptureDevice
                    defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_videoDevice) {
        NSLog(@"No video camera on this device!");
        return;
    }
    // 3
    _captureSession = [[AVCaptureSession alloc] init];
    // 4
    _videoInput = [[AVCaptureDeviceInput alloc]
                   initWithDevice:_videoDevice error:nil];
    // 5
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    // 6
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]
                     initWithSession:_captureSession];
    _previewLayer.videoGravity =
    AVLayerVideoGravityResizeAspectFill;
    
    
    // capture and process the metadata
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue =
    dispatch_queue_create("com.1337labz.featurebuild.metadata", 0);
    [_metadataOutput setMetadataObjectsDelegate:self
                                          queue:metadataQueue];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
}

- (void)startRunning {
    if (_running) return;
    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes =
    _metadataOutput.availableMetadataObjectTypes;
    _running = YES;
}
- (void)stopRunning {
    if (!_running) return;
    [_captureSession stopRunning];
    _running = NO;
}

//  handle going foreground/background
- (void)applicationWillEnterForeground:(NSNotification*)note {
    [self startRunning];
}
- (void)applicationDidEnterBackground:(NSNotification*)note {
    [self stopRunning];
}

#pragma mark - Delegate functions

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    [metadataObjects
     enumerateObjectsUsingBlock:^(AVMetadataObject *obj,
                                  NSUInteger idx,
                                  BOOL *stop)
     {
         if ([obj isKindOfClass:
              [AVMetadataMachineReadableCodeObject class]])
         {
             // 3
             AVMetadataMachineReadableCodeObject *code =
             (AVMetadataMachineReadableCodeObject*)
             [_previewLayer transformedMetadataObjectForMetadataObject:obj];
             // 4
             Barcode * barcode = [Barcode processMetadataObject:code];
             
             for(NSString * str in self.allowedBarcodeTypes){
                 if([barcode.getBarcodeType isEqualToString:str]){
                     [self validBarcodeFound:barcode];
                     return;
                 }
             }
         }
     }];
}

- (void) validBarcodeFound:(Barcode *)barcode{
    [self stopRunning];
    [self.foundBarcodes addObject:barcode];
    [self showBarcodeAlert:barcode];
}
- (void) showBarcodeAlert:(Barcode *)barcode{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Code to do in background processing
        NSString * alertMessage = @"You found a barcode with type ";
        alertMessage = [alertMessage stringByAppendingString:[barcode getBarcodeType]];
        //        alertMessage = [alertMessage stringByAppendingString:@" and data "];
        //        alertMessage = [alertMessage stringByAppendingString:[barcode getBarcodeData]];
        alertMessage = [alertMessage stringByAppendingString:@"\n\nBarcode added to array of "];
        alertMessage = [alertMessage stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)[self.foundBarcodes count]-1]];
        alertMessage = [alertMessage stringByAppendingString:@" previously found barcodes."];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Barcode Found!"
                                                          message:alertMessage
                                                         delegate:self
                                                cancelButtonTitle:@"Done"
                                                otherButtonTitles:@"Scan again",nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Code to update the UI/send notifications based on the results of the background processing
            [message show];
            
        });
    });
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //Code for Done button
        // TODO: Create a finished view
    }
    if(buttonIndex == 1){
        //Code for Scan more button
        [self startRunning];
    }
}

- (void) settingsChanged:(NSMutableArray *)allowedTypes{
    for(NSObject * obj in allowedTypes){
        NSLog(@"%@",obj);
    }
    if(allowedTypes){
        self.allowedBarcodeTypes = [NSMutableArray arrayWithArray:allowedTypes];
    }
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    _highlightView = [[UIView alloc] init];
//    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
//    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
//    _highlightView.layer.borderWidth = 3;
//    [self.view addSubview:_highlightView];
//    
//    _label = [[UILabel alloc] init];
//    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
//    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
//    _label.textColor = [UIColor whiteColor];
//    _label.textAlignment = NSTextAlignmentCenter;
//    _label.text = @"(none)";
//    [self.view addSubview:_label];
//    
//    _session = [[AVCaptureSession alloc] init];
//    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    NSError *error = nil;
//    
//    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
//    if (_input) {
//        [_session addInput:_input];
//    } else {
//        NSLog(@"Error: %@", error);
//    }
//    
//    _output = [[AVCaptureMetadataOutput alloc] init];
//    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    [_session addOutput:_output];
//    
//    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
//    
//    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
//    _prevLayer.frame = self.view.bounds;
//    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    [self.view.layer addSublayer:_prevLayer];
//    
//    [_session startRunning];
//    
//    [self.view bringSubviewToFront:_highlightView];
//    [self.view bringSubviewToFront:_label];
//}
//
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
//{
//    if (detectionString != nil) {
//        [_session stopRunning];
//        [self shouldPerformSegueWithIdentifier:@"ResultsSegue" sender:self];
//    } else {
//        CGRect highlightViewRect = CGRectZero;
//        AVMetadataMachineReadableCodeObject *barCodeObject;
//        detectionString = nil;
//        NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
//                                  AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
//                                  AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
//        
//        for (AVMetadataObject *metadata in metadataObjects) {
//            for (NSString *type in barCodeTypes) {
//                if ([metadata.type isEqualToString:type])
//                {
//                    barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
//                    highlightViewRect = barCodeObject.bounds;
//                    detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
//                    break;
//                }
//            }
//            
//            if (detectionString != nil)
//            {
//                _label.text = detectionString;
//                break;
//            }
//            else
//                _label.text = @"(none)";
//        }
//        
//        _highlightView.frame = highlightViewRect;
//    }
//}
//
//-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    NSLog(@"detectionString = %@", detectionString);
//    
////    detectionString = @"078915030900";
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.outpan.com/api/get-product.php?apikey=2a5196fc65f48fb64c9b2721e3eafa55&barcode=%@", detectionString]]
//                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
//                                                       timeoutInterval:10];
//    
//    [request setHTTPMethod: @"GET"];
//    
//    NSError *requestError;
//    NSURLResponse *urlResponse = nil;
//    
//    
//    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
//    
//    NSError *error = [[NSError alloc] init];
//    
//    json = [NSJSONSerialization JSONObjectWithData:response1 options:kNilOptions error:&error];
//    
//    if ([json isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *dict = (NSDictionary*)json;
//        for (NSString *key in dict) {
//            id object = [dict objectForKey:key];
//            NSLog(@"The object for key \"%@\" is: %@", key, object);
//        }
//    }
//    
//    NSLog(@"json[name] = %@", [json objectForKey:@"name"]);
//    
//    if ([[json objectForKey:@"name"] length] == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"product not found in barcode database" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//        [_session startRunning];
//        return NO;
//    } else {
//        return YES;
//    }
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    AddFoodViewControllerStep2 *myAddFoodViewControllerStep2 = (AddFoodViewControllerStep2 *)segue.destinationViewController;
//    myAddFoodViewControllerStep2.searchText = [json objectForKey:@"name"];
//}

@end
