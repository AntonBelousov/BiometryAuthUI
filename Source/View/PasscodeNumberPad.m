//
//  PasscodeNumberPad.m
//  
//
//  Created by Anton Belousov on 12.03.2018.
//  Copyright © 2018 ab. All rights reserved.
//

#import "PasscodeNumberPad.h"
#import "PasscodeNumberPadCell.h"

@interface PasscodeNumberPad () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation PasscodeNumberPad

- (void)awakeFromNib {
    [super awakeFromNib];
    _deleteBackwardsButtonHidden = YES;
    [self setupCollectionView];
}

- (void)prepareForInterfaceBuilder {
    self.biometryType = BiometryTypeTouchID;
    _deleteBackwardsButtonHidden = NO;
    [self setupCollectionView];
}

- (void)setDeleteBackwardsButtonHidden:(BOOL)deleteBackwardsButtonHidden {

    BOOL oldValue = _deleteBackwardsButtonHidden;
    _deleteBackwardsButtonHidden = deleteBackwardsButtonHidden;
    
    if (deleteBackwardsButtonHidden != oldValue) {
        [_collectionView reloadData];
    }
}

- (void)setBiometryType:(BiometryType)biometryType {
    _biometryType = biometryType;
    [_collectionView reloadData];
}

- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.backgroundColor = UIColor.clearColor;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    NSBundle *bundle  = [NSBundle bundleForClass:self.class];
    [collectionView registerNib:[UINib nibWithNibName:@"PasscodeNumberPadCell" bundle:bundle] forCellWithReuseIdentifier:@"cell"];
    
    [self addSubview:collectionView];
    _collectionView = collectionView;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[childView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:@{@"childView": _collectionView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[childView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:@{@"childView": _collectionView}]];
    
    [_collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UICollectionViewFlowLayout *layout = (id)_collectionView.collectionViewLayout;
    
    CGFloat itemWidth                 = 78;
    layout.itemSize                   = CGSizeMake(itemWidth, itemWidth);
    layout.minimumInteritemSpacing    = (self.bounds.size.width - 3 * itemWidth)/2;
    layout.minimumLineSpacing         = (self.bounds.size.height - 4 * itemWidth)/3;
    layout.sectionInset               = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PasscodeNumberPadCell *cell = (id)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.tintColor = self.tintColor;
    if (indexPath.row < 9) {
        [cell configureWithNumber:indexPath.row + 1];
    } else if (indexPath.row == 9) {
        if (_biometryType != BiometryTypeNone) {
            [cell configureAsBiometryButtonForType:self.biometryType];
        } else {
            [cell configureAsHiddenCell];
        }
    } else if (indexPath.row == 10) {
        [cell configureWithNumber:0];
    } else {
        if (_deleteBackwardsButtonHidden) {
            [cell configureAsHiddenCell];
        } else {
            [cell configureAsBackspace];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row < 9) {
        [self.delegate passcodeNumberPadDidSelectNumber:indexPath.row + 1];
    } else if (indexPath.row == 9) {
        if (_biometryType != BiometryTypeNone) {
            [self.delegate passcodeNumberPadDidSelectBiometry];
        }
    } else if (indexPath.row == 10) {
        [self.delegate passcodeNumberPadDidSelectNumber:0];
    } else {
        if (!_deleteBackwardsButtonHidden) {
            [self.delegate passcodeNumberPadShouldDeleteBacwards];
        }
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    [self.collectionView reloadData];
}

@end
