//
//  ViewController.m
//  CirculateScroll
//
//  Created by zjj on 2020/1/10.
//  Copyright © 2020 zjj. All rights reserved.
//

#import "ViewController.h"
#import "ZZCirculateScrollView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet ZZCirculateScrollView *circulateScrollView;
@property (nonatomic, strong) NSMutableArray *allViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allViews = NSMutableArray.array;
    [self.circulateScrollView setShowingCount:5 contentRequest:^UIView *(NSInteger index) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
        btn.backgroundColor = [UIColor colorWithHue:(CGFloat)(arc4random() % 1000) / 1000.0 saturation:0.5 brightness:1 alpha:1];;
        btn.titleLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightBold];
        [btn setTitle:@(index).stringValue forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [[UIColor blackColor] CGColor];
        btn.layer.borderWidth = 8;
        btn.tag = index;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.allViews addObject:btn];
        if (index == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            });
        }
        return btn;
    }];
}

- (void)buttonClick:(UIButton *)button {
    for (UIButton *btn in self.allViews) {
        btn.layer.borderColor = (button == btn)? [[UIColor yellowColor] CGColor]: [[UIColor blackColor] CGColor];
    }
    [self.circulateScrollView scrollViewAtIndexToCenter:button.tag];
}

@end
