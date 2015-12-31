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

#import "NSBundle+JSQMessages.h"
#import <SDWebImage/UIImageView+WebCache.h>

const CGFloat kJSQMessagesLoadEarlierHeaderViewHeight = 265.0f;


@interface JSQMessagesLoadEarlierHeaderView () <SwipeViewDataSource, SwipeViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet UIButton *matchmakerButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UILabel *matchmakerReason;
@property (weak, nonatomic) IBOutlet UIImageView *matchmakerPicture;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *locationAndHeight;
@property (weak, nonatomic) IBOutlet UILabel *numberOfVouches;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (strong, nonatomic) NSMutableArray *picturesArr;
@property (weak, nonatomic) IBOutlet UIImageView *spacer;
@property (weak, nonatomic) IBOutlet UIImageView *vouchstamp;

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

    self.hidden = YES;
    self.picturesArr = [[NSMutableArray alloc] init];
    
    self.swipeView.dataSource = self;
    self.swipeView.itemsPerPage = 2;
    self.swipeView.bounces = false;
    
    self.matchmakerPicture.clipsToBounds = YES;
    self.matchmakerPicture.layer.cornerRadius = 12.5;
    
    self.spacer.image = [self jsq_ImageBundleWithName:@"spacer"];
    
    self.vouchstamp.image = [self jsq_ImageBundleWithName:@"vouchstamp"];
    
    
    self.backgroundColor = [UIColor clearColor];

    [self.loadButton setTitle:[NSBundle jsq_localizedStringForKey:@"load_earlier_messages"] forState:UIControlStateNormal];
    self.loadButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (void)configureUserContent:(NSDictionary *)user mmPhoto:(NSString *)mmPhoto mmReason:(NSString *)mmReason {
    self.picturesArr = user[@"picture_urls"];
    [self.swipeView reloadData];
    
    if (mmPhoto != nil && ![mmPhoto  isEqual: @""]) {
        [self.matchmakerPicture sd_setImageWithURL:[NSURL URLWithString:mmPhoto]];
    }
    if (mmReason != nil && ![mmReason  isEqual: @""]) {
        self.matchmakerReason.text = mmReason;
    }
    
//    if (user[@"city"] != nil && user[@"height"] != nil) {
//        self.locationAndHeight.text = [NSString stringWithFormat:@"%@ - ( %@ )",user[@"city"],user[@"height"]];
//    } else if (user[@"city"] == nil && user[@"height"] != nil) {
//        self.locationAndHeight.text = [NSString stringWithFormat:@"( %@ )",user[@"height"]];
//    } else if (user[@"city"] != nil && user[@"height"] == nil) {
//        self.locationAndHeight.text = [NSString stringWithFormat:@"%@",user[@"city"]];
//    }
    
    if (user[@"vouches_received"] != nil) {
        self.numberOfVouches.text = [NSString stringWithFormat:@"%lu vouches",(unsigned long)[user[@"vouches_received"] count]];
    } else {
        self.numberOfVouches.text = @"0";
    }
    self.hidden = NO;
}

- (UIImage *)jsq_ImageBundleWithName:(NSString *)name
{
    NSBundle *bundle = [NSBundle jsq_messagesAssetBundle];
    NSString *path = [bundle pathForResource:name ofType:@"png" inDirectory:@"Images"];
    return [UIImage imageWithContentsOfFile:path];
}

- (void)dealloc
{
    _loadButton = nil;
    _swipeView = nil;
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

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return [self.picturesArr count];
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
    [((UIImageView *)[[view viewWithTag:1] viewWithTag:2]) sd_setImageWithURL:[NSURL URLWithString:[self.picturesArr objectAtIndex:index]]];
    
    return view;
}


@end
