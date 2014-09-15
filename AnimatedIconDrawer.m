//
//  AnimatedIconDrawer.m
//  CA Learning
//
//  Created by Dave Loftis on 9/14/14.
//  Copyright (c) 2014 Dave Loftis. All rights reserved.
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

+(AnimatedIconDrawer *)initWithOriginLayoutAndElements:(CGPoint)origin layout:(CGPoint)layout elements:(NSArray *)elements  {

    AnimatedIconDrawer *drawer = [[AnimatedIconDrawer alloc] init];
    drawer.grid = layout;

    int element_count = [elements count];

    NSMutableArray *setupArray = [[NSMutableArray alloc] initWithCapacity:element_count];

    for (int x = 0; x < element_count; x++) {
        CALayer *new_element = [CALayer layer];

        //  Initially the drawer displays in closed state
        new_element.frame = CGRectMake([drawer margin], [drawer margin], [drawer squareSize], [drawer squareSize]);

        //  We can
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

    //  Set the drawer's frame
    [drawer setFrame:CGRectMake(origin.x, origin.y, [drawer closedframeSize], [drawer closedframeSize])];

    return drawer;

}




#pragma mark - Internal view metric methods

//  Sets the frame for an element based on grid layout and position in the list of layer elements
-(CGRect)getElementRectForElementCount:(NSInteger)element_count {

    float row = element_count % (int) roundf(_grid.y);
    float column = (element_count - row) / (int) roundf(_grid.y);

    return CGRectMake(([self margin] * (column + 1)) + (column * [self squareSize]),
                      ([self margin] * (row + 1)) + (row * [self squareSize]),
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

-(NSInteger)toggleOpenCloseWithTappedLayer:(CALayer *)layer {


    NSInteger clicked_element = -1;
    int element_count = [self.elements count];
    for (int x=0; x < element_count; x++) {
        if (((CALayer *)[self.elements objectAtIndex:x]).modelLayer == layer.modelLayer) {
            clicked_element = x;
            ((CALayer *)[self.elements objectAtIndex:x]).zPosition = 1000.0f;

            [self toggleOpenClose];
        }

    }
    return clicked_element;
}

#pragma mark - User interaction support methods
-(void)toggleOpenClose {

    if (self.frame.size.height == [self closedframeSize]) {
        [self open];
    }
    else {
        [self close];
    }

}

-(void)close {

    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];

    //  Move subviews
    for (int x=0; x < [_elements count]; x++) {
       [(CALayer *)[_elements objectAtIndex:x] setFrame:CGRectMake([self margin], [self margin], [self squareSize], [self squareSize])];
    }

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [self closedframeSize], [self closedframeSize] );
    [CATransaction commit];


}

-(void)open {

    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];

    //  Move subviews
    for (int x=0; x < [_elements count]; x++) {
        [(CALayer *)[_elements objectAtIndex:x] setFrame:[self getElementRectForElementCount:x]];
    }

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + 90.0f );
    [CATransaction commit];
    [self resetSubviewDisplayOrder];
}


@end
