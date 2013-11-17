//
//  KWSignupViewController.h
//  Knowledge
//
//  Created by Kyle Carriedo on 11/15/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWSignupViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *zipcodeField;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end
