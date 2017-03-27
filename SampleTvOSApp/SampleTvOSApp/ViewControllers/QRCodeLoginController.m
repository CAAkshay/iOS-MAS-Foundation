//
//  QRCodeLoginController.m
//  SampleTvOSApp
//
//  Created by Akshay on 07/03/17.
//  Copyright © 2017 CA. All rights reserved.
//

#import "QRCodeLoginController.h"
#import "ViewControllerMovie.h"
@interface QRCodeLoginController ()

@end

@implementation QRCodeLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgView.image=nil;
    //proximity
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAuthorizationCode:) name:MASDeviceDidReceiveAuthorizationCodeFromProximityLoginNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(masProximityLogin:)
                                                 name:@"MASDeviceDidReceiveAuthorizationCodeFromProximityLoginNotification"
                                               object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userAuthenticated:)
                                                 name:@"MASUserDidAuthenticateNotification"
                                               object:nil];
    [self QRcodeLogin];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma -QR Code Login

-(void) QRcodeLogin
{
    
    [SVProgressHUD showWithStatus:@"Wait..."];
    
    [MAS startWithDefaultConfiguration:YES completion:^(BOOL completed, NSError * _Nullable error) {
        //
        
        [MASAuthenticationProviders retrieveAuthenticationProvidersWithCompletion:^(id  _Nullable object, NSError * _Nullable error) {
            MASAuthenticationProvider *qrCodeAuthProvider;
            
            for (MASAuthenticationProvider *qr in [object valueForKey:@"providers"]) {
                if ([qr.identifier  isEqualToString:@"qrcode"]) {
                    qrCodeAuthProvider = qr;
                    break;
                }
            }
            
            
          //  [MASDevice setProximityLoginDelegate:self];
            
            self.qrCodeProximityLogin = [[MASProximityLoginQRCode alloc] initWithAuthenticationProvider:qrCodeAuthProvider];
            
            
            UIImage *qrCodeImage = [self.qrCodeProximityLogin startDisplayingQRCodeImageForProximityLogin];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imgView setImage:qrCodeImage];
                
                [SVProgressHUD dismiss];
                [self.lblMessage setText:@"Please Scan This QRCode"];
                
            });
            NSLog(@"------%@", qrCodeImage);
        }];
    }];
    
    
    
}

-(void)masProximityLogin:(NSNotification*)notification
{
    if (notification) {
        
        
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"MAS Proximity Login"
                                                                                 message:@"The session was shared successfully!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        // Construct Grant action
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Continue"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action){
                                 
                                 ViewControllerMovie *movieVC = (id)[self.storyboard instantiateViewControllerWithIdentifier:@"MovieViewController"];
                                 
                                 [self presentViewController:movieVC animated:YES completion:nil];
                                 

                                }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:nil];       // Add grant action
        
        
        
        [alertController addAction:ok];
        
        
        // Add deny action
        [alertController addAction:cancel];
        // Present Alert
        [self presentViewController:alertController animated:YES completion:nil];
        
        //
    }
    
}
-(void)didReceiveAuthorizationCode:(NSString *_Nonnull)authorizationCode
{
    
    if(authorizationCode)
    {
        [SVProgressHUD dismiss];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"MAS Proximity Login"
                                                                                 message:@"The session was shared successfully!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        // Construct Grant action
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Continue"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action){
                                 
                                 ViewControllerMovie *movieVC = (id)[self.storyboard instantiateViewControllerWithIdentifier:@"MovieViewController"];
                                 
                                 [self presentViewController:movieVC animated:YES completion:nil];
                                 
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:nil];       // Add grant action
        
        
        
        [alertController addAction:ok];
        
        
        // Add deny action
        [alertController addAction:cancel];
        // Present Alert
        [self presentViewController:alertController animated:YES completion:nil];
        
        //
    }
    
    
}

-(void)userAuthenticated:(NSNotification*)notification
{
    if (notification) {
        //
    }
}

- (IBAction)clkLogout:(id)sender {
     [SVProgressHUD dismiss];
    
        [[MASUser currentUser] logoutWithCompletion:^(BOOL completed, NSError *error)
        {
            if(!error)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
     [self.qrCodeProximityLogin stopDisplayingQRCodeImageForProximityLogin];
    
    self.imgView.image=nil;
   
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end