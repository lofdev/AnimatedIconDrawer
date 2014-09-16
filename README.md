AnimatedIconDrawer
==================

An iOS project for creating an animated drop-down drawer for selecting among a group of icons or colors.

The drawer is a single (square) instance of either an UIImage or a UIColor (filled CALayer), which acts as a drop-down menu, with clickable interaction for the elements used as options.

I will add a demo project shortly.

Usage
-----

The class uses an instantiation method to generate the element:

```
 _drawer = [AnimatedIconDrawer initWithOriginLayoutDirectionAndElements:<CGPoint of origin in containing view>
                                                                 layout:<CGPoint with column/row dimensions>
                                                              direction:<open direction>
                                                              elements:<array of elements>];
```

Example from my code:
```
    CGPoint grid_layout = CGPointMake(2.0f, 3.0f);

    NSMutableArray *my_elements = [[NSMutableArray alloc] initWithCapacity:8];
    [my_elements addObject:[UIImage imageNamed:@"earth-rock_40x40.png"]];
    [my_elements addObject:[UIImage imageNamed:@"air_40x40.png"]];
    [my_elements addObject:[UIImage imageNamed:@"water_40x40.png"]];
    [my_elements addObject:[UIImage imageNamed:@"snow-ice_40x40.png"]];
    [my_elements addObject:[UIImage imageNamed:@"life_40x40.png"]];

    _drawer = [AnimatedIconDrawer initWithOriginLayoutDirectionAndElements:CGPointMake(10.0f, 270.0f)
                                                                    layout:grid_layout
                                                                 direction:AIDOPENS_UPRIGHT
                                                                  elements:(NSArray *)my_elements];
    [self.view.layer addSublayer:_drawer];
```

Options
-------
Direction can be one of the following, indicating the direction in which the drawer opens:
 * AIDOPENS_UPRIGHT
 * AIDOPENS_UPLEFT
 * AIDOPENS_DOWNLEFT
 * AIDOPENS_DOWNRIGHT
