//
//  KWCreatePostViewController.m
//  Knowledge
//
//  Created by Kyle Carriedo on 11/16/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import "KWCreatePostViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

@interface KWCreatePostViewController () {
    MBProgressHUD *hud;
    PFObject *post;
}

@end

@implementation KWCreatePostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)createNewPost:(id)sender
{   hud = [MBProgressHUD showHUDAddedTo:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud show:YES];
    [hud setLabelText:NSLocalizedString(@"Creating post...", @"Creating post...")];
    
    post = [PFObject objectWithClassName:@"Post"];
    PFUser *currentUser = [PFUser currentUser];
    post[@"title"] = [[self titleField] text];
    post[@"message"] = [[self messageView] text];
    post[@"user_name"] = currentUser;
    post[@"like"] = [NSNumber numberWithInt:1];
    post[@"dislike"] = [NSNumber numberWithInt:0];
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            // do something with the new geoPoint
            post[@"geo_location"] = geoPoint;
            [self savePost];
        }
    }];
}

-(void)savePost
{
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            [hud hide:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        else
        {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Post Error"
                                                              message:errorString
                                                             delegate:nil
                                                    cancelButtonTitle:@"close"
                                                    otherButtonTitles:nil, nil];
            
            [message show];
        }
    }];

}
- (IBAction)cancelPost:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapView:(UITapGestureRecognizer *)sender {
    [[self view] endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Tell Us"];
    [[self messageView] setPlaceholder:@"Drop some knowledge"];
    
    [[self titleField] setIndent:7.0f];
    
    [self drawoutBorders];
}

-(void)drawoutBorders
{
    [[[self titleBar] layer] setBorderWidth:1/[[UIScreen mainScreen] scale]];
    [[[self titleBar] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [[[self messageBar] layer] setBorderWidth:1/[[UIScreen mainScreen] scale]];
    [[[self messageBar] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [[[self actionItemBar] layer] setBorderWidth:1/[[UIScreen mainScreen] scale]];
    [[[self actionItemBar] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    
    [[[self messageView] layer] setBorderWidth:1/[[UIScreen mainScreen] scale]];
    [[[self messageView] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    
    [[[self titleField] layer] setBorderWidth:1/[[UIScreen mainScreen] scale]];
    [[[self titleField] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
