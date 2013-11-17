//
//  KWPostCollectionViewCell.m
//  Knowledge
//
//  Created by Kyle Carriedo on 11/16/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import "KWPostCollectionViewCell.h"
#import "MBProgressHUD.h"

@implementation KWPostCollectionViewCell {
    MBProgressHUD *hud;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self awakeFromNib];
        
    }
    return self;
}

+(CGSize)sizeForCell:(NSString *)message
{
    CGRect rect = [message boundingRectWithSize:CGSizeMake(306.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    return CGSizeMake(306.0f, rect.size.height + 105.0f);
}
-(void)awakeFromNib
{
    [self drawoutBorders];
}

-(void)drawoutBorders
{
    [[[self postActionBar] layer] setBorderWidth:1/[[UIScreen mainScreen] scale]];
    [[[self postActionBar] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [[[self postMessage] layer] setBorderWidth:1/[[UIScreen mainScreen] scale]];
    [[[self postMessage] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [[[self postTitleBar] layer] setBorderWidth:1/[[UIScreen mainScreen] scale]];
    [[[self postTitleBar] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

-(void)prepareForReuse
{
    [super prepareForReuse];
}

- (IBAction)likePost:(id)sender {
    [self showHud];
    int currentCount = [[_post objectForKey:@"like"] intValue];
    currentCount++;
    _post[@"like"] = [NSNumber numberWithInt:currentCount];
    
    [_post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [hud hide:YES];
            [[self totalLike] setText:[NSString stringWithFormat:@"%d",[[_post objectForKey:@"like"] intValue]]];            
            [[self delgate] likeUpdatedForPost:_post withCell:self];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"error string %@",errorString);
        }
    }];    
}

-(void)showHud
{
    hud = [MBProgressHUD showHUDAddedTo:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setLabelText:NSLocalizedString(@"Updating...", @"Updating...")];
    [hud show:YES];
}

- (IBAction)dislikePost:(id)sender {
}

- (IBAction)createComment:(id)sender {
}
@end
