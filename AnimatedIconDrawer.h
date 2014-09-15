//
//  AnimatedIconDrawer.h
//  CA Learning
//
//  Created by Dave Loftis on 9/14/14.
//  Copyright (c) 2014 Dave Loftis. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface AnimatedIconDrawer : CALayer

@property (nonatomic, copy) NSArray *elements;
@property (nonatomic) CGPoint grid;
@property (nonatomic) CGPoint size;

+(AnimatedIconDrawer *)initWithOriginLayoutAndElements:(CGPoint)origin layout:(CGPoint)layout elements:(NSArray *)elements;
-(NSInteger)toggleOpenCloseWithTappedLayer:(CALayer *)layer;


@end
