//
//  SelectProductImageViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/9/12.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SelectProductImageViewController.h"
#import "Manager.h"
@interface SelectProductImageViewController ()

@end

@implementation SelectProductImageViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Manager *manager = [Manager shareInstance];
    
    [manager uploadImageWithUploadImage:[UIImage imageNamed:@"test"] withUploadSuccess:^(id successResult) {
        
    } withUploadFail:^(NSString *failResultStr) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
