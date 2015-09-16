//
//  ViewController.m
//  XerLee Test
//
//  Created by KingMartin on 15/9/16.
//  Copyright (c) 2015年 KingMartin. All rights reserved.
//

#import "ViewController.h"
#import "UIEffectDesignerView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *sview;
@property (weak, nonatomic) IBOutlet UIView *sview2;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UIImageView *imageview2;
@property (weak, nonatomic) IBOutlet UIImageView *imageview3;
@property(strong,nonatomic) CABasicAnimation*circleMaskAnimation;
@property(strong,nonatomic) CAShapeLayer*MaskLayer;
@property(strong,nonatomic) CAShapeLayer*MaskLayer2;
@property(strong,nonatomic) UIEffectDesignerView*effectView;
@property(strong,nonatomic) UIEffectDesignerView*effectView2;



- (void)handlePan:(UIPanGestureRecognizer *)recognizer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //一、
    //1.Mask Layer设置
    _MaskLayer = [[CAShapeLayer alloc]init];
    _MaskLayer.frame = self.view.bounds;
    _MaskLayer.fillColor = [[UIColor blackColor] CGColor];
    
    _MaskLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 300, 73)].CGPath;
    //添加mask后，直接属于其子layer
    _sview.layer.mask = _MaskLayer;
    _sview.layer.masksToBounds = YES;
    
    //2.添加particle层
    _effectView = [UIEffectDesignerView effectWithFile:@"particle.ped"];
    [self.view addSubview:_effectView];
    _effectView.frame = CGRectMake(300, 144, 80, 80);
    _effectView.emitter.lifetime = 1.5;
    _effectView.alpha = 0;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_sview addGestureRecognizer:recognizer];
    
    //二、
    //1.Mask Layer设置
    _MaskLayer2 = [[CAShapeLayer alloc]init];
    _MaskLayer2.frame = self.view.bounds;
    _MaskLayer2.fillColor = [[UIColor blackColor] CGColor];
    
    _MaskLayer2.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 300, 73)].CGPath;
    //添加mask后，直接属于其子layer
    _sview2.layer.mask = _MaskLayer2;
    _sview2.layer.masksToBounds = YES;
    
    //2.添加particle层
    _effectView2 = [UIEffectDesignerView effectWithFile:@"particle.ped"];
    [self.view addSubview:_effectView2];
    _effectView2.frame = CGRectMake(300, 144, 80, 80);
    _effectView2.emitter.lifetime = 1.5;
    _effectView2.alpha = 0;
    
    UIPanGestureRecognizer *recognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan2:)];
    [_sview2 addGestureRecognizer:recognizer2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    
    CGPoint location = [recognizer locationInView:_sview];
    CGPoint translation = [recognizer translationInView:_sview];
    CGPoint velocity = [recognizer velocityInView:_sview];
    
    NSLog(@"location.x is %f",location.x);
    NSLog(@"translation.x is %f",translation.x);
    NSLog(@"velocity.x is %f",velocity.x);
    
    //手势速度影响生成率&速度
    _effectView.emitter.velocity = velocity.x/-100;
    _effectView.emitter.birthRate = velocity.x/-10+10;
    
    [_MaskLayer setNeedsDisplay];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            
        {
            
        }
        case UIGestureRecognizerStateChanged:
        {
            
            
            //👈滑出现蒙板效果，👉滑不出蒙板效果
            if (translation.x <0) {
                //Refresh the MaskLayer's translation.x to re-animate
                [_MaskLayer removeAllAnimations];
                [_effectView.layer removeAllAnimations];
                //简单跟手
                CATransform3D t1 = CATransform3DMakeTranslation(translation.x*1-20,0, 0);
                CGAffineTransform t2 = CGAffineTransformMakeTranslation(translation.x*1-20, 0);
                _MaskLayer.transform = t1;
                _effectView.transform = t2;
                _effectView.alpha = 1;
            }
            else{
            }
            
    
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            
        {
            
            if (translation.x <0) {
                //👉
                if (translation.x >-100) {
                    //Mask&effectView 👉
                    CABasicAnimation* maskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                    maskAnimation.fillMode = kCAFillModeForwards;
                    maskAnimation.removedOnCompletion = NO;
                    maskAnimation.toValue = [NSNumber numberWithFloat:0];
                    maskAnimation.duration = 0.2;
                    
                    [_MaskLayer addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    [_effectView.layer addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    
                    //Particle消失
                    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                        _effectView.emitter.lifetime = 0;
                        _effectView.alpha = 0;
                        
                    }completion:^(BOOL finished){
                        _effectView.emitter.lifetime = 1.5;
                    }];
                    
                    

                    
                }
                else{
                    
                    _effectView.emitter.lifetime = 1.5;
                    ////Mask&effectView 👈
                    CABasicAnimation* maskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                    maskAnimation.fillMode = kCAFillModeForwards;
                    maskAnimation.removedOnCompletion = NO;
                    maskAnimation.toValue = [NSNumber numberWithFloat:-286];
                    maskAnimation.duration = 0.2;
                    
                    CABasicAnimation* maskAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                    maskAnimation2.fillMode = kCAFillModeForwards;
                    maskAnimation2.removedOnCompletion = NO;
                    maskAnimation2.toValue = [NSNumber numberWithFloat:-300];
                    maskAnimation2.duration = 0.2;
                    
                    [_MaskLayer addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    [_effectView.layer addAnimation:maskAnimation2 forKey:@"transform.translation.x"];
                    //Particle消失
                    
                    
                    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                        _effectView.emitter.lifetime = 0;
                        
                        //_effectView.alpha = 0;
                    }completion:^(BOOL finished){
                        //_effectView.emitter.lifetime = 1.5;
                    }];
                    
                    //整体上移
                    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        _sview2.center = CGPointMake(_sview2.center.x, _sview2.center.y-83);
                        _imageview3.center = CGPointMake(_imageview3.center.x, _imageview3.center.y-83);
                    }completion:^(BOOL finished){
                        _sview.alpha = 0;
                    }];
                    
                }
            }
            
            
        }
            break;
        case UIGestureRecognizerStateFailed:
            
        default:
            break;
    }
    
    
    
}

- (void)handlePan2:(UIPanGestureRecognizer *)recognizer2
{
    
    CGPoint location = [recognizer2 locationInView:_sview2];
    CGPoint translation = [recognizer2 translationInView:_sview2];
    CGPoint velocity = [recognizer2 velocityInView:_sview2];
    
    NSLog(@"location.x is %f",location.x);
    NSLog(@"translation.x is %f",translation.x);
    NSLog(@"velocity.x is %f",velocity.x);
    
    //手势速度影响生成率&速度
    _effectView2.emitter.velocity = velocity.x/-100;
    _effectView2.emitter.birthRate = velocity.x/-10+10;
    
    [_MaskLayer2 setNeedsDisplay];
    
    switch (recognizer2.state) {
        case UIGestureRecognizerStateBegan:
            
        {
            
        }
        case UIGestureRecognizerStateChanged:
        {
            
            
            //👈滑出现蒙板效果，👉滑不出蒙板效果
            if (translation.x <0) {
                //Refresh the MaskLayer's translation.x to re-animate
                [_MaskLayer2 removeAllAnimations];
                [_effectView2.layer removeAllAnimations];
                //简单跟手
                CATransform3D t1 = CATransform3DMakeTranslation(translation.x*1-20,0, 0);
                CGAffineTransform t2 = CGAffineTransformMakeTranslation(translation.x*1-20, 0);
                _MaskLayer2.transform = t1;
                _effectView2.transform = t2;
                _effectView2.alpha = 1;
            }
            else{
            }
            
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            
        {
            
            if (translation.x <0) {
                //👉
                if (translation.x >-100) {
                    //Mask&effectView 👉
                    CABasicAnimation* maskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                    maskAnimation.fillMode = kCAFillModeForwards;
                    maskAnimation.removedOnCompletion = NO;
                    maskAnimation.toValue = [NSNumber numberWithFloat:0];
                    maskAnimation.duration = 0.2;
                    
                    [_MaskLayer2 addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    [_effectView2.layer addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    
                    //Particle消失
                    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                        _effectView2.emitter.lifetime = 0;
                        _effectView2.alpha = 0;
                        
                    }completion:^(BOOL finished){
                        _effectView2.emitter.lifetime = 1.5;
                    }];
                    
                    
                    
                    
                }
                else{
                    
                    _effectView2.emitter.lifetime = 1.5;
                    ////Mask&effectView 👈
                    CABasicAnimation* maskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                    maskAnimation.fillMode = kCAFillModeForwards;
                    maskAnimation.removedOnCompletion = NO;
                    maskAnimation.toValue = [NSNumber numberWithFloat:-286];
                    maskAnimation.duration = 0.2;
                    
                    CABasicAnimation* maskAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                    maskAnimation2.fillMode = kCAFillModeForwards;
                    maskAnimation2.removedOnCompletion = NO;
                    maskAnimation2.toValue = [NSNumber numberWithFloat:-300];
                    maskAnimation2.duration = 0.2;
                    
                    [_MaskLayer2 addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    [_effectView2.layer addAnimation:maskAnimation2 forKey:@"transform.translation.x"];
                    //Particle消失
                    
                    
                    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                        _effectView2.emitter.lifetime = 0;
                        
                        //_effectView.alpha = 0;
                    }completion:^(BOOL finished){
                        //_effectView.emitter.lifetime = 1.5;
                    }];
                    
                    //整体上移
                    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        _imageview3.center = CGPointMake(_imageview3.center.x, _imageview3.center.y-83);
                    }completion:^(BOOL finished){
                        _sview2.alpha = 0;
                    }];
                    
                }
            }
            
            
        }
            break;
        case UIGestureRecognizerStateFailed:
            
        default:
            break;
    }
    
    
    
}

@end
