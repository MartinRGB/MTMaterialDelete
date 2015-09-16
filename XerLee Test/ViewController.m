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
    
    _MaskLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 286, 73)].CGPath;
    //添加mask后，直接属于其子layer
    _sview.layer.mask = _MaskLayer;
    _sview.layer.masksToBounds = YES;
    
    //2.添加particle层
    _effectView = [UIEffectDesignerView effectWithFile:@"particle.ped"];
    [self.view addSubview:_effectView];
    _effectView.frame = CGRectMake(290, 144, 40, 80);
    _effectView.emitter.birthRate = 20;
    _effectView.emitter.lifetime = 0.6;
    _effectView.alpha = 0;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_sview addGestureRecognizer:recognizer];
    
    
    //二、
    //1.Mask Layer设置
    _MaskLayer2 = [[CAShapeLayer alloc]init];
    _MaskLayer2.frame = self.view.bounds;
    _MaskLayer2.fillColor = [[UIColor blackColor] CGColor];
    
    _MaskLayer2.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 286, 73)].CGPath;
    //添加mask后，直接属于其子layer
    _sview2.layer.mask = _MaskLayer2;
    _sview2.layer.masksToBounds = YES;
    
    //2.添加particle层
    _effectView2 = [UIEffectDesignerView effectWithFile:@"particle.ped"];
    [self.view addSubview:_effectView2];
    _effectView2.frame = CGRectMake(290, 144, 40, 80);
    _effectView2.emitter.birthRate = 20;
    _effectView2.emitter.lifetime = 0.6;
    _effectView2.alpha = 0;
    
    UIPanGestureRecognizer *recognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan2:)];
    [_sview2 addGestureRecognizer:recognizer2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (IBAction)btn:(id)sender {
    
    
    
    
    CABasicAnimation* maskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    maskAnimation.fillMode = kCAFillModeForwards;
    maskAnimation.removedOnCompletion = NO;
    maskAnimation.toValue = [NSNumber numberWithFloat:-286];
    maskAnimation.duration = 0.6;
    
    [_MaskLayer addAnimation:maskAnimation forKey:@"transform.translation.x"];
    
    _effectView.alpha = 1;
    [_effectView.layer addAnimation:maskAnimation forKey:@"transform.translation.x"];
    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
        _effectView.emitter.lifetime = 0.6;
    }completion:^(BOOL finished){
    }];
    
    
    
}
 */

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    //CGPoint touchPosition = [recognizer locationInView:self.view];
    //CGPoint velocity = [recognizer velocityInView:self.view];
    CGPoint location = [recognizer locationInView:_sview];
    CGPoint translation = [recognizer translationInView:_sview];
    CGPoint velocity = [recognizer velocityInView:_sview];
    
    NSLog(@"location.x is %f",location.x);
    NSLog(@"translation.x is %f",translation.x);
    NSLog(@"velocity.x is %f",velocity.x);
    
    //
    CATransform3D t1 = CATransform3DMakeTranslation(translation.x*1.1-20,0, 0);
    CGAffineTransform t2 = CGAffineTransformMakeTranslation(translation.x*1-20, 0);
    _MaskLayer.transform = t1;
    _effectView.transform = t2;
    _effectView.emitter.velocity = velocity.x/-100;
    
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            
            if (translation.x <0) {
                
                
                
                _effectView.alpha = 1;
                
                
                
            }
    
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            
        {
            if (translation.x <0) {
                if (translation.x >-100) {
                    
                    CABasicAnimation* maskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                    maskAnimation.fillMode = kCAFillModeForwards;
                    maskAnimation.removedOnCompletion = NO;
                    maskAnimation.toValue = [NSNumber numberWithFloat:0];
                    maskAnimation.duration = 0.3;
                    
                    [_MaskLayer addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    
                    [_effectView.layer addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    
                    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                        _effectView.emitter.lifetime = 0;
                        _effectView.alpha = 0;
                        
                    }completion:^(BOOL finished){
                    }];
                    
                    

                    
                }
                else{
                    CABasicAnimation* maskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                    maskAnimation.fillMode = kCAFillModeForwards;
                    maskAnimation.removedOnCompletion = NO;
                    maskAnimation.toValue = [NSNumber numberWithFloat:-286];
                    maskAnimation.duration = 0.3;
                    
                    [_MaskLayer addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    
                    [_effectView.layer addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                        _effectView.emitter.lifetime = 0;
                        _effectView.alpha = 0;
                    }completion:^(BOOL finished){
                        
                        
                    }];
                    
                    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        _sview2.center = CGPointMake(_sview2.center.x, _sview2.center.y-83);
                        _imageview3.center = CGPointMake(_imageview3.center.x, _imageview3.center.y-83);
                    }completion:^(BOOL finished){
                        _sview.alpha = 0;
                        
                    }];
                    
                }
                [_MaskLayer setNeedsDisplay];
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
    CGPoint translation = [recognizer2 translationInView:_sview2];
    CGPoint velocity = [recognizer2 velocityInView:_sview2];
    
    _sview2.layer.mask = _MaskLayer2;
    _sview2.layer.masksToBounds = YES;

    //
    CATransform3D t1 = CATransform3DMakeTranslation(translation.x*1.1-20,0, 0);
    CGAffineTransform t2 = CGAffineTransformMakeTranslation(translation.x-20, 0);
    _MaskLayer2.transform = t1;
    _effectView2.transform = t2;
    _effectView2.emitter.velocity = velocity.x/-100;
    
    switch (recognizer2.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            
            if (translation.x <0) {
                
                
                _effectView2.alpha = 1;
                
                
            }
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            
        {
            if (translation.x <0) {
                if (translation.x >-100) {
                    
                    CABasicAnimation* maskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                    maskAnimation.fillMode = kCAFillModeForwards;
                    maskAnimation.removedOnCompletion = NO;
                    maskAnimation.toValue = [NSNumber numberWithFloat:0];
                    maskAnimation.duration = 0.3;
                    
                    [_MaskLayer2 addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    
                    [_effectView2.layer addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                        _effectView2.emitter.lifetime = 0;
                        _effectView2.alpha = 0;
                        
                    }completion:^(BOOL finished){
                    }];
                    
                    
                    
                    
                }
                else{
                    CABasicAnimation* maskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                    maskAnimation.fillMode = kCAFillModeForwards;
                    maskAnimation.removedOnCompletion = NO;
                    maskAnimation.toValue = [NSNumber numberWithFloat:-286];
                    maskAnimation.duration = 0.3;
                    
                    [_MaskLayer2 addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    
                    [_effectView2.layer addAnimation:maskAnimation forKey:@"transform.translation.x"];
                    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                        _effectView2.emitter.lifetime = 0;
                        _effectView2.alpha = 0;
                    }completion:^(BOOL finished){
                        
                        
                    }];
                    
                    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        _imageview3.center = CGPointMake(_imageview3.center.x, _imageview3.center.y-83);
                    }completion:nil];
                    
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
