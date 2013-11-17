//
//  KWTextField.m
//  Knowledge
//
//  Created by Kyle Carriedo on 11/16/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import "KWTextField.h"

@implementation KWTextField

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}
-(void)awakeFromNib
{
    
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    [super textRectForBounds:bounds];
    bounds.origin.x = _indent;
    return bounds;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    [super placeholderRectForBounds:bounds];
    bounds.origin.x = _indent;
    return  bounds;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
