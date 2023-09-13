//
//  TvSeriesManager.swift
//  ThirdAssignment
//
//  Created by Ali Bahadir Sensoz on 20.07.2023.
//

import Foundation



class TvSeriesManager {
    
    
    let TvSeriesURL = "https://api.tvmaze.com/search/shows?q="
    var decodedData : [TVDataModel] = []
    func fetchTvSeries(tvSeriesName : String){
        let urlString = "\(TvSeriesURL)\(tvSeriesName)"
        performRequest(urlString: urlString)
        print(urlString)
    }
    

    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self else { return }

                if error != nil {
                    print(error!)
                    return
                }

                if let safeData = data {
                    self.parseJSON(tvData: safeData) { decodedData in
                        // Update the instance's decodedData property with the parsed data
                        self.decodedData = decodedData
                    }
                    print(decodedData.count)
                }
            }
            
            task.resume()
        }
    }

    
    func parseJSON(tvData: Data, completion: @escaping ([TVDataModel]) -> Void)
    {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([TVDataModel].self, from: tvData)
            for tvSeries in decodedData {
                let name : String? = tvSeries.show?.name
                let type : String? = tvSeries.show?.type
                let img = tvSeries.show?.image?.original
                completion(decodedData)

               // let [TVSeries] = [TVData](show.name: name, show.type: type, show.image.original: img)
                //return [TVSeries]
                print(name)
                print(type)
                print(img)

           }
        } catch {
            print(error)
            completion([])
        }
        let numOfSearch : Int = decodedData.count
        print(numOfSearch)
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?){
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            self.parseJSON(tvData: safeData) { [weak self] decodedData in
                guard let self = self else { return }

                // Update the instance's decodedData property with the parsed data
                self.decodedData = decodedData
            }
            //print(safeData.count)
            //print(decodedData[0])
        }
    }
}
