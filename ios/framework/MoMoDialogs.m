//
//  MoMoDialogs.m
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 7/25/17.
//  Copyright © 2017 LuuLanh. All rights reserved.
//  Last updated: 08/17/2017
//

#import "MoMoDialogs.h"
#import "MoMoConfig.h"
#import "MoMoPayment.h"
typedef enum {
    MoMoWebDialogResultDialogCompleted,
    MoMoWebDialogResultDialogNotCompleted
} MoMoWebDialogResult;

typedef void (^MoMoWebDialogHandler)(
MoMoWebDialogResult result,
NSURL *resultURL,
NSError *error);

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height)
#define SERVICE_NOT_AVAILABLE @"Service is not available at this time"
@interface MoMoDialogs(){
    UIView *mainView;
    UIActivityIndicatorView *activity;
    UIWebView *webview1;
    UIWebView *webview2;
    UILabel *lbl_url;
    UILabel *lbl_error;
    BOOL pageLoading;
    UIImageView *imgF5;
    UIButton *btnF5;
    MoMoWebDialogHandler mainhandler;
    UIViewController *parentView;
    NSString *happyStyle;
    UIButton *btnDimiss;
}
    
    @end

@implementation MoMoDialogs
- (void)viewDidLoad
    {
        
    }
    
-(id)init{
    NSLog(@"MoMoDialogs init");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationCenterPresentMoMoWebDialog:) name:@"NotificationCenterPresentMoMoWebDialog" object:nil];
    [self openWebView];
    return self;
}
    
-(id)initWithParentView:(id)view{
    if ([parentView isKindOfClass:[UIViewController class]]) {
        parentView = view;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationCenterPresentMoMoWebDialog:) name:@"NotificationCenterPresentMoMoWebDialog" object:nil];
    [self openWebView];
    return self;
}
    
-(UIColor*)colorWithHexString:(NSString*)hex
    {
        NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        
        // String should be 6 or 8 characters
        if ([cString length] < 6) return [UIColor grayColor];
        
        // strip 0X if it appears
        if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
        
        if ([cString length] != 6) return  [UIColor grayColor];
        
        // Separate into r, g, b substrings
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *rString = [cString substringWithRange:range];
        
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        // Scan values
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:1.0f];
    }
-(void)openWebView{
    happyStyle = @"";
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-70)];
    [mainView setBackgroundColor:[self colorWithHexString:@"325340"]];
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width - 20, 25)];
    labelView.tag = 2;
    labelView.backgroundColor = [UIColor clearColor];
    
    lbl_url = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, labelView.frame.size.width-35 , 27)];
    lbl_url.text = @"";
    lbl_url.textColor = [UIColor lightGrayColor];
    lbl_url.font = [UIFont systemFontOfSize:16];
    lbl_url.layer.cornerRadius = 3;
    lbl_url.clipsToBounds = YES;
    lbl_url.textAlignment = NSTextAlignmentCenter;
    [lbl_url setBackgroundColor:[self colorWithHexString:@"396049"]];
    [labelView addSubview:lbl_url];
    
    
    UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake(40, 22, 24, 24)];
    [locked setImage:[UIImage imageNamed:@"momo_lock_symbol"]];
    [labelView addSubview:locked];
    
    
    imgF5 = [[UIImageView alloc] initWithFrame:CGRectMake(labelView.frame.size.width-20, 23, 18, 18)];
    [imgF5 setImage:[UIImage imageNamed:@"ic_reload_press"]];
    [labelView addSubview:imgF5];
    
    [mainView addSubview:labelView];
    
    btnDimiss = [[UIButton alloc] initWithFrame:CGRectMake(5, 35, 25, 25)];
    btnDimiss.tag = 4;
    //    [btnDimiss setTitle:@"Done" forState:UIControlStateNormal];
    [btnDimiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDimiss setBackgroundImage:[UIImage imageNamed:@"momoclose"] forState:UIControlStateNormal];
    [btnDimiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDimiss.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btnDimiss setBackgroundColor:[UIColor clearColor]];
    [btnDimiss addTarget:self action:@selector(dismissDialog) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btnDimiss];
    
    btnF5 = [[UIButton alloc] initWithFrame:CGRectMake(labelView.frame.size.width-20, 32, 40, 30)];
    [btnF5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnF5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnF5.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btnF5 setBackgroundColor:[UIColor clearColor]];
    [btnF5 addTarget:self action:@selector(refreshWebview) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btnF5];
    
    UIView *mainWebView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 40)];
    mainWebView.tag = 4;
    mainWebView.backgroundColor = [UIColor whiteColor];
    
    webview1 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 70)];
    webview1.tag = 5;
    webview1.delegate = self;
    [mainWebView addSubview:webview1];
    
    webview2 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 70)];
    webview2.hidden = YES;
    webview2.tag = 6;
    webview2.delegate = self;
    [mainWebView addSubview:webview2];
    
    lbl_error = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelView.frame.size.width-20 , 60)];
    lbl_error.tag = 7;
    lbl_error.hidden = YES;
    lbl_error.text = @"";
    lbl_error.numberOfLines = 0;
    lbl_error.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    lbl_error.textColor = [UIColor grayColor];
    lbl_error.font = [UIFont systemFontOfSize:16];
    lbl_error.textAlignment = NSTextAlignmentCenter;
    [lbl_error setBackgroundColor:[UIColor clearColor]];
    lbl_error.center = mainView.center;
    [mainWebView addSubview:lbl_error];
    
    [mainView addSubview:mainWebView];
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.tag = 8;
    [mainView addSubview:activity];
    activity.center = mainView.center;
    [activity startAnimating];
    
    self.view = mainView;
}
-(void)dismissDialog{
    if (webview2.hidden) {
        NSLog(@"dismissDialog");
        NSMutableDictionary *obj = [[MoMoPayment shareInstant] getPaymentInfo];
        [[MoMoPayment shareInstant] requestWebpaymentData:obj requestType:@"close"];
        [self sendNoficationCenterTokenReceivedWithUri:@"https://payment.momo.vn/callbacksdk?fromapp=momotransfer&phonenumber=&status=4&message=Huỷ yêu cầu thanh toán."];
    }
    else{
        //Reload web MoMo Payment
        NSLog(@"dimissIBWebview");
        [self dimissIBWebview];
    }
    
}
-(void)showLoadingActivity{
    if(!activity){
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [mainView addSubview:activity];
    }
    activity.center = mainView.center;
    [activity startAnimating];
}
    
-(void)removeMe{
    if ([self isKindOfClass:[MoMoDialogs class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
    
-(void)showErrorMessage:(NSString*)message{
    if(!lbl_error){
        lbl_error = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, SCREEN_WIDTH - 60, 60)];
        lbl_error.numberOfLines = 0;
        lbl_error.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        [mainView addSubview:lbl_error];
    }
    lbl_error.center = mainView.center;
    lbl_error.text = message;
    lbl_error.font = [UIFont systemFontOfSize:18];
}
    
- (void) hideActivityIndicator{
    if(activity){
        [activity stopAnimating];
        [activity removeFromSuperview];
    }
    
}
    
- (NSData*)dataUsingUTF8Encode:(NSDictionary*)dictionary
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
-(void)refreshWebview{
    if (webview1.hidden) {
        [webview2 reload];
    }
    [webview1 reload];
    [self pageLoading];
    
}
    
-(void)pageLoading{
    [imgF5 setImage:[UIImage imageNamed:@"momo_ic_reload_press"]];
    [activity startAnimating];
}
-(void)pageLoadFinish{
    [imgF5 setImage:[UIImage imageNamed:@"momo_ic_reload"]];
    [activity stopAnimating];
    if (webview1.request.URL.absoluteString == nil || [webview1.request.URL.absoluteString isEqualToString:@""]) {
        [imgF5 setImage:[UIImage imageNamed:@""]];
    }
}
    
- (NSString*) stringForCStr:(const char *) cstr{
    if(cstr){
        return [NSString stringWithCString: cstr encoding: NSUTF8StringEncoding];
    }
    return @"";
}
-(NSDictionary*) getDictionaryFromComponents:(NSArray *)components{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    // parse parameters to dictionary
    for (NSString *param in components) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        // get key, value
        NSString* key   = [elts objectAtIndex:0];
        key = [key stringByReplacingOccurrencesOfString:@"?" withString:@""];
        NSString* value = [elts objectAtIndex:1];
        
        ///Start Fix HTML Property issue
        if ([elts count]>2) {
            @try {
                value = [param substringFromIndex:([param rangeOfString:@"="].location+1)];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
        ///End HTML Property issue
        if(value){
            value = [self stringForCStr:[value UTF8String]];
        }
        
        //
        if(key.length && value.length){
            [params setObject:value forKey:key];
        }
    }
    return params;
}
    
#pragma mark - Open url
    
#define stringIndexOfString(fulltext, textcompare) ([fulltext rangeOfString: textcompare ].location != NSNotFound)

- (void) getNewStyle:(NSString*)keys
{
    if (keys && keys.length) {
        happyStyle = @"";
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:keys]];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            if ([data length] > 0 && error == nil){
                happyStyle = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@">>happyStyle %@",happyStyle);
            }
            else{
                happyStyle = @"";
            }
            
        }];
    }
    
}

///update for Internetbanking
-(void)loadInternetBanking:(NSString*)baseURI{
    NSLog(@"redirect IB");
    NSArray *arr = [baseURI componentsSeparatedByString:@"?"];
    NSString *query = [arr objectAtIndex:1];
    
    NSArray *components = [query componentsSeparatedByString:@"&"];
    
    NSDictionary *params = [self getDictionaryFromComponents:components];
    if (params[@"bankUrl"] && params[@"bankScript"]) {
        [btnDimiss setBackgroundImage:[UIImage imageNamed:@"momo_back"] forState:UIControlStateNormal];
        
        webview1.hidden = YES;
        webview2.hidden = NO;
        [webview2 stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
        
        webview2.accessibilityValue = params[@"bankScript"];
        
        [self getNewStyle:params[@"bankScript"]];
        
        NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString:params[@"bankUrl"]]
                                                 cachePolicy: NSURLRequestReloadRevalidatingCacheData
                                             timeoutInterval: 60];
        
        [webview2 loadRequest: request];

    }
}
-(void)invokeStyleSheet{
    if (happyStyle && happyStyle.length) {
        [webview2 stringByEvaluatingJavaScriptFromString:happyStyle];
        
    }
    else{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:webview2.accessibilityValue]];
        NSString *style = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [webview2 stringByEvaluatingJavaScriptFromString:style];
    }
}
    
-(void)showBackButton{
    btnDimiss.hidden = NO;
}
    
-(void)dimissIBWebview{
    webview1.hidden = NO;
    webview2.hidden = YES;
    [btnDimiss setBackgroundImage:[UIImage imageNamed:@"momoclose"] forState:UIControlStateNormal];
    btnDimiss.hidden = YES;
    [self performSelector:@selector(showBackButton) withObject:nil afterDelay:2];
    [self refreshWebview];
}
    ///end update Internetbanking
    
    
- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self pageLoadFinish];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //NSLog(@">>load url %@",request.URL.absoluteString);
    
    ///update for IB
    if ([request.URL.absoluteString hasPrefix:@"itms-apps://"]){
        return YES;
    }
    
    if (webView.tag == 5) {
        if (![request.URL.absoluteString hasPrefix:@"https://"] && ![request.URL.absoluteString hasPrefix:@"http://"]) {
            [self loadInternetBanking:request.URL.absoluteString];
            return NO;
        }
    }else if (webView.tag == 6){
        if ([request.URL.absoluteString hasPrefix:@"close://"]) {
            webview1.hidden = NO;
            webview2.hidden = YES;
            
            [self refreshWebview];
            return NO;
        }
    }
    
    ///end update IB
    

    [self pageLoading];
    if (stringIndexOfString(request.URL.absoluteString,@"payment.momo.vn/callbacksdk") || [request.URL.absoluteString hasPrefix:@"https://payment.momo.vn/callbacksdk"]) {
         [self sendNoficationCenterTokenReceivedWithUri:request.URL.absoluteString];
    }
    
    lbl_url.text =[NSString stringWithFormat:@"%@://%@",request.URL.scheme,request.URL.host];
    
    return YES;
}
-(void) webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidFinishLoad");
    if (webView.tag ==6 ) {
        [self performSelectorOnMainThread:@selector(invokeStyleSheet) withObject:nil waitUntilDone:YES];
    }
    [self pageLoadFinish];
}
    
    // ------------ ByPass ssl starts ----------
-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:
(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust];
}
    
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:
(NSURLAuthenticationChallenge *)challenge {
    if (([challenge.protectionSpace.authenticationMethod
          isEqualToString:NSURLAuthenticationMethodServerTrust])) {
        //        if ([challenge.protectionSpace.host isEqualToString:TRUSTED_HOST]) {
        //            NSLog(@"Allowing bypass...");
        //            NSURLCredential *credential = [NSURLCredential credentialForTrust:
        //                                           challenge.protectionSpace.serverTrust];
        //            [challenge.sender useCredential:credential
        //                 forAuthenticationChallenge:challenge];
        //        }
        NSLog(@"Allowing TrustHost...");
        NSURLCredential *credential = [NSURLCredential credentialForTrust:
                                       challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential
             forAuthenticationChallenge:challenge];
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
    // -------------------ByPass ssl ends
    
    
    
-(void)NotificationCenterPresentMoMoWebDialog:(NSNotification*)notif{
    lbl_error.text = @"";
    if ([notif.object isKindOfClass:[NSDictionary class]]) {
        
        if ([notif.object objectForKey:@"code"] && [[notif.object objectForKey:@"code"] intValue] ==0 ){
            NSString *url = [notif.object objectForKey:@"url"];
            if (url) {
                NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString:url]
                                                         cachePolicy: NSURLRequestReloadRevalidatingCacheData
                                                     timeoutInterval: 60];
                [webview1 loadRequest: request];

            }
            
        }
        else if ([notif.object objectForKey:@"code"] && [[notif.object objectForKey:@"code"] intValue] == 9696 ){
            [self removeMe];
        }
        else{
            if (notif.object[@"message"]) {
                lbl_error.text = [NSString stringWithFormat:@"%@",notif.object[@"message"]];
            }
            else{
                lbl_error.text = SERVICE_NOT_AVAILABLE;
            }
            //NSLog(@">>error %@",[notif.object objectForKey:@"message"]);
            webview1.hidden = YES;
            lbl_error.hidden = NO;
            [self pageLoadFinish ];
        }
        
    }
    else{
        NSLog(@">>error %@",notif.object);
        lbl_error.text = SERVICE_NOT_AVAILABLE;
        webview1.hidden = YES;
        lbl_error.hidden = NO;
        [self pageLoadFinish ];
    }
}
-(void)sendNoficationCenterTokenReceivedWithUri:(NSString*)uri{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoficationCenterTokenReceived" object:uri];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationCenterPresentMoMoWebDialog" object:nil];
}
@end
