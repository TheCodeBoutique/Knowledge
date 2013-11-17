//
//  KWSignupViewController.m
//  Knowledge
//
//  Created by Kyle Carriedo on 11/15/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import "KWSignupViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
@interface KWSignupViewController ()
{
    MBProgressHUD *hud;
}
@end

@implementation KWSignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[[self containerView] layer] setBorderWidth:1/[[UIScreen mainScreen] scale]];
    [[[self containerView] layer] setCornerRadius:5.0f];
    [[[self containerView] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self createBorders];
}

-(IBAction)createNewUser:(id)sender
{
    hud = [MBProgressHUD showHUDAddedTo:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud show:YES];
    [hud setLabelText:NSLocalizedString(@"Creating Account...", @"Creating Account...")];
    
    PFUser *user = [PFUser user];
    user.username = [[self emailField] text];
    user.password = [[self passwordField] text];
    user.email = [[self emailField] text];
    
    // other fields can be set just like with PFObject
    user[@"zipcode"] = [[self zipcodeField] text];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [hud hide:YES];
        } else {
            [hud hide:YES];
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Account Error"
                                                          message:errorString
                                                         delegate:nil
                                                cancelButtonTitle:@"close"
                                                otherButtonTitles:nil, nil];
        
        [message show];
        }
    }];
}

-(void)createBorders
{
    CALayer *border = [CALayer layer];
    CALayer *border1 = [CALayer layer];
    
    border.frame = [self borderFrame:_emailField];
    border.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    border1.frame = [self borderFrame:_passwordField];
    border1.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    [self.containerView.layer addSublayer: border];
    [self.containerView.layer addSublayer: border1];
}

-(CGRect)borderFrame:(UITextField *)textField
{
    NSLog(@"Pt %f",1/[[UIScreen mainScreen] scale]);
    return CGRectMake(10,CGRectGetMaxY(textField.frame) - 1/[[UIScreen mainScreen] scale], CGRectGetWidth([_containerView frame]) - 10, 1/[[UIScreen mainScreen] scale]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
