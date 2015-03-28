//
//  ViewController.m
//  AKSComponentDemo
//
//  Created by Alden Keefe Sampson on 3/27/15.
//  Copyright (c) 2015 Alden Keefe Sampson. All rights reserved.
//


#import <ComponentKit/CKArrayControllerChangeset.h>
#import <ComponentKit/CKBackgroundLayoutComponent.h>
#import <ComponentKit/CKCollectionViewDataSource.h>
#import <ComponentKit/CKComponent.h>
#import <ComponentKit/CKComponentFlexibleSizeRangeProvider.h>
#import <ComponentKit/CKComponentProvider.h>
#import <ComponentKit/CKInsetComponent.h>
#import <ComponentKit/CKLabelComponent.h>

#import "ViewController.h"

@interface ViewController () <CKComponentProvider>

@property (nonatomic) CKCollectionViewDataSource* dataSource;
@property (nonatomic) CKComponentFlexibleSizeRangeProvider* sizeRangeProvider;

@end

@implementation ViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithCollectionViewLayout:layout];
  if (self) {
    self.sizeRangeProvider = [CKComponentFlexibleSizeRangeProvider providerWithFlexibility:CKComponentSizeRangeFlexibleHeight];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.collectionView.backgroundColor = [UIColor whiteColor];

  // This initializer sets the data source as the delegate of our collection view
  // We pass in self.class as the data source's component provider so our +componentForModel:context: will be called
  self.dataSource = [[CKCollectionViewDataSource alloc] initWithCollectionView:self.collectionView
                                                   supplementaryViewDataSource:nil                                                         
                                                             componentProvider:self.class
                                                                       context:nil
                                                     cellConfigurationFunction:nil];
  // insert first section
  CKArrayControllerSections sections;
  sections.insert(0);
  [self.dataSource enqueueChangeset:{sections, {}} constrainedSize:{}];

  // generate a few dummy model objects and insert rows for them into the first section
  CKArrayControllerInputItems items;
  for (NSInteger i = 0; i < 50; i++) {
    NSString* modelObject = [NSString stringWithFormat:@"I'm a simple model %ld", i];
    items.insert([NSIndexPath indexPathForRow:i inSection:0], modelObject);
  }
  [self.dataSource enqueueChangeset:{{}, items} constrainedSize:[self.sizeRangeProvider sizeRangeForBoundingSize:self.collectionView.bounds.size]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self.dataSource sizeForItemAtIndexPath:indexPath];
}

#pragma mark - CKComponentProvider

+ (CKComponent *)componentForModel:(id<NSObject>)model context:(id<NSObject>)context {
  NSString* text = (NSString*)model;
  // Return your custom cell components here
  return [CKInsetComponent
          newWithInsets:UIEdgeInsetsMake(5, 10, 5, 10)
          component:
          [CKBackgroundLayoutComponent
           newWithComponent:
           [CKLabelComponent
            newWithLabelAttributes:{
              .string = text,
              .color = [UIColor blackColor],
              .minimumLineHeight = 30, // give cells a little height
              .alignment = NSTextAlignmentCenter,
            }
            viewAttributes:{
              {@selector(setBackgroundColor:), [UIColor clearColor]},
              {@selector(setUserInteractionEnabled:), @NO},
            }]
           background:
           [CKComponent
            newWithView:{
              [UIView class],
              {{@selector(setBackgroundColor:), [UIColor colorWithWhite:0.9 alpha:1]}}
            }
            size:{.height = 100}]]];


}

@end
