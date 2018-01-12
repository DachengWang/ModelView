//
//  ModelViewController.h
//  QHPocket
//
//  Created by wangdacheng on 2017/12/29.
//  Copyright © 2017年 qihoo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ModelViewDirectionType){
    // default，停在中间
    DirectionType_Center,
    // 由上至下，停在上边
    DirectionType_TopDown,
    // 由左至右，停在左边
    DirectionType_LeftToRight,
    // 由下至上，停在底边
    DirectionType_BottomUp,
    // 由右至座，停在右边
    DirectionType_RightToLeft,
};

typedef void(^ModelViewAnimationCompletion)(id presentedViewController, BOOL presented, BOOL backgroundTapped);

@interface ModelViewController : UIViewController

// 所属的hostViewController
@property (nonatomic, strong) UIViewController *hostViewController;

// 设置maskView样式
@property (nonatomic, assign)BOOL maskViewTapEnabled;
@property (nonatomic, assign) CGFloat maskViewAlpha;
@property (nonatomic, strong) UIColor *maskViewColor;

// modelView弹出方式
@property (nonatomic, assign) ModelViewDirectionType direction;
// 动画时间
@property (nonatomic, assign) CGFloat duration;

// 公共方法
- (instancetype)initWithHostViewController:(UIViewController *)hostViewController completion:(ModelViewAnimationCompletion)animationCompletion;
- (void)toggle;
- (void)cancel;

@end
