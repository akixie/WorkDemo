//
//  TestViewController.m
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "TestViewController.h"
#import "TestHomeVModel.h"
#import "TestCell.h"

@interface TestViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [NSMutableArray array];
    
    // 数据源获取
    __weak __typeof(self)weakSelf = self;
    [TestHomeVModel fetchDataWithPage:1 success:^(NSArray *list) {
        [weakSelf.dataSource addObjectsFromArray:list];
        [weakSelf.mainTableView reloadData];
    }];
    
    // 测试修改数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TestHomeVModel *thvm = self.dataSource[1];
        [thvm pbv_updateKeyPath:@"name" usingValue:@"测试改变title"];
        [thvm pbv_updateKeyPath:@"poster_url" usingValue:@"http://f.hiphotos.baidu.com/image/h%3D360/sign=76a2918f0bb30f242a9aea05f894d192/a8014c086e061d9507500dd67ff40ad163d9cacd.jpg"];
    });

}

- (IBAction)refresh:(id)sender {
    // 数据源获取
    __weak __typeof(self)weakSelf = self;
    [TestHomeVModel fetchDataWithPage:2 success:^(NSArray *list) {
        [weakSelf.dataSource addObjectsFromArray:list];
        [weakSelf.mainTableView reloadData];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestHomeVModel *thvm = self.dataSource[indexPath.row];
    return thvm.rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    TestHomeVModel *thvm = self.dataSource[indexPath.row];
    [thvm pbv_bindView:cell];
    
    [thvm pbv_addBindKeyPathForBindView:@"titleLabel.text" withVMKeyPath:@"name"];
    [thvm pbv_addBindKeyPathForBindView:@"scoreLabel.text" withVMKeyPath:@"score"];
    [thvm pbv_addBindKeyPathForBindView:@"actorLabel.text" withVMKeyPath:@"director"];
    [thvm pbv_addBindKeyPathForBindView:@"actorLabel.text" withVMKeyPath:@"actor"];
    [thvm pbv_addBindKeyPathForBindView:@"subtitleLabel.text" withVMKeyPath:@"remark"];
    
    [thvm pbv_asyncAddBindKeyPathForBindView:@"headerImageView.image" withVMKeyPath:@"poster_url"];
    
    cell.lpointLabel.text = thvm.lookPoint;
    return cell;
}

- (void)dealloc
{
    NSLog(@"ViewController %@",NSStringFromSelector(_cmd));
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
