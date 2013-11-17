//
//  KWSignupViewController.h
//  Knowledge
//
//  Created by Kyle Carriedo on 11/13/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWSigninViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView *signupContainerView;

- (IBAction)loginAccount:(id)sender;
@end
