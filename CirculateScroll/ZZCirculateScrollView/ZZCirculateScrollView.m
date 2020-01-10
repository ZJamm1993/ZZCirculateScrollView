//
//  ZZCirculateScrollView.m
//  CirculateScroll
//
//  Created by zjj on 2020/1/10.
//  Copyright © 2020 zjj. All rights reserved.
//

#import "ZZCirculateScrollView.h"

#define kTagOffset (998)

@interface ZZCirculateScrollView()

@property (nonatomic, assign) NSInteger contentCount;

@end

@implementation ZZCirculateScrollView

- (void)setShowingCount:(NSInteger)count contentRequest:(ZZCirculateScrollViewContentRequestHandler)contentRequest {
    
    NSArray *subs = [self subviews];
    for (UIView *vi in subs) {
        [vi removeFromSuperview];
    }
    
    self.contentCount = count;
    self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.alwaysBounceVertical = NO;
    self.alwaysBounceHorizontal = YES;
    self.delaysContentTouches = NO;
    self.clipsToBounds = YES;
    
    CGFloat startOffset = 1000;
    CGFloat currentMaxX = startOffset;
    for (int i = 0; i < self.contentCount; i++) {
        UIView *view = [[UIView alloc] init];
        if (contentRequest) {
            UIView *content = contentRequest(i);
            if (content) {
                [view addSubview:content];
                CGRect frame = content.bounds;
                frame.origin.x = currentMaxX;
                view.frame = frame;
                currentMaxX = CGRectGetMaxX(frame);
            }
        }
        view.tag = i + kTagOffset;
        [self addSubview:view];
    }
    
    self.contentSize = CGSizeMake(startOffset + currentMaxX, self.frame.size.height);
    self.contentOffset = CGPointMake(startOffset, 0);
}

#pragma mark - override

- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    [self myLayoutAllSubviews];
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    [super touchesShouldCancelInContentView:view];
    return YES;
}

#pragma mark - my scrolling and layout

- (void)myLayoutAllSubviews {
    NSArray *subviews = self.subviews;
    CGFloat contentWidth = self.contentSize.width;
    CGFloat min = contentWidth + 1000;
    CGFloat max = -1000;
    UIView *lastOne = nil;
    UIView *firstOne = nil;
    for (UIView *viw in subviews) {
        CGFloat viwMaxX = CGRectGetMaxX(viw.frame);
        if (viwMaxX >= max) {
            max = viwMaxX;
            lastOne = viw;
        }
        CGFloat viwMinX = CGRectGetMinX(viw.frame);
        if (viwMinX <= min) {
            min = viwMinX;
            firstOne = viw;
        }
    }
    
    CGFloat containerWidth = self.frame.size.width;
    CGFloat offsetX = self.contentOffset.x;
    // 如果最后一个后面空了，将第一个移至最后。
    if (max < offsetX + containerWidth) {
        CGRect frame = firstOne.frame;
        frame.origin.x = max;
        firstOne.frame = frame;
    }
    else if (min > offsetX) {
        CGRect frame = lastOne.frame;
        frame.origin.x = min - frame.size.width;
        lastOne.frame = frame;
    }
    
//    NSLog(@"contentW:%.2f, offsetX:%.2f", contentWidth, offsetX);
    // 如果滑到某处，将所有的view都移到中间，并偷偷setContentOffset
    CGFloat boundVal = 0;
    BOOL isBoundFront = offsetX < (contentWidth * boundVal);
    BOOL isBoundBack = offsetX > (contentWidth - containerWidth) * (1 - boundVal);
    if (isBoundFront || isBoundBack) {
        CGFloat newOffSetX = (contentWidth + containerWidth) / 2;
        CGFloat distance = newOffSetX - offsetX;
        [super setContentOffset:CGPointMake(newOffSetX, 0)];
        for (UIView *sub in subviews) {
            CGRect fra = sub.frame;
            fra.origin.x += distance;
            sub.frame = fra;
        }
        NSLog(@"out of bounds: %@", isBoundFront? @"front": @"back");
    }
}

- (void)scrollViewAtIndexToCenter:(NSInteger)index {
    UIView *viewAtIndex = [self viewWithTag:index + kTagOffset];
    if (viewAtIndex != self) {
        CGFloat centerOfView = viewAtIndex.center.x;
        CGFloat offsetOfCenter = self.contentOffset.x + self.frame.size.width / 2;
        CGFloat distance = centerOfView - offsetOfCenter;
        CGFloat newOffsetX = self.contentOffset.x + distance;
        [self setContentOffset:CGPointMake(newOffsetX, 0) animated:YES];
    }
}

@end
