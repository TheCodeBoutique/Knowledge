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

@interface KWCreatePostViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    MBProgressHUD *hud;
    PFObject *post;
    NSData *imageData;
}

@property (strong, nonatomic) UIDynamicAnimator *animator;
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
{
    hud = [MBProgressHUD showHUDAddedTo:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] animated:YES];
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
            if (imageData) {
                [self uploadImage:imageData];
            }
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

- (IBAction)cameraTapped:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] == YES){
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Show image picker
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }
    else{
        // Device has no camera
        UIImage *image;
        int r = arc4random() % 5;
        switch (r) {
            case 0:
                image = [UIImage imageNamed:@"ParseLogo.jpg"];
                break;
            case 1:
                image = [UIImage imageNamed:@"Crowd.jpg"];
                break;
            case 2:
                image = [UIImage imageNamed:@"Desert.jpg"];
                break;
            case 3:
                image = [UIImage imageNamed:@"Lime.jpg"];
                break;
            case 4:
                image = [UIImage imageNamed:@"Sunflowers.jpg"];
                break;
            default:
                break;
        }
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(640, 960));
        [image drawInRect: CGRectMake(0, 0, 640, 960)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        imageData = UIImageJPEGRepresentation(image, 0.05f);
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:^{
        [self addAnimationEffect];
    }];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _postImage.image = smallImage;
    
    // Upload image
    imageData = UIImageJPEGRepresentation(image, 0.05f);
}

- (void)uploadImage:(NSData *)postImageData
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:postImageData];

    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            [post setObject:imageFile forKey:@"imageFile"];
            
            
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (!error) {
                    [hud hide:YES];
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            [hud hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
//        hud.progress = (float)percentDone/100;
    }];
}


#pragma mark Animation
-(void)addAnimationEffect
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior* gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.postImage]];
    [self.animator addBehavior:gravityBehavior];
    
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.postImage]];
    elasticityBehavior.elasticity = 0.7f;
    [self.animator addBehavior:elasticityBehavior];
    
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.postImage, self.barrier]];
    
    // add a boundary that coincides with the top edge
    CGPoint rightEdge = CGPointMake(_barrier.frame.origin.x +
                                    _barrier.frame.size.width, _barrier.frame.origin.y);
    [collisionBehavior addBoundaryWithIdentifier:@"barrier"
                                       fromPoint:_barrier.frame.origin
                                         toPoint:rightEdge];
    
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collisionBehavior];
}

@end
