//
//  AvatarPickerView.m
//  Kelin
//
//  Created by Zhanserik on 10/15/15.
//  Copyright © 2015 Didara Pernebayeva. All rights reserved.
//

#import "AvatarPickerView.h"
#import "UIColor+AYHooks.h"
#import "AvatarPickerCollectionViewCell.h"

static NSString *kKelinColorCollectionViewCellIdentifier = @"kKelinCollectionViewCellIdentifier";
static NSString *kKelinImageCollectionViewCellIdentifier = @"kKelinImageCollectionViewCellIdentifier";

@interface AvatarPickerView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) UICollectionViewFlowLayout *colorLayout;
@property (nonatomic) UICollectionViewFlowLayout *imageLayout;

@property (nonatomic) UICollectionView *colorCollectionView;
@property (nonatomic) UICollectionView *imageCollectionView;

//@property (nonatomic) AKPickerView *imagePickerView;

@property (nonatomic) NSArray *colors;

@property (nonatomic) UIColor *selectionColor;

@end

@implementation AvatarPickerView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.imageLayout = [UICollectionViewFlowLayout new];
        self.imageLayout.minimumInteritemSpacing = 0;
        self.imageLayout.minimumLineSpacing = 0;
        self.imageLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect imageCVFrame = CGRectMake(0,
                                         0,
                                         CGRectGetWidth(frame),
                                         CGRectGetHeight(frame) / 2.f);

        self.imageCollectionView = [[UICollectionView alloc] initWithFrame:imageCVFrame
                                                      collectionViewLayout:self.imageLayout];
        self.imageCollectionView.delegate = self;
        self.imageCollectionView.dataSource = self;
        self.imageCollectionView.tag = 1;
        self.imageCollectionView.showsHorizontalScrollIndicator = NO;
        self.imageCollectionView.backgroundColor = [UIColor whiteColor];
        [self.imageCollectionView registerClass:[AvatarPickerCollectionViewCell class]
                     forCellWithReuseIdentifier:kKelinImageCollectionViewCellIdentifier];
        
        [self addSubview:self.imageCollectionView];

        
        self.colorLayout = [UICollectionViewFlowLayout new];
        self.colorLayout.minimumLineSpacing = 0;
        self.colorLayout.minimumInteritemSpacing = 0;
        self.colorLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect colorCVFrame = CGRectMake(0,
                                         CGRectGetHeight(frame) / 2.0f,
                                         CGRectGetWidth(frame),
                                         CGRectGetHeight(frame) / 2.0f);
        
        self.colorCollectionView = [[UICollectionView alloc] initWithFrame:colorCVFrame
                                                      collectionViewLayout:self.colorLayout];
        self.colorCollectionView.dataSource = self;
        self.colorCollectionView.delegate = self;
        self.colorCollectionView.tag = 2;
        self.colorCollectionView.showsHorizontalScrollIndicator = NO;
        self.colorCollectionView.backgroundColor = [UIColor whiteColor];
        [self.colorCollectionView registerClass:[AvatarPickerCollectionViewCell class]
                     forCellWithReuseIdentifier:kKelinColorCollectionViewCellIdentifier];
        
        [self addSubview:self.colorCollectionView];
        
        self.selectionColor = [UIColor blackColor];
        
        self.colors = @[@"54c7fc", @"ffcd00", @"ff9600", @"ff2851", @"0076ff", @"44dd5e", @"ff3824", @"8e8e93", @"1abc9c", @"8e44ad", @"e74c3c", @"2c3e50", @"f1c40f", @"e67e22"];
    }
    
    return self;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(collectionView.tag == 1){
        return 100;
    }
    
    return [self.colors count];
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(collectionView.tag == 1){
        AvatarPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kKelinImageCollectionViewCellIdentifier
                                                                                         forIndexPath:indexPath];
        
        NSString *fileName = [NSString stringWithFormat:@"animal%i.png", (int)indexPath.row];
        cell.imageView.image = [UIImage imageNamed:fileName];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionColor = self.selectionColor;
        return cell;
    }
    
    
    AvatarPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kKelinColorCollectionViewCellIdentifier
                                                                                                         forIndexPath:indexPath];
    
    NSString *colorName = self.colors[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:colorName];
    
    
    cell.selectionColor = self.selectionColor;
    
    return cell;
}

#pragma mark - <UICollectionViewDataDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag == 2){
        NSString *colorName = self.colors[indexPath.row];
    
        self.selectionColor = [UIColor colorWithHexString:colorName];
        
        NSArray *visibleCells = [self.imageCollectionView visibleCells];
        
        for (AvatarPickerCollectionViewCell *cell in visibleCells) {
            cell.selectionColor = self.selectionColor;
            if(cell.selected){
                cell.contentView.backgroundColor = [UIColor colorWithHexString:colorName];
            }
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetHeight(collectionView.frame),
                      CGRectGetHeight(collectionView.frame));
}
@end
