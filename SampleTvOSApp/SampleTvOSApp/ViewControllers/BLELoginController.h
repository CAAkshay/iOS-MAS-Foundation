//
//  BLELoginController.h
//  SampleTvOSApp
//
//  Created by Akshay on 07/03/17.
//  Copyright © 2017 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <tvOS_MASFoundation/tvOS_MASFoundation.h>
#import <SVProgressHUDTVOS/SVProgressHUD.h>
@interface BLELoginController : UIViewController<MASProximityLoginDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
- (IBAction)clkLogout:(id)sender;

@end