#import "PubgLoad.h"
#import "ImGuiDrawView.h"

@implementation PubgLoad

+ (void)setMenuVisible:(BOOL)visible {
}

+ (void)load {
    static PubgLoad *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PubgLoad alloc] init];
        [sharedInstance bootstrapOverlay];
    });
}

- (void)bootstrapOverlay {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.vna = [[ImGuiDrawView alloc] init];
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        if (keyWindow && keyWindow.rootViewController) {
            [keyWindow.rootViewController addChildViewController:self.vna];
            [keyWindow.rootViewController.view addSubview:self.vna.view];
            [self.vna didMoveToParentViewController:keyWindow.rootViewController];
        }
        [self.vna viewDidLoad];
        [self setupMenuButton];
    });
}

- (void)setupMenuButton {
    // Đổi kích thước lớn hơn (60x60) và đặt ở vị trí dễ thấy bên cạnh trái màn hình ngang
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame = CGRectMake(20, 120, 60, 60);
    self.menuButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.9];
    self.menuButton.layer.cornerRadius = 30.0;
    self.menuButton.layer.borderWidth = 2.0;
    self.menuButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.menuButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.menuButton.layer.shadowRadius = 4.0;
    self.menuButton.layer.shadowOpacity = 0.5;
    
    [self.menuButton setTitle:@"MENU" forState:UIControlStateNormal];
    [self.menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.menuButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    
    // Thêm sự kiện bấm và sự kiện kéo thả (Pan Gesture) để không bị che khuất vị trí
    [self.menuButton addTarget:self action:@selector(handleMenuButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleButtonPan:)];
    [self.menuButton addGestureRecognizer:panGesture];
    
    // Đảm bảo nút được ép nằm ở cửa sổ trên cùng của ứng dụng (trên cả Unity view)
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (window.isKeyWindow) {
            keyWindow = window;
            break;
        }
    }
    if (!keyWindow) {
        keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    
    if (keyWindow) {
        [keyWindow addSubview:self.menuButton];
        [keyWindow bringSubviewToFront:self.menuButton];
    }
}

// Cho phép kéo thả nút menu đi khắp màn hình để dễ thao tác
- (void)handleButtonPan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.menuButton.superview];
    CGPoint center = self.menuButton.center;
    self.menuButton.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.menuButton.superview];
}

- (void)handleMenuButtonTap:(id)sender {
    self.menuVisible = !self.menuVisible;
    [ImGuiDrawView showChange:self.menuVisible];
    NSLog(@"[SicBoMod] Đã bấm nút mở Menu. Trạng thái: %d", self.menuVisible);
}

@end
