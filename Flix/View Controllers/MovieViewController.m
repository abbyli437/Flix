//
//  MovieViewController.m
//  Flix
//
//  Created by Abby Li on 6/23/21.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "MBProgressHUD.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property bool showLoading;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.activityIndicator startAnimating];
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               [self noNetworkAction];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               self.movies = dataDictionary[@"results"];
               
               [self.tableView reloadData];
           }
        [self.refreshControl endRefreshing];
        sleep(1.);
        [self.activityIndicator stopAnimating];
       }];
    
    [task resume];
}

- (void)noNetworkAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
        message:@"The Internet connection appears to be offline."
        preferredStyle:(UIAlertControllerStyleAlert)];

    // create a Try Again action
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action)
    {
        [self.activityIndicator startAnimating];
        [self fetchMovies];
    }];
    [alert addAction:tryAgainAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    
    if ([movie[@"poster_path"] isKindOfClass:[NSString class]]) {
        NSString *posterURLString = movie[@"poster_path"];
        NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
        
        NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        cell.posterView.image = nil;
        [cell.posterView setImageWithURL:posterURL];
    }
    else {
        cell.posterView.image = nil;
    }
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}


@end
