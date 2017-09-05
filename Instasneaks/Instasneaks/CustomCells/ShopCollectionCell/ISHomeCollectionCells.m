//
//  ISHomeCollectionCells.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 05/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISHomeCollectionCells.h"

@implementation ISHomeCollectionCells

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)showProductImageWithData:(NSArray *)productList{
    
    CGSize offset = CGSizeMake(2, 1);
    self.viewHomeCollection.layer.shadowOffset =  offset;
    self.viewHomeCollection.layer.shadowOpacity = 0.4;
    self.viewHomeCollection.layer.shadowRadius = 10.0;
    [self.viewHomeCollection.layer setMasksToBounds:NO];

    switch (productList.count) {
        case 0:
        {
            [self.imageView_productOne setHidden:YES];
            [self.imageView_productTwo setHidden:YES];
            [self.imageView_productThree setHidden:YES];
            [self.imageView_productFour setHidden:YES];
            [self.itemOneBtn setHidden:YES];
            [self.itemTwoBtn setHidden:YES];
            [self.itemThreeBtn setHidden:YES];
            [self.itemFourBtn setHidden:YES];
        }
            break;
        case 1:
        {
            [self.imageView_productOne setHidden:NO];
            [self.imageView_productTwo setHidden:YES];
            [self.imageView_productThree setHidden:YES];
            [self.imageView_productFour setHidden:YES];
            [self.itemOneBtn setHidden:NO];
            [self.itemTwoBtn setHidden:YES];
            [self.itemThreeBtn setHidden:YES];
            [self.itemFourBtn setHidden:YES];
            ISUserInfo * infoObj = [productList objectAtIndex:0];
            [self.imageView_productOne sd_setImageWithURL:[NSURL URLWithString:infoObj.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
        }
            break;
        case 2:
        {
            [self.imageView_productOne setHidden:NO];
            [self.imageView_productTwo setHidden:NO];
            [self.imageView_productThree setHidden:YES];
            [self.imageView_productFour setHidden:YES];
            [self.itemOneBtn setHidden:NO];
            [self.itemTwoBtn setHidden:NO];
            [self.itemThreeBtn setHidden:YES];
            [self.itemFourBtn setHidden:YES];
            [self.imageView_productOne sd_setImageWithURL:[NSURL URLWithString:((ISUserInfo*)[productList objectAtIndex:0]).image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
            [self.imageView_productTwo sd_setImageWithURL:[NSURL URLWithString:((ISUserInfo*)[productList objectAtIndex:1]).image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];

        }
            break;
        case 3:
        {
            [self.imageView_productOne setHidden:NO];
            [self.imageView_productTwo setHidden:NO];
            [self.imageView_productThree setHidden:NO];
            [self.imageView_productFour setHidden:YES];
            [self.itemOneBtn setHidden:NO];
            [self.itemTwoBtn setHidden:NO];
            [self.itemThreeBtn setHidden:NO];
            [self.itemFourBtn setHidden:YES];
            [self.imageView_productOne sd_setImageWithURL:[NSURL URLWithString:((ISUserInfo*)[productList objectAtIndex:0]).image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
            [self.imageView_productTwo sd_setImageWithURL:[NSURL URLWithString:((ISUserInfo*)[productList objectAtIndex:1]).image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
            [self.imageView_productThree sd_setImageWithURL:[NSURL URLWithString:((ISUserInfo*)[productList objectAtIndex:2]).image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];

        }
            break;
        case 4:
        {
            [self.imageView_productOne setHidden:NO];
            [self.imageView_productTwo setHidden:NO];
            [self.imageView_productThree setHidden:NO];
            [self.imageView_productFour setHidden:NO];
            [self.itemOneBtn setHidden:NO];
            [self.itemTwoBtn setHidden:NO];
            [self.itemThreeBtn setHidden:NO];
            [self.itemFourBtn setHidden:NO];
            [self.imageView_productOne sd_setImageWithURL:[NSURL URLWithString:((ISUserInfo*)[productList objectAtIndex:0]).image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
            [self.imageView_productTwo sd_setImageWithURL:[NSURL URLWithString:((ISUserInfo*)[productList objectAtIndex:1]).image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
            [self.imageView_productThree sd_setImageWithURL:[NSURL URLWithString:((ISUserInfo*)[productList objectAtIndex:2]).image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
            [self.imageView_productFour sd_setImageWithURL:[NSURL URLWithString:((ISUserInfo*)[productList objectAtIndex:3]).image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
        }
            break;
        default:
            break;
    }
}

@end
