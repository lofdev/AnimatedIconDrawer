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

#import "AnimatedIconDrawer.h"

@implementation AnimatedIconDrawer


#pragma mark - Overloadable methods for display metrics

//  Base state for the margin between cells
-(float)margin {
    return 5.0f;
}
//  Base state for the size of the cell - assumes square, and 40.0 for tapping convenience.
-(float)squareSize {
    return 40.0f;
}




#pragma mark - Constructor methods
/*
 *  Constructor method:
 *  ===================
 *  Params:  origin   : (CGPoint) for setting element's frame position on superview
 *           layout   : (CGPoint) number of columns (y) and rows (x)
 *           elements : (NSArray) Array of objects which can be type UIImage or UIColor
 *
 *  Returns an AnimatedIconDrawer
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

+(AnimatedIconDrawer *)initWithOriginLayoutDirectionAndElements:(CGPoint)origin layout:(CGPoint)layout direction:(NSInteger)direction elements:(NSArray *)elements  {

    //  Create the object
    AnimatedIconDrawer *drawer = [[AnimatedIconDrawer alloc] init];
    drawer.grid = layout;
    [drawer setOpenDirection:direction];
    
    //  Draw all the element on a "closed" drawer
    int element_count = [elements count];
    NSMutableArray *setupArray = [[NSMutableArray alloc] initWithCapacity:element_count];
    
    for (int x = 0; x < element_count; x++) {
        CALayer *new_element = [CALayer layer];

        //  Everything gets drawn in the same place, since the drawer is closed
        new_element.frame = [drawer getElementRectForElementCount:0];
        
        
        //  We can accept UIColors or UIImages
        if ([[elements objectAtIndex:x] isKindOfClass:[UIColor class]]) {
            new_element.backgroundColor = ((UIColor *)[elements objectAtIndex:x]).CGColor;
        }
        else if ([[elements objectAtIndex:x] isKindOfClass:[UIImage class]]) {
            new_element.contents = (id)((UIImage *)[elements objectAtIndex:x]).CGImage;
        }

        //  Set the z index, so the first element is on top, so, initially selected
        new_element.zPosition = element_count - x;

        //  Cache a reference to the layer we just created and add it to the drawer
        [setupArray addObject:new_element];
        [drawer addSublayer:new_element];

    }

    //  Keep reference to the elements in the drawer
    drawer.elements = setupArray;

    //  Adjust the drawer's frame if we're drawing up or left
    if (direction == AIDOPENS_UPLEFT || direction == AIDOPENS_UPRIGHT) {
        origin.y -= (drawer.grid.y - 1) * ([drawer margin] + [drawer squareSize]);
    }
    if (direction == AIDOPENS_UPLEFT || direction == AIDOPENS_DOWNLEFT) {
        origin.x -= (drawer.grid.x - 1) * ([drawer margin] + [drawer squareSize]);
    }
    
    //  Set the frame for the object
    [drawer setFrame:CGRectMake(origin.x, origin.y, [drawer closedframeSize], [drawer closedframeSize])];

    return drawer;

}

-(void)setOpenDirection:(NSInteger)direction {
    _open_direction = direction;
}




#pragma mark - Internal view metric methods

//  Sets the frame for an element based on grid layout and position in the list of layer elements
-(CGRect)getElementRectForElementCount:(NSInteger)element_count {

    //  Assuming down-then-right, where should the icon be drawn
    float row = element_count % (int) roundf(_grid.y);
    float column = (element_count - row) / (int) roundf(_grid.y);
    
    //  If we are opening up or to the left, we need to change where the icon is drawn
    if (self.open_direction == AIDOPENS_DOWNLEFT || self.open_direction == AIDOPENS_UPLEFT) {
        column = (self.grid.x - 1) - column;
    }
    if (self.open_direction == AIDOPENS_UPLEFT || self.open_direction == AIDOPENS_UPRIGHT) {
        row = (self.grid.y - 1) - row;
    }
    
    // Set the frame
    return CGRectMake(([self margin] * (column)) + (column * [self squareSize]) + [self margin],
                      ([self margin] * (row)) + (row * [self squareSize]) + [self margin],
                      [self squareSize],
                      [self squareSize]);
}



//  Size of the element when closed
-(float)closedframeSize {
    return [self squareSize] + (2 * [self margin]);
}

//  Reset the layer ordering for all elements based on initial element order
-(void)resetSubviewDisplayOrder {
    NSInteger element_count = [self.elements count];
    for (int x=0; x < element_count; x++) {
        ((CALayer *)[self.elements objectAtIndex:x]).zPosition = element_count - x;
    }
}


#pragma mark - User interaction methods - exposed

/*
 *  toggleOpenCloseWithTappedLayer
 *  ==============================
 *  When this is called, we set the clicked element to live at the top of the stacked layers,
 *  so that it takes over the closed state icon, then we collapse all the icons to a single place
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
-(NSInteger)toggleOpenCloseWithTappedLayer:(CALayer *)layer {

    //  We get an object id, so we loop through the elements to see which one matches
    //  If nothing matches, we return -1
    NSInteger clicked_element = -1;
    int element_count = [self.elements count];
    for (int x=0; x < element_count; x++) {
        if (((CALayer *)[self.elements objectAtIndex:x]).modelLayer == layer.modelLayer) {
            
            //  We need to return the element placement
            clicked_element = x;
            
            //  Move the layer to the top
            ((CALayer *)[self.elements objectAtIndex:x]).zPosition = 1000.0f;

            //  Open or close the drawer
            [self toggleOpenClose];
        }

    }
    return clicked_element;  // This should be a protocol?
}

#pragma mark - User interaction support methods
-(void)toggleOpenClose {

    if (!_is_open) {
        [self open];
    }
    else {
        [self close];
    }
}

-(void)close {
    
    _is_open = NO;
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    
    CGRect stack_frame_location = [self getElementRectForElementCount:0];
    
    //  Move subviews to the "closed" point
    for (int x=0; x < [_elements count]; x++) {
       [(CALayer *)[_elements objectAtIndex:x] setFrame:[self getElementRectForElementCount:0] ];
    }

    [CATransaction commit];

}

-(void)open {
    
    _is_open = YES;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];

    //  Move subviews to the "open" position
    for (int x=0; x < [_elements count]; x++) {
        [(CALayer *)[_elements objectAtIndex:x] setFrame:[self getElementRectForElementCount:x]];
    }
    
    [CATransaction commit];
    [self resetSubviewDisplayOrder];
}


@end
