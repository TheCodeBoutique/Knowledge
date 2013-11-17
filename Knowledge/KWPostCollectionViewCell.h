//
//  KWPostCollectionViewCell.h
//  Knowledge
//
//  Created by Kyle Carriedo on 11/16/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
@protocol KWPostCollectionViewCellDelegate;

@interface KWPostCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *postTitle;
@property (strong, nonatomic) IBOutlet UITextView *postMessage;
@property (strong, nonatomic) IBOutlet UILabel *totalLike;

@property (strong, nonatomic) IBOutlet UIView *postActionBar;
@property (strong, nonatomic) IBOutlet UIView *postTitleBar;

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFObject *post;

@property (nonatomic, weak) id <KWPostCollectionViewCellDelegate> delgate;

- (IBAction)likePost:(id)sender;
- (IBAction)dislikePost:(id)sender;
- (IBAction)createComment:(id)sender;

+(CGSize)sizeForCell:(NSString *)message;
@end

@protocol KWPostCollectionViewCellDelegate <NSObject>
-(void)likeUpdatedForPost:(PFObject *)postObject withCell:(KWPostCollectionViewCell *)cell;
@end