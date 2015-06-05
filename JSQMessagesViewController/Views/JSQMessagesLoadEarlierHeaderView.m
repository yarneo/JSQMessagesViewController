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


#import "JSQMessagesLoadEarlierHeaderView.h"

#import "NSBundle+JSQMessages.h"
#import <SwipeView/SwipeView.h>
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>

const CGFloat kJSQMessagesLoadEarlierHeaderViewHeight = 240.0f;


@interface JSQMessagesLoadEarlierHeaderView () <SwipeViewDataSource, SwipeViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet SwipeView *swipeView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameAndAge;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *locationAndHeight;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (strong, nonatomic) NSMutableArray *picturesArr;

@property (strong, nonatomic) IDMPhotoBrowser *mediaFocusController;

- (IBAction)loadButtonPressed:(UIButton *)sender;

@end



@implementation JSQMessagesLoadEarlierHeaderView

#pragma mark - Class methods

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([JSQMessagesLoadEarlierHeaderView class])
                          bundle:[NSBundle bundleForClass:[JSQMessagesLoadEarlierHeaderView class]]];
}

+ (NSString *)headerReuseIdentifier
{
    return NSStringFromClass([JSQMessagesLoadEarlierHeaderView class]);
}

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.picturesArr = [[NSMutableArray alloc] init];
    
    self.swipeView.delegate = self;
    self.swipeView.dataSource = self;
    self.swipeView.itemsPerPage = 2;
    self.swipeView.bounces = false;
    
    [self.picturesArr addObject:@"matchmaker1.png"];
    [self.picturesArr addObject:@"matchmaker2.png"];
    [self.picturesArr addObject:@"matchmaker3.png"];
    [self.picturesArr addObject:@"matchmaker4.png"];
    [self.picturesArr addObject:@"matchmaker5.png"];
    
    [self.swipeView reloadData];
    
    
    self.backgroundColor = [UIColor clearColor];

    [self.loadButton setTitle:[NSBundle jsq_localizedStringForKey:@"load_earlier_messages"] forState:UIControlStateNormal];
    self.loadButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (void)dealloc
{
    _loadButton = nil;
    _delegate = nil;
}

#pragma mark - Reusable view

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.loadButton.backgroundColor = backgroundColor;
}

#pragma mark - Actions

- (IBAction)loadButtonPressed:(UIButton *)sender
{
    [self.delegate headerView:self didPressLoadButton:sender];
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    //    NSArray *photos = [IDMPhoto photosWithFilePaths:self.picturesArr];
    //    self.mediaFocusController = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:[swipeView itemViewAtIndex:index]];
    //    [self presentViewController:self.mediaFocusController animated:YES completion:nil];
    
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return [self.picturesArr count];
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return CGSizeMake(self.swipeView.frame.size.height+20, self.swipeView.frame.size.height+20);
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIView *shadowView = nil;
    UIView *cornerView = nil;
    
    if(view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, swipeView.frame.size.height+20, swipeView.frame.size.height+20)];
        
        shadowView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, swipeView.frame.size.height, swipeView.frame.size.height)];
        shadowView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        shadowView.layer.shadowOffset = CGSizeZero;
        shadowView.layer.shadowOpacity = 0.5;
        shadowView.layer.shadowRadius = 3;
        shadowView.tag = 1;
        
        cornerView = [[UIImageView alloc] initWithFrame:shadowView.bounds];
        cornerView.backgroundColor = [UIColor whiteColor];
        cornerView.layer.cornerRadius = swipeView.frame.size.height/30;
        cornerView.layer.borderColor = [UIColor grayColor].CGColor;
        cornerView.layer.borderWidth = 0.5;
        cornerView.clipsToBounds = YES;
        cornerView.tag = 2;
        
        [shadowView addSubview:cornerView];
        [view addSubview:shadowView];
        
        cornerView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    ((UIImageView *)[[view viewWithTag:1] viewWithTag:2]).image = [UIImage imageNamed:[self.picturesArr objectAtIndex:index]];
    
    return view;
}


@end
