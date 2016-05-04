//
//  ViewController.m
//  断点读取
//
//  Created by 大展 on 16/3/24.
//  Copyright © 2016年 张展. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.myImageView layoutIfNeeded];

//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];// 毛玻璃视图

//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    // 毛玻璃的大小
//    effectView.frame = self.myImageView.bounds;
//    effectView.alpha = 0.5f;


//    [self.myImageView addSubview:effectView];

    NSMutableData *imageData = [NSMutableData data];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSString *imageUrl = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];

        // 从文件中读取
        NSFileHandle * handle = [NSFileHandle fileHandleForReadingFromURL:[NSURL fileURLWithPath:imageUrl] error:nil];
        // 每次读取得data
        NSData *readData = nil;

        // 读取次数
        int i = 0;
        do {

            //偏移量，第一次从0读到100 第二次就是从100-200
            [handle seekToFileOffset:i*1000];

            readData = [handle readDataOfLength:1000];

            [imageData appendData:readData];

            dispatch_sync(dispatch_get_main_queue(), ^{

                self.myImageView.image = [UIImage imageWithData:imageData];
            });
            
            i++;
        } while (readData.length == 1000);
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
