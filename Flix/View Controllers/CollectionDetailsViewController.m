//
//  CollectionDetailsViewController.m
//  Flix
//
//  Created by Abby Li on 6/24/21.
//

#import "CollectionDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface CollectionDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation CollectionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //gets movie poster
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    
    if ([self.movie[@"poster_path"] isKindOfClass:[NSString class]]) {
        NSString *posterURLString = self.movie[@"poster_path"];
        NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
        
        NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        self.posterView.image = nil;
        [self.posterView setImageWithURL:posterURL];
    }
    else {
        self.posterView.image = nil;
    }
    
    //loads backdrop
    if ([self.movie[@"backdrop_path"] isKindOfClass:[NSString class]]) {
        NSString *backdropURLString = self.movie[@"backdrop_path"];
        NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
        [self.backdropView setImageWithURL:backdropURL];
    }
    else {
        self.backdropView.image = nil;
    }
    
    //sets title, release date, and synopsis
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.dateLabel.text = self.movie[@"release_date"];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    [self.dateLabel sizeToFit];
    
    //adds border to poster
    self.posterView.layer.borderWidth = 2;
    self.posterView.layer.borderColor = [UIColor whiteColor].CGColor;
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
