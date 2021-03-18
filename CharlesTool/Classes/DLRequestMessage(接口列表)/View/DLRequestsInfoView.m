//
//  DLRequestsInfoView.m
//  NetSchool
//
//  Created by konghui on 2020/11/10.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLRequestsInfoView.h"
#import "DLRequestsInfoViewModel.h"
#import "DLRequestsInfoCell.h"
#import "CommUtls.h"

#define REQUEST_INFO_SEARCH_AERA_HEIGHT 44

@interface DLRequestsInfoView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) DLRequestsInfoViewModel *viewModel;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UITableView *mainTable;

@end

@implementation DLRequestsInfoView

- (void)dealloc{
    [self removeObserver];
}

- (instancetype)initWithViewModel:(DLRequestsInfoViewModel *)viewModel{
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        
        [self addViews];
        [self addObserver];
        [self bindSignals];
    }
    return self;
}

- (void)addSearchAreaView{
    UIView *searchAreaView = [[UIView alloc] init];
    [self addSubview:searchAreaView];
    [searchAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(- 15);
        make.height.mas_equalTo(32);
        make.top.mas_equalTo((REQUEST_INFO_SEARCH_AERA_HEIGHT - 32) / 2);
    }];
    
    UIView *backgroudView = [[UIView alloc] init];
    backgroudView.backgroundColor = [CommUtls colorWithHexString:@"#f1f1f1"];
    backgroudView.layer.cornerRadius = 16;
    [searchAreaView addSubview:backgroudView];
    [backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(searchAreaView);
    }];
    
    UITextField *searchTextField = [[UITextField alloc] init];
    searchTextField.font = [UIFont systemFontOfSize:14];
    searchTextField.textColor = [CommUtls colorWithHexString:@"#222222"];
    NSString *placeholder = @"输入搜索内容";
    searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : [CommUtls colorWithHexString:@"#999999"]}];
    searchTextField.clearButtonMode = UITextFieldViewModeNever;
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.delegate = self;
    //textFiled leftView用
    CGSize leftImageSize = CGSizeMake(14, 14);
    CGFloat leftImageSpacing = 8;
    NSString *leftImageName = @"charlesTool_nav_icon_ss";
    //右侧按钮用
    CGFloat rightButtonWidth = 44;
    @weakify(self)
    RACCommand *rightButtonCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        searchTextField.text = @"";
        [self.viewModel searchRequestWithText:@""];
        return [RACSignal empty];
    }];
    NSString *rightButtonImageName = @"charlesTool_searchbar_clean";
    //textFiled leftView
    UIView *textFieldLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftImageSize.width + leftImageSpacing, leftImageSize.height)];
    UIImageView *textFieldLeftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:leftImageName]];
    textFieldLeftImage.frame = CGRectMake(0, 0, leftImageSize.width, leftImageSize.height);
    [textFieldLeftView addSubview:textFieldLeftImage];
    searchTextField.leftView = textFieldLeftView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    //rightButton
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:rightButtonImageName] forState:UIControlStateNormal];
    rightButton.rac_command = rightButtonCommand;
    rightButton.hidden = YES;
    [backgroudView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroudView);
        make.width.mas_equalTo(rightButtonWidth);
        make.top.bottom.equalTo(backgroudView);
    }];
    [backgroudView addSubview:searchTextField];
    [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroudView).offset(15);
        make.right.equalTo(backgroudView).offset(- (rightButtonWidth + 8));
        make.centerY.equalTo(backgroudView);
    }];
    self.rightButton = rightButton;
    self.searchTextField = searchTextField;
}

- (void)addViews{
    [self addSearchAreaView];
    
    UITableView *mainTable = [[UITableView alloc] initWithFrame:CGRectZero];
    [mainTable registerClass:[DLRequestsInfoCell class] forCellReuseIdentifier:NSStringFromClass([DLRequestsInfoCell class])];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self addSubview:mainTable];
    [mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(REQUEST_INFO_SEARCH_AERA_HEIGHT);
        make.left.right.bottom.equalTo(self);
    }];
    self.mainTable = mainTable;
}

- (void)bindSignals{
    @weakify(self)
    [self.viewModel.reloadSignal subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self.mainTable reloadData];
        });
    }];
}

#pragma mark -textfield observe
//文字改变的监听 不只是正常的键盘输入，还有键盘上方的选项输入条
- (void)addObserver{
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)removeObserver{
    [self.searchTextField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(NSNotification *)notification
{
    if (self.searchTextField.markedTextRange == nil) {
        if ([self.searchTextField.text length] == 0) {
            self.rightButton.hidden = YES;
        }else{
            self.rightButton.hidden = NO;
        }
    }
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTextField resignFirstResponder];
    
    [self.viewModel searchRequestWithText:textField.text];
    
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numberOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLRequestsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DLRequestsInfoCell class])];
    if (cell == nil) {
        cell = [[DLRequestsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DLRequestsInfoCell class])];
    }
    cell.requestInfo = [self.viewModel getRequestInfoItemAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.viewModel getRequestInfoItemAtIndexPath:indexPath];
    [self.viewModel.jumpToDetailSignal sendNext:dict];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewModel heightForRowAtIndexPath:indexPath];
}

@end
