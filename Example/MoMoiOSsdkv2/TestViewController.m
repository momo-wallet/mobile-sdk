//
//  TestViewController.m
//  MoMoiOSsdkv2
//
//  Created by momodevelopment on 11/24/2017.
//  Copyright (c) 2017 momodevelopment. All rights reserved.
//

#import "TestViewController.h"
#import "MoMoPayment.h"
#import "MoMoConfig.h"
@interface TestViewController ()
{
    UILabel *lblMessage;
    UILocalNotification *noti;
    UITextField *txtAmount;

}
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NoficationCenterTokenStartRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoficationCenterTokenStartRequest:) name:@"NoficationCenterTokenStartRequest" object:nil]; ///SHOULD BE REMOVE THIS KEY WHEN VIEWCONTROLLER DEALLOCATING OR DISMISSING COMPLETED
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NoficationCenterTokenReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoficationCenterTokenReceived:) name:@"NoficationCenterTokenReceived" object:nil];
    
    [[MoMoPayment shareInstances] initAppBundleId:@"com.abcFoody.LuckyLuck" partnerCode:@"CGV01" partnerName:@"CGV" partnerNameLabel:@"Nhà cung cấp" billLabel:@"Mã thanh toán"];
    ///
    [self initOrderAndButtonAction];
}

-(void)viewWillAppear:(BOOL)animated
{
    lblMessage.text = @"{MoMo Response}";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString*) stringForCStr:(const char *) cstr{
    if(cstr){
        return [NSString stringWithCString: cstr encoding: NSUTF8StringEncoding];
    }
    return @"";
}

-(NSMutableDictionary*) getDictionaryFromComponents:(NSArray *)components{
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

-(void)processMoMoNoficationCenterTokenReceived:(NSNotification*)notif{
    
    //Token Replied
    NSLog(@"::MoMoPay Log::Received Token Replied::%@",notif.object);
    lblMessage.text = [NSString stringWithFormat:@"%@",notif.object];
    
    NSString *sourceText = [NSString stringWithFormat:@"%@",notif.object];
    
    NSURL *url = [NSURL URLWithString:sourceText];
    if (url) {
        sourceText = url.query;
    }
    
    NSArray *parameters = [sourceText componentsSeparatedByString:@"&"];
    
    NSDictionary *response = [self getDictionaryFromComponents:parameters];
    NSString *status = [NSString stringWithFormat:@"%@",[response objectForKey:@"status"]];
    NSString *message = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
    if ([status isEqualToString:@"0"]) {
        
        NSLog(@"::MoMoPay Log: SUCESS TOKEN.");
        
        
        NSString *data = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];//session data
        NSString *phoneNumber =  [NSString stringWithFormat:@"%@",[response objectForKey:@"phonenumber"]];//wallet Id
        NSLog(@">>response::phoneNumber %@ , data:: %@",phoneNumber, data);
        NSString *env = @"app";
        if (response[@"env"]) {
            env =  [NSString stringWithFormat:@"%@",[response objectForKey:@"env"]];
        }
        
        if (response[@"extra"]) {
            //Decode base 64 for using
            
        }
        
        lblMessage.text = [NSString stringWithFormat:@">>response:: SUCESS TOKEN. \n %@",notif.object];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Noti"
                                                        message:@"GET TOKEN SUCESS "
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else
    {
        if ([status isEqualToString:@"1"]) {
            NSLog(@"::MoMoPay Log: REGISTER_PHONE_NUMBER_REQUIRE.");
        }
        else if ([status isEqualToString:@"2"]) {
            NSLog(@"::MoMoPay Log: LOGIN_REQUIRE.");
        }
        else if ([status isEqualToString:@"3"]) {
            NSLog(@"::MoMoPay Log: NO_WALLET. You need to cashin to MoMo Wallet ");
        }
        else
        {
            NSLog(@"::MoMoPay Log: %@",message);
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Noti"
                                                        message: [ NSString stringWithFormat:@"GET TOKEN FAIL::%@",message]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)NoficationCenterTokenReceived:(NSNotification*)notif
{
   [self processMoMoNoficationCenterTokenReceived:notif];
}
/*
 //SDK v.2.2
 //Dated: 7/25/17.
 */
-(void)NoficationCenterTokenStartRequest:(NSNotification*)notif
{
    if (notif.object != nil && [notif.object isEqualToString:@"InProgress"]) {
        NSLog(@"::MoMoPay Log::InProgress");
    }else if (notif.object != nil && [notif.object isEqualToString:@"AppMoMoNotInstall"]) {
        NSLog(@"::MoMoPay Log::AppMoMoNotInstall");
    }else{
        NSLog(@"::MoMoPay Log::AppMoMoInstalled");
    }
}
-(void)initOrderAndButtonAction{
    //Code của bạn
    UIView *paymentArea = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 300, 300)];
    [paymentArea setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imgMoMo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [imgMoMo setImage:[UIImage imageNamed:@"momo.png"]];
    [paymentArea addSubview:imgMoMo];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 30)];
    lbl.text = @"DEVELOPMENT ENVIRONMENT";
    lbl.font = [UIFont systemFontOfSize:13];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [paymentArea addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 200, 30)];
    lbl.text = @"Pay by MoMo Wallet";
    lbl.font = [UIFont systemFontOfSize:13];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [paymentArea addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 100, 30)];
    lbl.text = @"Amount";
    lbl.font = [UIFont systemFontOfSize:13];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [paymentArea addSubview:lbl];
    
    UIButton *btnPay = [[UIButton alloc] initWithFrame:CGRectMake(200, 60, 100, 30)];
    //    btnPay.titleLabel.text = @"Submit";
    [btnPay setTitle:@"Submit" forState:UIControlStateNormal];
    [btnPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    //    [btnPay addTarget:self action:@"" forControlEvents:UIControlEventTouchUpInside];
    btnPay.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnPay setBackgroundColor:[UIColor blueColor]];
    //    [paymentArea addSubview:btnPay];
    
    txtAmount = [[UITextField alloc] initWithFrame:CGRectMake(60, 60, 100, 30)];
    txtAmount.text = @"59000";
    txtAmount.delegate = self;
    txtAmount.enabled = NO;
    txtAmount.placeholder = @"Enter amount...";
    txtAmount.font = [UIFont systemFontOfSize:14];
    [txtAmount setBackgroundColor:[UIColor lightGrayColor]];
    [paymentArea addSubview:txtAmount];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(60, 85, 100, 1)];
    [line setBackgroundColor:[UIColor grayColor]];
    [paymentArea addSubview:line];
    
    lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(60, 90, 300, 200)];
    lblMessage.text = @"{MoMo Response}";
    lblMessage.font = [UIFont systemFontOfSize:15];
    [lblMessage setBackgroundColor:[UIColor clearColor]];
    lblMessage.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    lblMessage.numberOfLines = 0;
    [paymentArea addSubview:lblMessage];
    
    //Tạo button Thanh toán bằng Ví MoMo
    
    //Buoc 1: Khoi tao Payment info, add button MoMoPay
    
    NSMutableDictionary *paymentinfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithInt:99000],@"amount",
                                        [NSNumber numberWithInt:0],@"fee",
                                        @"mua vé xem phim cgv",@"description",
                                        @"{\"key1\":\"value1\",\"key2\":\"value2\"}",@"extra", 
                                        @"vi",@"language",
                                        @"username_accountId@yahoo.com",@"username",
                                        nil];
    
    [paymentinfo setValue:@"partnerSchemeId00001" forKey:@"appScheme"]; //<partnerSchemeId>: app uniqueueId provided by MoMo , get from business.momo.vn. PLEASE MAKE SURE TO ADD <partnerSchemeId> TO PLIST file ( URL types > URL Schemes )
    
    
    //[[MoMoPayment shareInstant] initPayment:paymentinfo  environment:MOMO_SDK_PRODUCTION];
    
    //Development environment (only testing)
    
    [[MoMoPayment shareInstances] initPayment:paymentinfo];
    
    //BUOC 2: add button Thanh toan bang Vi MoMo vao khu vuc ban can hien thi (Vi du o day la vung paymentArea)
    ///Custom button
    [[MoMoPayment shareInstances] addMoMoPayCustomButton:btnPay forControlEvents:UIControlEventTouchUpInside toView:paymentArea];
    
    //Code của bạn
    [self.view addSubview:paymentArea];
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
