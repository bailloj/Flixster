//
//  MoviesViewController.swift
//  Flixster
//
//  Created by Jireh Grace Baillo on 3/19/19.
//  Copyright © 2019 CodePathProgram2. All rights reserved.
//

//-------------------------- Note: Comments are for code below it ---------------------------//
import UIKit
import AlamofireImage
//Step 2: Add UITableViewDelegate, UITableViewDataSource
class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //Step 1: Create Outlet to Table View
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Step 4: Call the 2 required functions first using the statements below
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                //Step 5: Reload the tableView to get data from the API about movies (movies.count)
                self.tableView.reloadData()
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()
    }
    
    //Step 3: Implement the 2 required functions below
    //func1
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returns number of cells
        return movies.count
    }
    
    //func2: func2 gets called by (# returned by func1) times
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell // Creates a new/ reuses cell and casts as MovieCell (Access it like MovieCell)
        let movie = movies[indexPath.row] // Sets movie to movie at specific index in movies
        let title = movie["title"] as! String // Sets title as the title of the specific movie and casts it  as String
        let synopsis = movie["overview"] as! String // Sets synopsis as the overview of the movie and casts it as String
        
        cell.titleLabel!.text = title // Displays the title as a titleLabel for the cell
        cell.synopsisLabel!.text = synopsis // Displays the synopsis as a synopsisLabel for the cell
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
