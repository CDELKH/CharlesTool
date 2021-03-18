//
//  DLDebugSetViewController.m
//  AFNetworking
//
//  Created by 郎烨 on 2020/12/14.
//

#import "DLDebugSetViewController.h"
#import "DLSettingTableViewCell.h"
#import "DLRequestsInfoViewController.h"
#import "DLDebugManager.h"
#import "DLProxySettingViewModel.h"
#import "CharlesTool.h"
#import "DLDomainIPMapManager.h"

@interface DLDebugSetViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;

@end

@implementation DLDebugSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏
    self.navigationBarView.titleLabel.text = @"代理抓包";
    //tableView
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [self nearByNavigationBarView:_tableView isShowBottom:NO];
    [self getDataSource:[DLDebugManager shareManager].supportDebug];
    [CharlesTool isShowDebugView:NO];
}

#pragma mark -tableView的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%@%ld",[self class],(long)indexPath.row];
    DLSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[DLSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    if (indexPath.row == 0) {
        cell.arrowImageView.hidden = YES;
        cell.rightSwitch.hidden = NO;
        cell.rightSwitch.on = [DLDebugManager shareManager].supportDebug;
        [cell.rightSwitch addTarget:self action:@selector(supportDebugingInterfaceAction:) forControlEvents:UIControlEventValueChanged];
    } else {
        cell.rightSwitch.hidden = YES;
        cell.arrowImageView.hidden = NO;
    }
    cell.contentLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        DLRequestsInfoViewController *proxySettingVC = [[DLRequestsInfoViewController alloc] init];
        [self.navigationController pushViewController:proxySettingVC animated:YES];
    } else if(indexPath.row == 2 ){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除信息" message:@"是否清除接口信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[DLDomainIPMapManager sharedInstance] clearRequestsInfoDic];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

// 开启调试接口
- (void)supportDebugingInterfaceAction:(UISwitch *)aSwitch {
    [[DLDebugManager shareManager] setDebuggingInterface:aSwitch.on];
    if ([DLDebugManager shareManager].supportDebug) {
        [CharlesTool isTurnOnDefaultDebugging:NO];
        [CharlesTool isShowDebugView:NO];
        [[CharlesTool sharedInstance] changeDebutonViewTitle:@""];
    }else{
        [DLProxySettingViewModel turnOffEnabledIP];
    }
    [self getDataSource:aSwitch.on];
}

- (void)getDataSource:(BOOL)isAllShow {
    if (isAllShow) {
        self.dataArray = @[@"开启抓包", @"请求信息", @"清理请求信息"];
    } else {
        self.dataArray = @[@"开启抓包"];
    }
    [self.tableView reloadData];
}

- (void)dealloc {
    [CharlesTool isShowDebugView:[DLDebugManager shareManager].supportDebug];
}

@end
