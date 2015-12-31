//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesTypingIndicatorFooterView.h"

#import "JSQMessagesBubbleImageFactory.h"

#import "UIImage+JSQMessages.h"

#import <SDWebImage/UIImageView+WebCache.h>

const CGFloat kJSQMessagesTypingIndicatorFooterViewHeight = 46.0f;


@interface JSQMessagesTypingIndicatorFooterView ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *smallCircle;
@property (weak, nonatomic) IBOutlet UIView *mediumCircle;
@property (weak, nonatomic) IBOutlet UIView *largeCircle;

@end



@implementation JSQMessagesTypingIndicatorFooterView

#pragma mark - Class methods

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([JSQMessagesTypingIndicatorFooterView class])
                          bundle:[NSBundle bundleForClass:[JSQMessagesTypingIndicatorFooterView class]]];
}

+ (NSString *)footerReuseIdentifier
{
    return NSStringFromClass([JSQMessagesTypingIndicatorFooterView class]);
}

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
//    self.typingIndicatorImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)dealloc
{
    _avatarImageView = nil;
    _smallCircle = nil;
    _mediumCircle = nil;
    _largeCircle = nil;
}

#pragma mark - Reusable view

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}

#pragma mark - Typing indicator

-(void)configureNewTypingIndicator:(NSString *)avatar {
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 10;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatar]];
    
    self.largeCircle.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    self.largeCircle.alpha = 0;
    self.largeCircle.clipsToBounds = YES;
    self.largeCircle.layer.cornerRadius = 20;

    self.mediumCircle.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
    self.mediumCircle.alpha = 0;
    self.mediumCircle.clipsToBounds = YES;
    self.mediumCircle.layer.cornerRadius = 16.5;
    
    self.smallCircle.backgroundColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1];
    self.smallCircle.alpha = 0;
    self.smallCircle.clipsToBounds = YES;
    self.smallCircle.layer.cornerRadius = 13.5;
    
    [self bringSubviewToFront:self.avatarImageView];
    
    [UIView animateKeyframesWithDuration:1 delay:0.0 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.333 animations:^{
            self.smallCircle.alpha = 1;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.333 relativeDuration:0.333 animations:^{
            self.mediumCircle.alpha = 1;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.666 relativeDuration:0.334 animations:^{
            self.largeCircle.alpha = 1;
        }];
    } completion:nil];
    
}

- (void)configureWithEllipsisColor:(UIColor *)ellipsisColor
                messageBubbleColor:(UIColor *)messageBubbleColor
               shouldDisplayOnLeft:(BOOL)shouldDisplayOnLeft
                 forCollectionView:(UICollectionView *)collectionView
{
}

@end
