//
//  AnimatedIconDrawer.m
//
//  Created by Dave Loftis on 9/14/14.
//  Copyright (c) 2014 Dave Loftis. All rights reserved.
//
//  Contact me:
//      dave.loftis@gmail.com
//      @lofdev
//
//  This repository:
//      https://github.com/lofdev/AnimatedIconDrawer
//

#import <QuartzCore/QuartzCore.h>

static const int AIDOPENS_DOWNRIGHT =   135;
static const int AIDOPENS_DOWNLEFT =    225;
static const int AIDOPENS_UPRIGHT =     45;
static const int AIDOPENS_UPLEFT =      315;

@interface AnimatedIconDrawer : CALayer

@property (nonatomic, copy) NSArray *elements;
@property (nonatomic) CGPoint grid;
@property (nonatomic) NSInteger open_direction;
@property (nonatomic) BOOL is_open;


+(AnimatedIconDrawer *)initWithOriginLayoutDirectionAndElements:(CGPoint)origin layout:(CGPoint)layout direction:(NSInteger)direction elements:(NSArray *)elements;
-(NSInteger)toggleOpenCloseWithTappedLayer:(CALayer *)layer;


@end
