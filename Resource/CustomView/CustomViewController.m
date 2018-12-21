//
//  CustomViewController.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/29/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "LogInViewController.h"
#import "AppDelegate.h"
#import "HomeModel.h"
#import "Utility.h"
#import "Setting.h"
#import <AudioToolbox/AudioToolbox.h>
#import <sys/utsname.h>
#import "Receipt.h"
#import "OrderTaking.h"
#import "OrderNote.h"


@interface CustomViewController ()
{
    UILabel *_lblStatus;
}
@end

@implementation CustomViewController
CGFloat animatedDistance;



@synthesize homeModel;
@synthesize indicator;
@synthesize overlayView;
@synthesize waitingView;
@synthesize addedNotiView;
@synthesize removedNotiView;
@synthesize lblAlertMsg;
@synthesize lblWaiting;
@synthesize toolBar;


-(void)setCurrentVc
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.vc = self;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    //triangle band
    UIImageView *demoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"triangle_dev_om.png"]];
    CGRect frame = demoView.frame;
    frame.size.width = 64;
    frame.size.height = 64;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    frame.origin.y = 0;
    demoView.frame = frame;
    [self.view addSubview:demoView];
    demoView.layer.zPosition = 1;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self setCurrentVc];
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
}

- (void)loadView
{
    [super loadView];
    
    

    homeModel = [[HomeModel alloc]init];
    homeModel.delegate = self;

    
    
    {
        overlayView = [[UIView alloc] initWithFrame:self.view.frame];
        overlayView.backgroundColor = [UIColor colorWithRed:256 green:256 blue:256 alpha:0];

        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(self.view.bounds.size.width/2-indicator.frame.size.width/2,self.view.bounds.size.height/2-indicator.frame.size.height/2,indicator.frame.size.width,indicator.frame.size.height);        
    }
    
    waitingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
    waitingView.backgroundColor = [UIColor grayColor];
    waitingView.center = self.view.center;
    waitingView.layer.cornerRadius = 8;
    
    
    addedNotiView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"added.png"]];
    addedNotiView.center = self.view.center;
    
    
    removedNotiView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"removed.png"]];
    removedNotiView.center = self.view.center;
    
    
    lblAlertMsg = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-16*2, 44)];
    lblAlertMsg.center = self.view.center;
    
    
    lblWaiting = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-16*2, 44)];
    lblWaiting.center = self.view.center;
    CGRect frame = lblWaiting.frame;
    frame.origin.y = frame.origin.y + indicator.frame.size.height;
    lblWaiting.frame = frame;
    
    
    _lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    
    
    //toolbar
    toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setTintColor:cSystem4_10];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
    doneBtn.tintColor = cSystem1;
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];

}

-(void) blinkAddedNotiView
{
    addedNotiView.alpha = 1;
    [self.view addSubview:addedNotiView];
    
    

    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             addedNotiView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             dispatch_async(dispatch_get_main_queue(),^ {
                                 [addedNotiView removeFromSuperview];
                             } );
                         }
         ];
    });
}

-(void) blinkRemovedNotiView
{
    removedNotiView.alpha = 1;
    [self.view addSubview:removedNotiView];
    
    
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [UIView animateWithDuration:0.5
                                        animations:^{
                                            removedNotiView.alpha = 0.0;
                                        }
                                        completion:^(BOOL finished){
                                            dispatch_async(dispatch_get_main_queue(),^ {
                                                [removedNotiView removeFromSuperview];
                                            } );
                                        }
                        ];
                   });
}

-(void) blinkAlertMsg:(NSString *)alertMsg
{
    lblAlertMsg.text = alertMsg;
    lblAlertMsg.backgroundColor = cSystem4;
    lblAlertMsg.textColor = [UIColor whiteColor];
    lblAlertMsg.textAlignment = NSTextAlignmentCenter;
    lblAlertMsg.layer.cornerRadius = 8;
    lblAlertMsg.layer.masksToBounds = YES;
    lblAlertMsg.alpha = 1;
    [self.view addSubview:lblAlertMsg];
    
    
    
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [UIView animateWithDuration:0.5
                                        animations:^{
                                            lblAlertMsg.alpha = 0.0;
                                        }
                                        completion:^(BOOL finished){
                                            dispatch_async(dispatch_get_main_queue(),^ {
                                                [lblAlertMsg removeFromSuperview];
                                            } );
                                        }
                        ];
                   });
}

-(void) loadWaitingView
{
    [indicator startAnimating];
    indicator.alpha = 1;
    overlayView.alpha = 1;
    waitingView.alpha = 1;
    
    
    indicator.opaque = NO;
    indicator.backgroundColor = [UIColor clearColor];
    [indicator setColor:[UIColor whiteColor]];
//    indicator.layer.zPosition = 1;
    
    
    NSString *message = [Setting getValue:@"100m" example:@"Processing..."];
    lblWaiting.text = message;
    lblWaiting.backgroundColor = [UIColor clearColor];
    lblWaiting.textColor = [UIColor whiteColor];
    lblWaiting.textAlignment = NSTextAlignmentCenter;
    lblWaiting.alpha = 1;
    
    
    CGRect frame = indicator.frame;
    frame.origin.y = frame.origin.y - indicator.frame.size.height/2;
    indicator.frame = frame;
    
    
    
    // and just add them to navigationbar view
    [self.view addSubview:waitingView];
    [self.view addSubview:lblWaiting];
    [self.view addSubview:overlayView];
    [self.view addSubview:indicator];
    [self.view bringSubviewToFront:indicator];
}

-(void)removeWaitingView
{
    UIView *view = overlayView;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         lblWaiting.alpha = 0.0;
                         waitingView.alpha = 0.0;
                         view.alpha = 0.0;
                         indicator.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         dispatch_async(dispatch_get_main_queue(),^ {
                             [lblWaiting removeFromSuperview];
                             [waitingView removeFromSuperview];
                             [view removeFromSuperview];
                             [indicator stopAnimating];
                             [indicator removeFromSuperview];
                         } );
                     }
     ];
}

-(void) loadingOverlayView
{
    [indicator startAnimating];
    indicator.alpha = 1;
    overlayView.alpha = 1;


    indicator.center = self.view.center;
    
    

    // and just add them to navigationbar view
    [self.view addSubview:overlayView];
    [self.view addSubview:indicator];
}

-(void) removeOverlayViews
{
    UIView *view = overlayView;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         view.alpha = 0.0;
                         indicator.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         dispatch_async(dispatch_get_main_queue(),^ {
                             [view removeFromSuperview];
                             [indicator stopAnimating];
                             [indicator removeFromSuperview];
                         } );
                     }
     ];
}

- (void) connectionFail
{
    [self removeOverlayViews];
    NSString *title = [Utility subjectNoConnection];
    NSString *message = [Utility detailNoConnection];
    [self showAlert:title message:message];
}

- (void)itemsFail
{
    [self removeOverlayViews];
    NSString *title = [Utility getErrorOccurTitle];
    NSString *message = [Utility getErrorOccurMessage];
    [self showAlert:title message:message];
}


- (void)itemsInserted
{
}

- (void)itemsUpdated
{

}

- (void)alertMsg:(NSString *)msg
{
    [self showAlert:@"" message:msg];
}

- (void) showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *attrStringTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [attrStringTitle addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Prompt-SemiBold" size:17]
                            range:NSMakeRange(0, title.length)];
    [attrStringTitle addAttribute:NSForegroundColorAttributeName
                            value:cSystem4
                            range:NSMakeRange(0, title.length)];
    [alert setValue:attrStringTitle forKey:@"attributedTitle"];
    
    
    NSMutableAttributedString *attrStringMsg = [[NSMutableAttributedString alloc] initWithString:message];
    [attrStringMsg addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:@"Prompt-Regular" size:15]
                          range:NSMakeRange(0, message.length)];
    [attrStringMsg addAttribute:NSForegroundColorAttributeName
                            value:cSystem4
                            range:NSMakeRange(0, message.length)];
    [alert setValue:attrStringMsg forKey:@"attributedMessage"];
    
    
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color = cSystem1;
    NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"OK" attributes:attribute];
    
    UILabel *label = [[defaultAction valueForKey:@"__representer"] valueForKey:@"label"];
    label.attributedText = attrString;
}

- (void) showAlert:(NSString *)title message:(NSString *)message method:(SEL)method
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    NSMutableAttributedString *attrStringTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [attrStringTitle addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Prompt-SemiBold" size:17]
                            range:NSMakeRange(0, title.length)];
    [attrStringTitle addAttribute:NSForegroundColorAttributeName
                            value:cSystem4
                            range:NSMakeRange(0, title.length)];
    [alert setValue:attrStringTitle forKey:@"attributedTitle"];
    
    
    NSMutableAttributedString *attrStringMsg = [[NSMutableAttributedString alloc] initWithString:message];
    [attrStringMsg addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:@"Prompt-Regular" size:15]
                          range:NSMakeRange(0, message.length)];
    [attrStringMsg addAttribute:NSForegroundColorAttributeName
                            value:cSystem4
                            range:NSMakeRange(0, attrStringMsg.length)];
    [alert setValue:attrStringMsg forKey:@"attributedMessage"];
    
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self performSelector:method withObject:self afterDelay: 0.0];
                                    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color = cSystem1;
    NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"OK" attributes:attribute];
    
    UILabel *label = [[defaultAction valueForKey:@"__representer"] valueForKey:@"label"];
    label.attributedText = attrString;
}

- (void) showAlert:(NSString *)title message:(NSString *)message firstResponder:(UIView *)view
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    NSMutableAttributedString *attrStringTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [attrStringTitle addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Prompt-SemiBold" size:17]
                            range:NSMakeRange(0, title.length)];
    [alert setValue:attrStringTitle forKey:@"attributedTitle"];
    [attrStringTitle addAttribute:NSForegroundColorAttributeName
                            value:cSystem4
                            range:NSMakeRange(0, title.length)];
    
    
    NSMutableAttributedString *attrStringMsg = [[NSMutableAttributedString alloc] initWithString:message];
    [attrStringMsg addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:@"Prompt-Regular" size:15]
                          range:NSMakeRange(0, message.length)];
    [attrStringMsg addAttribute:NSForegroundColorAttributeName
                            value:cSystem4
                            range:NSMakeRange(0, message.length)];
    [alert setValue:attrStringMsg forKey:@"attributedMessage"];
    
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [view becomeFirstResponder];
                                    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color = cSystem1;
    NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"OK" attributes:attribute];
    
    UILabel *label = [[defaultAction valueForKey:@"__representer"] valueForKey:@"label"];
    label.attributedText = attrString;
}

-(void)itemsDownloaded:(NSArray *)items
{
    if(homeModel.propCurrentDB == dbMaster || homeModel.propCurrentDB == dbMasterWithProgressBar)
    {

        [Utility itemsDownloaded:items];
        [self removeOverlayViews];
        [self loadViewProcess];//call child process
    }
}

-(void)loadViewProcess
{

}

-(void)setShadow:(UIView *)view
{
    [self setShadow:view radius:2];
}

-(void)setShadow:(UIView *)view radius:(NSInteger)radius
{
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, radius);
    view.layer.shadowRadius = radius;
    view.layer.shadowOpacity = 0.8f;
    view.layer.masksToBounds = NO;
}

-(void)setButtonDesign:(UIView *)view
{
    UIButton *button = (UIButton *)view;
    button.layer.cornerRadius = 14;
}

-(void)setCornerAndShadow:(UIView *)view cornerRadius:(NSInteger)cornerRadius
{
    view.layer.cornerRadius = cornerRadius;
    [self setShadow:view];
}

-(CGSize)suggestedSizeWithFont:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode forString:(NSString *)text
{
    if(!text)
    {
        text = @"";
    }
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font,       NSParagraphStyleAttributeName: paragraphStyle}];
    CGRect bounds = [attributedString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return bounds.size;
}

- (void)setImageAndTitleCenter:(UIButton *)button
{
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(
                                              0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(
                                              - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    // increase the content height to avoid clipping
    CGFloat edgeOffset = fabsf(titleSize.height - imageSize.height) / 2.0;
    button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
}

-(UIImage *)pdfToImage:(NSURL *)sourcePDFUrl
{
    CGPDFDocumentRef SourcePDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)sourcePDFUrl);
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(SourcePDFDocument);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    
    for(int currentPage = 1; currentPage <= numberOfPages; currentPage ++ )
    {
        CGPDFPageRef SourcePDFPage = CGPDFDocumentGetPage(SourcePDFDocument, currentPage);
        // CoreGraphics: MUST retain the Page-Refernce manually
        CGPDFPageRetain(SourcePDFPage);
        
        
        CGRect sourceRect = CGPDFPageGetBoxRect(SourcePDFPage,kCGPDFMediaBox);
        UIGraphicsBeginImageContext(CGSizeMake(sourceRect.size.width,sourceRect.size.height));
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(currentContext, 0.0, sourceRect.size.height); //596,842 //640×960,
        CGContextScaleCTM(currentContext, 1.0, -1.0);
        CGContextDrawPDFPage (currentContext, SourcePDFPage); // draws the page in the graphics context
        
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    return nil;
}

- (void) exportImpl:(NSString *)reportName
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *csvFileName = [NSString stringWithFormat:@"%@.csv",reportName];
    NSString *csvPath = [documentsDir stringByAppendingPathComponent:csvFileName];
    
    
    [self exportCsv: csvPath];
    
    
    // mail is graphical and must be run on UI thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self mail:csvPath mailSubject:reportName];
    });
}

- (void) mail: (NSString*) filePath mailSubject:(NSString *)mailSubject
{
    [self removeOverlayViews];
    BOOL success = NO;
    if ([MFMailComposeViewController canSendMail]) {
        // TODO: autorelease pool needed ?
        NSData* database = [NSData dataWithContentsOfFile: filePath];
        
        if (database != nil) {
            MFMailComposeViewController* picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            [picker setSubject:mailSubject];
            
            NSString* filename = [filePath lastPathComponent];
            [picker addAttachmentData: database mimeType:@"application/octet-stream" fileName: filename];
            NSString* emailBody = @"";
            [picker setMessageBody:emailBody isHTML:YES];
            
            
            [self presentViewController:picker animated:YES completion:nil];
            success = YES;
        }
    }
    
    if (!success)
    {
        NSString *title = @"Error";
        NSString *message = @"Unable to send attachment!";
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        
        NSMutableAttributedString *attrStringTitle = [[NSMutableAttributedString alloc] initWithString:title];
        [attrStringTitle addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"Prompt-SemiBold" size:17]
                                range:NSMakeRange(0, title.length)];
        [alert setValue:attrStringTitle forKey:@"attributedTitle"];
        [attrStringTitle addAttribute:NSForegroundColorAttributeName
                                value:cSystem4
                                range:NSMakeRange(0, title.length)];
        
        
        NSMutableAttributedString *attrStringMsg = [[NSMutableAttributedString alloc] initWithString:message];
        [attrStringMsg addAttribute:NSFontAttributeName
                              value:[UIFont fontWithName:@"Prompt-Regular" size:15]
                              range:NSMakeRange(0, message.length)];
        [attrStringMsg addAttribute:NSForegroundColorAttributeName
                                value:cSystem4
                                range:NSMakeRange(0, message.length)];
        [alert setValue:attrStringMsg forKey:@"attributedMessage"];
        
        
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                              }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
        UIColor *color = cSystem1;
        NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"OK" attributes:attribute];
        
        UILabel *label = [[defaultAction valueForKey:@"__representer"] valueForKey:@"label"];
        label.attributedText = attrString;
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) exportCsv: (NSString*) filename
{
    [self createTempFile: filename];
}

-(void) createTempFile: (NSString*) filename {
    NSFileManager* fileSystem = [NSFileManager defaultManager];
    [fileSystem removeItemAtPath: filename error: nil];
    
    NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
    NSNumber* permission = [NSNumber numberWithLong: 0640];
    [attributes setObject: permission forKey: NSFilePosixPermissions];
    if (![fileSystem createFileAtPath: filename contents: nil attributes: attributes]) {
        NSLog(@"Unable to create temp file for exporting CSV.");
        NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
        // TODO: UIAlertView?
    }
}

- (void) orientationChanged:(NSNotification *)note
{  
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            break;
            
        default:
            break;
    };
}

-(void)makeBottomRightRoundedCorner:(UIView *)view
{
    // Create the path (with only the top-left corner rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(100.0, 100.0)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    view.layer.mask = maskLayer;
}

-(void)showStatus:(NSString *)status
{
    [_lblStatus setFont:[UIFont fontWithName:@"Prompt-Regular" size:14]];
    [_lblStatus setText:@"กำลังพิมพ์..."];
    [_lblStatus sizeToFit];
    _lblStatus.center = self.view.center;
    CGRect frame = _lblStatus.frame;
    frame.origin.y = frame.origin.y+40;
    _lblStatus.frame = frame;
    
    
    
    
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:_lblStatus];
}

-(void)hideStatus
{
    overlayView.backgroundColor = [UIColor colorWithRed:256 green:256 blue:256 alpha:0];
    [_lblStatus removeFromSuperview];
}

-(NSString *)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    UIWebView *webView = (UIWebView*)aView;
    NSString *heightStr = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    CGRect frameTest = webView.frame;
    frameTest.size.height = [heightStr integerValue];
    webView.frame = frameTest;
    
    
    int height = [heightStr intValue];
    //  CGRect screenRect = [[UIScreen mainScreen] bounds];
    //  CGFloat screenHeight = (self.contentWebView.hidden)?screenRect.size.width:screenRect.size.height;
    CGFloat screenHeight = webView.bounds.size.height;
    int pages = ceil(height / screenHeight);
    
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, webView.bounds, nil);
    CGRect frame = [webView frame];
    for (int i = 0; i < pages; i++) {
        // Check to screenHeight if page draws more than the height of the UIWebView
        if ((i+1) * screenHeight  > height) {
            CGRect f = [webView frame];
            f.size.height -= (((i+1) * screenHeight) - height);
            [webView setFrame: f];
        }
        
        UIGraphicsBeginPDFPage();
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        //      CGContextTranslateCTM(currentContext, 72, 72); // Translate for 1" margins
        
        [[[webView subviews] lastObject] setContentOffset:CGPointMake(0, screenHeight * i) animated:NO];
        [webView.layer renderInContext:currentContext];
    }
    
    UIGraphicsEndPDFContext();
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    [webView setFrame:frame];
    
    
    
    return documentDirectoryFilename;
    //    [self removeOverlayViews];
}

-(BOOL)inPeriod:(NSInteger)period
{
    NSString *strKeyNameOpen = [NSString stringWithFormat:@"shift%ldOpenTime",period];
    NSString *strKeyNameClose = [NSString stringWithFormat:@"shift%ldCloseTime",period];
    
    NSString *strShiftOpenTime = [Setting getSettingValueWithKeyName:strKeyNameOpen];
    NSString *strShiftCloseTime = [Setting getSettingValueWithKeyName:strKeyNameClose];
    
    NSInteger intShiftOpenTime = [[strShiftOpenTime stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    NSInteger intShiftCloseTime = [[strShiftCloseTime stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    NSDate *dtShiftOpenTime;
    NSDate *dtShiftCloseTime;
    NSDate *dtShiftOpenTimeMinus30Min;
    NSDate *dtStartNextDay;
    if(intShiftOpenTime <= intShiftCloseTime)
    {
        NSString *strToday = [Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy/MM/dd"];
        dtShiftOpenTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strToday,strShiftOpenTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        dtShiftCloseTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strToday,strShiftCloseTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        dtShiftOpenTimeMinus30Min = [Utility getPrevious30Min:dtShiftOpenTime];
    }
    else
    {
        NSDate *currentDate = [Utility currentDateTime];
        NSDate *nextDay = [Utility getPreviousOrNextDay:1];
        NSDate *yesterday = [Utility getPreviousOrNextDay:-1];
        NSString *strToday = [Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy/MM/dd"];
        NSString *strNextDay = [Utility dateToString:nextDay toFormat:@"yyyy/MM/dd"];
        NSString *strYesterday = [Utility dateToString:yesterday toFormat:@"yyyy/MM/dd"];
        dtStartNextDay = [Utility setStartOfTheDay:nextDay];
        dtShiftOpenTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strToday,strShiftOpenTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        dtShiftOpenTimeMinus30Min = [Utility getPrevious30Min:dtShiftOpenTime];
        NSComparisonResult result = [dtShiftOpenTimeMinus30Min compare:currentDate];
        NSComparisonResult result2 = [currentDate compare:dtStartNextDay];
        BOOL compareResult = (result == NSOrderedAscending || result == NSOrderedSame) && (result2 == NSOrderedAscending || result2 == NSOrderedSame);
        if(compareResult)
        {
            dtShiftCloseTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strNextDay,strShiftCloseTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        }
        else
        {
            dtShiftOpenTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strYesterday,strShiftOpenTime] fromFormat:@"yyyy/MM/dd HH:mm"];
            dtShiftOpenTimeMinus30Min = [Utility getPrevious30Min:dtShiftOpenTime];
            dtShiftCloseTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strToday,strShiftCloseTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        }
    }
    NSDate *currentDate = [Utility currentDateTime];
    NSComparisonResult result = [dtShiftOpenTimeMinus30Min compare:currentDate];
    NSComparisonResult result2 = [currentDate compare:dtShiftCloseTime];
    BOOL compareResult = (result == NSOrderedAscending || result == NSOrderedSame) && (result2 == NSOrderedAscending || result2 == NSOrderedSame);
    
    return compareResult;
}

-(NSString*) deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *iOSDeviceModelsPath = [[NSBundle mainBundle] pathForResource:@"iOSDeviceModelMapping" ofType:@"plist"];
    NSDictionary *iOSDevices = [NSDictionary dictionaryWithContentsOfFile:iOSDeviceModelsPath];
    
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    
    return [iOSDevices valueForKey:deviceModel];
}

- (id)findFirstResponder:(UIView *)view
{
    if (view.isFirstResponder) {
        return view;
    }
    for (UIView *subView in view.subviews) {
        id responder = [self findFirstResponder:subView];//[subView findFirstResponder];
        if (responder) return responder;
    }
    return nil;
}

-(UIImage *) generateQRCodeWithString:(NSString *)string scale:(CGFloat) scale{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding ];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:stringData forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    // Render the image into a CoreGraphics image
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:[filter outputImage] fromRect:[[filter outputImage] extent]];
    
    //Scale the image usign CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake([[filter outputImage] extent].size.width * scale, [filter outputImage].extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *preImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //Cleaning up .
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    // Rotate the image
    UIImage *qrImage = [UIImage imageWithCGImage:[preImage CGImage]
                                           scale:[preImage scale]
                                     orientation:UIImageOrientationDownMirrored];
    return qrImage;
}

-(void)removeMemberData
{
    [Receipt removeAllObjects];
    [OrderTaking removeAllObjects];
    [OrderNote removeAllObjects];
}

-(UIImage *)combineImage:(NSArray *)arrImage
{
    float width = 0;
    float sumHeight = 0;
    if([arrImage count]>0)
    {
        UIImage *image = arrImage[0];
        width = image.size.width;
        for(UIImage *item in arrImage)
        {
            sumHeight += item.size.height;
        }
    }
    CGSize size = CGSizeMake(width, sumHeight);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    float accumHeight = 0;
    for(int i=0; i<[arrImage count]; i++)
    {
        UIImage *image = arrImage[i];
        [image drawInRect:CGRectMake(0,accumHeight,width, image.size.height)];
        accumHeight += image.size.height;
    }
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImage;
}

-(UIImage *)combineImage:(UIImage *)image1 image2:(UIImage *)image2
{
    CGSize size = CGSizeMake(image1.size.width, image1.size.height + image2.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    
    [image1 drawInRect:CGRectMake(0,0,size.width, image1.size.height)];
    [image2 drawInRect:CGRectMake(0,image1.size.height,size.width, image2.size.height)];
    
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

-(UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(NSAttributedString *)setAttributedString:(NSString *)title text:(NSString *)text
{
    if(!text || [text isEqualToString:@"0"])
    {
        text = @"";
    }

    UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:14.0f];
    UIColor *color = cSystem4;
    NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title attributes:attribute];
    
    

    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:14.0f];
    UIColor *color2 = cSystem4;
    NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:text attributes:attribute2];
    
    
    [attrString appendAttributedString:attrString2];
    
    return attrString;
}

-(void)reloadTableView
{
    
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}
@end

