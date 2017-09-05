//
//  ISPagination.h
//  Instasneaks
//
//  Created by Suresh patel on 24/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface ISPagination : ISParserModel


@property (nonatomic, assign) NSInteger current_page;
@property (nonatomic, assign) NSInteger page_size;
@property (nonatomic, assign) NSInteger total_pages;

@end
