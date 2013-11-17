//
//  KWCreatePostViewController.h
//  Knowledge
//
//  Created by Kyle Carriedo on 11/16/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWMessageTextView.h"
#import "KWTextField.h"

@interface KWCreatePostViewController : UIViewController
@property (strong, nonatomic) IBOutlet KWMessageTextView *messageView;
@property (strong, nonatomic) IBOutlet KWTextField *titleField;
@property (strong, nonatomic) IBOutlet UIView *titleBar;
@property (strong, nonatomic) IBOutlet UIView *messageBar;
@property (strong, nonatomic) IBOutlet UIView *actionItemBar;

@end
