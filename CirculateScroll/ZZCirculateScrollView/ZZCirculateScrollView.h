//
//  ZZCirculateScrollView.h
//  CirculateScroll
//
//  Created by zjj on 2020/1/10.
//  Copyright © 2020 zjj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView *(^ZZCirculateScrollViewContentRequestHandler)(NSInteger index);

@interface ZZCirculateScrollView : UIScrollView

- (void)setShowingCount:(NSInteger)count contentRequest:(ZZCirculateScrollViewContentRequestHandler)contentRequest;
- (void)scrollViewAtIndexToCenter:(NSInteger)index;

@end
