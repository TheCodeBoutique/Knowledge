//
//  KWViewController.m
//  Knowledge
//
//  Created by Kyle Carriedo on 11/13/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//
#import <Parse/Parse.h>
#import "KWViewController.h"
#import "KWPostListsViewController.h"
#import "KWQueries.h"
#import "MBProgressHUD.h"

@interface KWViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) IBOutlet UIView *barrier;
@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation KWViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addAnimationEffect];
}

-(IBAction)loginWithTwitter
{
    _hud = [MBProgressHUD showHUDAddedTo:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] animated:YES];
    [_hud setMode:MBProgressHUDModeIndeterminate];
    [_hud show:YES];
    [_hud setLabelText:NSLocalizedString(@"Logining in...", @"Logining in...")];
    
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [self showPostlistViewController];
        } else {
            NSLog(@"User logged in with Twitter!");
            [self showPostlistViewController];

//            [self fetchUserDataFromTwitter]; //fetches user data not used right now
        }     
    }];
}
-(void)showPostlistViewController
{
    //run query anf fetch 25 posts
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    KWPostListsViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"KWPostListsViewController"];
    [[lvc navigationItem] setHidesBackButton:YES];
    [self.navigationController pushViewController:lvc animated:YES];
    [_hud hide:YES];
}

-(void)fetchUserDataFromTwitter
{
    NSURL *verify = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
    [[PFTwitterUtils twitter] signRequest:request];
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:nil];
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:nil];
    NSLog(@"Twitter %@",json);
}



#pragma mark Animation
-(void)addAnimationEffect
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior* gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.logo]];
    [self.animator addBehavior:gravityBehavior];
    
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.logo]];
    elasticityBehavior.elasticity = 0.7f;
    [self.animator addBehavior:elasticityBehavior];
    
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.logo, self.barrier]];
    
    // add a boundary that coincides with the top edge
    CGPoint rightEdge = CGPointMake(_barrier.frame.origin.x +
                                    _barrier.frame.size.width, _barrier.frame.origin.y);
    [collisionBehavior addBoundaryWithIdentifier:@"barrier"
                                       fromPoint:_barrier.frame.origin
                                         toPoint:rightEdge];
    
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collisionBehavior];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
