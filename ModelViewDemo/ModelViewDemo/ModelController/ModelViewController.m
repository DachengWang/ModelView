//
//  ModelViewController.m
//  QHPocket
//
//  Created by wangdacheng on 2017/12/29.
//  Copyright © 2017年 qihoo. All rights reserved.
//

#import "ModelViewController.h"

//宏定义
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface ModelViewController ()

@property (nonatomic, strong) UIControl *maskView;

@property (nonatomic, strong) UIView *hostView;

@property (nonatomic, assign) BOOL maskViewTapped;

@property (nonatomic, assign) BOOL presented;

@property (nonatomic,   copy) ModelViewAnimationCompletion animationCompletion;

@end

@implementation ModelViewController {
    UIViewController *_retainSelf;
}

#pragma mark - super Methods
- (void)dealloc {
#if DEBUG
    NSLog(@"ModelViewController: dealloc");
#endif
}

- (void)viewWillAppear:(BOOL)animated {
#if DEBUG
    NSLog(@"ModelViewController: viewWillAppear");
#endif
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
#if DEBUG
    NSLog(@"ModelViewController: viewDidAppear");
#endif
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
#if DEBUG
    NSLog(@"ModelViewController: viewWillDisappear");
#endif
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
#if DEBUG
    NSLog(@"ModelViewController: viewDidDisappear");
#endif
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
#if DEBUG
    NSLog(@"ModelViewController: didReceiveMemoryWarning");
#endif
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // default
    self.view.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 30, 300);
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - public methods
- (instancetype)initWithHostViewController:(UIViewController *)hostViewController completion:(ModelViewAnimationCompletion)animationCompletion
{
    self = [super init];
    if (self) {
        _hostViewController = hostViewController;
        _animationCompletion = animationCompletion;
        _hostView = hostViewController.view;
        _retainSelf = self;
        _maskView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_hostView.bounds), CGRectGetHeight(_hostView.bounds))];
        _maskViewAlpha = 0.6;
        _maskViewColor = [UIColor darkGrayColor];
        _duration = 0.3;
    }
    return self;
}

- (void)toggle
{
    if (!_hostViewController) {
#if DEBUG
        NSLog(@"ModelViewController: superViewController is nil");
#endif
        return;
    }
    
    [self allowUserInteraction:NO];
    self.maskViewTapped = NO;
    
    if (_presented) {
        [self dismissWithMaskViewTapped:NO];
        [self allowBackSwipeGesture:YES];
    } else {
        [self.hostViewController.view endEditing:YES];
        [self show];
        [self allowBackSwipeGesture:NO];
    }
}

- (void)cancel
{
    _presented = NO;
    [self beginAppearanceTransition:NO animated:YES];
    _maskView.alpha = 0.0;
    self.view.alpha = 0.0;
    [_maskView removeFromSuperview];
    [self.view removeFromSuperview];
    [self endAppearanceTransition];
    [self allowBackSwipeGesture:YES];
    _retainSelf = nil;
}

#pragma mark - private methods
- (void)show
{
#if DEBUG
    NSLog(@"ModelViewController: show");
#endif
    
    if (!_presented) {
        _presented = YES;
        [self handleMaskView];
        [_hostView addSubview:self.view];
        [self executeAnimationsToShow:YES];
    }
}

- (void)executeAnimationsToShow:(BOOL)isForshow
{
    WS(weakSelf)
    if (isForshow) {
        [self placeSelfViewBeforeAnimation];
        [UIView animateWithDuration:_duration animations:^{
            weakSelf.maskView.alpha = weakSelf.maskViewAlpha;
            [weakSelf placeSelfViewAfterAnimation];
        } completion:^(BOOL finished) {
            if (weakSelf.animationCompletion) {
                weakSelf.animationCompletion(weakSelf, YES, weakSelf.maskViewTapped);
            }
            [self allowUserInteraction:YES];
        }];
    } else {
        [self beginAppearanceTransition:NO animated:YES];
        [UIView animateWithDuration:_duration animations:^{
            weakSelf.maskView.alpha = 0.0;
            weakSelf.view.alpha = 0.0;
            [self placeSelfViewBeforeAnimation];
        } completion:^(BOOL finished) {
            [weakSelf.maskView removeFromSuperview];
            [weakSelf.view removeFromSuperview];
            if (weakSelf.animationCompletion) {
                weakSelf.animationCompletion(weakSelf, NO, weakSelf.maskViewTapped);
                [self endAppearanceTransition];
                [weakSelf allowUserInteraction:YES];
                _retainSelf = nil;
            }
        }];
    }
}

- (void)handleMaskView
{
    _maskView.backgroundColor = _maskViewColor;
    _maskView.alpha = 0.0;
    [_hostView addSubview:_maskView];
    
    if (_maskViewTapEnabled) {
        [_maskView addTarget:self action:@selector(maskViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_maskView removeTarget:self action:@selector(maskViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.view) {
        self.view.center = CGPointMake(CGRectGetWidth(_hostView.bounds) / 2.0, CGRectGetHeight(_hostView.bounds) / 2.0);
        self.view.clipsToBounds = YES;
        self.view.alpha = 1.0;
    }
}

- (void)maskViewTapped:(id)sender
{
    [self dismissWithMaskViewTapped:YES];
}

- (void)dismissWithMaskViewTapped:(BOOL)isTapped
{
    if (_presented) {
#if DEBUG
        NSLog(@"dismissWithMaskViewTapped: (%@)", isTapped ? @"YES" : @"NO");
#endif
        _presented = NO;
        _maskViewTapped = isTapped;
        [self executeAnimationsToShow:NO];
    }
}

- (CGPoint)placeSelfViewBeforeAnimation
{
    switch (_direction) {
        case DirectionType_TopDown:
            self.view.frame = CGRectCenteredToRectAtTop(self.view.frame, _hostView.bounds);
            break;
        case DirectionType_LeftToRight:
            self.view.frame = CGRectCenteredToRectAtLeft(self.view.frame, _hostView.bounds);
            break;
        case DirectionType_BottomUp:
            self.view.frame = CGRectCenteredToRectAtBottom(self.view.frame, _hostView.bounds);
            break;
        case DirectionType_RightToLeft:
            self.view.frame = CGRectCenteredToRectAtRight(self.view.frame, _hostView.bounds);
            break;
        default:
            break;
    }
    
    return self.view.center;
}

- (CGPoint)placeSelfViewAfterAnimation
{
    switch (_direction) {
        case DirectionType_TopDown:
            self.view.frame = CGRectCenteredInnerToRectAtTop(self.view.frame, _hostView.bounds);
            break;
        case DirectionType_LeftToRight:
            self.view.frame = CGRectCenteredInnerToRectAtLeft(self.view.frame, _hostView.bounds);
            break;
        case DirectionType_BottomUp:
            self.view.frame = CGRectCenteredInnerToRectAtBottom(self.view.frame, _hostView.bounds);
            break;
        case DirectionType_RightToLeft:
            self.view.frame = CGRectCenteredInnerToRectAtRight(self.view.frame, _hostView.bounds);
            break;
        default:
            break;
    }
    
    return self.view.center;
}

- (void)allowUserInteraction:(BOOL)isAllow
{
    if (isAllow) {
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    } else {
        if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        }
    }
}

- (void)allowBackSwipeGesture:(BOOL)isAllow
{
    if ([_hostViewController isKindOfClass:[UINavigationController class]]
        && [((UINavigationController *)_hostViewController) respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        ((UINavigationController *)_hostViewController).interactivePopGestureRecognizer.enabled = isAllow;
    }
}

#pragma mark - Rect change methods
CGRect CGRectCenteredToRectAtTop(CGRect alignedRect, CGRect toRect) {
    CGPoint topLeft = toRect.origin;
    CGFloat newX = topLeft.x - (CGRectGetWidth(alignedRect) - CGRectGetWidth(toRect)) / 2;
    CGFloat newY = topLeft.y - CGRectGetHeight(alignedRect);
    
    return CGRectMake(newX, newY, CGRectGetWidth(alignedRect), CGRectGetHeight(alignedRect));
}

CGRect CGRectCenteredToRectAtLeft(CGRect alignedRect, CGRect toRect) {
    CGPoint topLeft = toRect.origin;
    CGFloat newX = topLeft.x - CGRectGetWidth(alignedRect);
    CGFloat newY = topLeft.y - (CGRectGetHeight(alignedRect) - CGRectGetHeight(toRect)) / 2;
    
    return CGRectMake(newX, newY, CGRectGetWidth(alignedRect), CGRectGetHeight(alignedRect));
}

CGRect CGRectCenteredToRectAtBottom(CGRect alignedRect, CGRect toRect) {
    CGPoint topLeft = toRect.origin;
    CGFloat newX = topLeft.x - (CGRectGetWidth(alignedRect) - CGRectGetWidth(toRect)) / 2;
    CGFloat newY = topLeft.y + CGRectGetHeight(toRect);
    
    return CGRectMake(newX, newY, CGRectGetWidth(alignedRect), CGRectGetHeight(alignedRect));
}

CGRect CGRectCenteredToRectAtRight(CGRect alignedRect, CGRect toRect) {
    CGPoint topLeft = toRect.origin;
    CGFloat newX = topLeft.x + CGRectGetWidth(toRect);
    CGFloat newY = topLeft.y - (CGRectGetHeight(alignedRect) - CGRectGetHeight(toRect)) / 2;
    
    return CGRectMake(newX, newY, CGRectGetWidth(alignedRect), CGRectGetHeight(alignedRect));
}

#pragma mark -
CGRect CGRectCenteredInnerToRectAtTop(CGRect alignedRect, CGRect toRect) {
    CGPoint topLeft = toRect.origin;
    CGFloat newX = topLeft.x + (CGRectGetWidth(toRect) - CGRectGetWidth(alignedRect)) / 2;
    CGFloat newY = topLeft.y;
    
    return CGRectMake(newX, newY, CGRectGetWidth(alignedRect), CGRectGetHeight(alignedRect));
}

CGRect CGRectCenteredInnerToRectAtLeft(CGRect alignedRect, CGRect toRect) {
    CGPoint topLeft = toRect.origin;
    CGFloat newX = topLeft.x;
    CGFloat newY = topLeft.y + (CGRectGetHeight(toRect) - CGRectGetHeight(alignedRect)) / 2;
    
    return CGRectMake(newX, newY, CGRectGetWidth(alignedRect), CGRectGetHeight(alignedRect));
}

CGRect CGRectCenteredInnerToRectAtBottom(CGRect alignedRect, CGRect toRect) {
    CGPoint topLeft = toRect.origin;
    CGFloat newX = topLeft.x + (CGRectGetWidth(toRect) - CGRectGetWidth(alignedRect)) / 2;
    CGFloat newY = topLeft.y + (CGRectGetHeight(toRect) - CGRectGetHeight(alignedRect));
    
    return CGRectMake(newX, newY, CGRectGetWidth(alignedRect), CGRectGetHeight(alignedRect));
}

CGRect CGRectCenteredInnerToRectAtRight(CGRect alignedRect, CGRect toRect) {
    CGPoint topLeft = toRect.origin;
    CGFloat newX = topLeft.x + (CGRectGetWidth(toRect) - CGRectGetWidth(alignedRect));
    CGFloat newY = topLeft.y + (CGRectGetHeight(toRect) - CGRectGetHeight(alignedRect)) / 2;
    
    return CGRectMake(newX, newY, CGRectGetWidth(alignedRect), CGRectGetHeight(alignedRect));
}

CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
    return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
}

CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
}


@end
