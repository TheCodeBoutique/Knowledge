//
//  KWSignupViewController.m
//  Knowledge
//
//  Created by Kyle Carriedo on 11/13/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import "KWSigninViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
#import <Parse/Parse.h>
#import "KWPostListsViewController.h"
@interface KWSigninViewController (){
    MBProgressHUD *hud;
}

@end

@implementation KWSigninViewController

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
    [[[self signupContainerView] layer] setBorderWidth:1/[[UIScreen mainScreen] scale]];
    [[[self signupContainerView] layer] setCornerRadius:5.0f];
    [[[self signupContainerView] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self createBorders];
}

- (IBAction)loginAccount:(id)sender
{
     hud = [MBProgressHUD showHUDAddedTo:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud show:YES];
    [hud setLabelText:NSLocalizedString(@"Logining in...", @"Logining in...")];
    
    NSString *username = [[self userNameField] text];
    NSString *password = [[self passwordField] text];
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            [self showPostlistViewController];
                                        } else {                                            
                                            [hud hide:YES];
                                            NSString *errorString = [error userInfo][@"error"];
                                             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                          message:errorString
                                                         delegate:nil
                                                cancelButtonTitle:@"close"
                                                otherButtonTitles:nil, nil];
                                            [message show];
                                        }
                                    }];
}

-(void)showPostlistViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    KWPostListsViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"KWPostListsViewController"];
    [[lvc navigationItem] setHidesBackButton:YES];
    [[lvc navigationItem] setTitle:@"Knowledge"];
    [self.navigationController pushViewController:lvc animated:YES];
    [hud hide:YES];
}

-(void)createBorders
{
    CALayer *border = [CALayer layer];
    
    border.frame = [self borderFrame:_userNameField];
    border.backgroundColor = [UIColor lightGrayColor].CGColor;    
    
    [_signupContainerView.layer addSublayer: border];
}

-(CGRect)borderFrame:(UITextField *)textField
{
    NSLog(@"Pt %f",1/[[UIScreen mainScreen] scale]);
    return CGRectMake(10,CGRectGetMaxY(textField.frame) - 1/[[UIScreen mainScreen] scale], CGRectGetWidth([_signupContainerView frame]) - 10, 1/[[UIScreen mainScreen] scale]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
