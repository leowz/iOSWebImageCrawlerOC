//
//  ViewController.h
//  CS4962ServerInteraction
//
//  Created by WENGzhang on 14/05/2017.
//  Copyright © 2017 WENGzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSString *urlString;
@end

