//
//  Team_memberinfo.swift
//  Cteemo
//
//  Created by bintao on 15/4/22.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

struct userloldata {

    var id = Int()
    var game = Int()
    var win = String()
    var kda = String()
    init() {
        id = 0
        win = ""
        kda = ""
        game = 0
    }
    
}

struct totaldata {
    
   
    var game = Int()
    var penta = Int()
    var goldpergame = String()
    var killspergame = String()
    var win = String()
    var kda = String()
    init() {
        goldpergame = ""
        killspergame = ""
        win = ""
        kda = ""
        penta = 0
        game = 0
    }
    
}

class Team_memberinfo: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var number = 0
    var id = ""
    
    var school = ""
    var name = ""
    var team = ""
    var lolid = ""
    var rank = ""
    var lolname = ""
    var iconurl = ""
    var usericon: UIImage!
    
    var userLoLinfo :[userloldata] = []
    var userlolTotal = totaldata()
    
    var male = true

    @IBOutlet var resulttabel: UITableView!
    
    
    override func viewDidAppear(animated: Bool) {
        
        
        
        
    }
    

    override func viewDidLoad() {
      
        self.resulttabel.delegate = self
        self.resulttabel.dataSource = self
        resulttabel.backgroundColor = UIColor.clearColor()
        
        var req = request(.GET, "http://54.149.235.253:5000/view_profile/" + self.id)
            .responseJSON { (_, _, JSONdata, _) in
                if JSONdata != nil {
                    let myjson = JSON(JSONdata!)
                    
                    println(myjson)
                    
                    if let newschool = myjson["school"].string{
                        
                        self.school = newschool
                        
                    }
                    
                    if let newteam = myjson["LOLTeam"].string{
                        
                        self.team = newteam
                        
                    }
                    
                    if let newname = myjson["username"].string{
                        
                        self.name = newname
                        
                    }
                    if let newlolid = myjson["hstoneID"].string{
                        
                        self.lolid = newlolid
                        
                    }
                    
                    if let newrank = myjson["dotaID"].string{
                        
                        self.rank = newrank
                        
                    }
                    
                    
                    if let newlolname = myjson["lolID"].string{
                        
                        self.lolname = newlolname
                        
                    }
                    
                    if let newicon = myjson["profile_icon"].string{
                        
                        self.iconurl = newicon
                        ImageLoader.sharedLoader.imageForUrl(newicon, completionHandler:{(image: UIImage?, url: String) in
                            println(url)
                            if image? != nil {
                                self.usericon = image?.roundCornersToCircle()
                            }
                            else {
                                self.usericon = UIImage(named: "error.png")!
                            }})
                        
                    }
                    
                    
                    if let newmale = myjson["intro"].string{
                        if newmale == "Female"{
                            
                            self.male = false
                            
                        }else{
                            
                            self.male = true
                            
                        }
                        
                        
                    }
                    // male
                    
                    var req = request(.GET, "https://na.api.pvp.net/api/lol/na/v1.3/stats/by-summoner/"+self.lolid + "/ranked?season=SEASON2015&api_key=" + LolAPIGlobal.key)
                        .responseJSON { (_, _, JSONdata, _) in
                            if JSONdata != nil {
                                let myjson = JSON(JSONdata!)
                                
                                self.number = myjson["champions"].count
                                
                                for i in 0...myjson["champions"].count-1{
                                    
                                    var champion = userloldata()
                                    
                                    if let id = myjson["champions"][i]["id"].int
                                    {
                                        if id != 0 {
                                            champion.id = id
                                            
                                            if let total = myjson["champions"][i]["stats"]["totalSessionsPlayed"].int{
                                                if total != 0 {
                                                    
                                                    champion.game = total
                                                    if let win = myjson["champions"][i]["stats"]["totalSessionsWon"].int{
                                                        
                                                        champion.win = String(format:"%.2f %", (Double(win)/Double(total)) * 100) + " %"
                                                        
                                                    }//win ratio
                                                    
                                                  
                                                }// total 0
                                            }//
                                            
                                            
                                            if let death = myjson["champions"][i]["stats"]["totalDeathsPerSession"].int{
                                                var kills = 0
                                                var assist = 0
                                                
                                                if let kill = myjson["champions"][i]["stats"]["totalChampionKills"].int{
                                                    kills = kill
                                                }
                                                
                                                
                                                if let ass = myjson["champions"][i]["stats"]["totalAssists"].int{
                                                    
                                                    assist = ass
                                                    
                                                }
                                                
                                                if death != 0 {
                                                    
                                                    champion.kda = String(format:"%.2f", Double(kills + assist) / Double(death))
                                                    
                                                    
                                                    
                                                    
                                                    
                                                }else{
                                                    
                                                    champion.kda = String(format:"%.2f ", Double(kills + assist))
                                                    
                                                }
                                                
                                            }//kda
                                            
                                            
                                        }//id != 0
                                            
                                        else{// id = 0
                                            
                                            if let total = myjson["champions"][i]["stats"]["totalSessionsPlayed"].int{
                                                if total != 0 {
                                                    
                                                    self.userlolTotal.game = total
                                                    
                                                    if let win = myjson["champions"][i]["stats"]["totalSessionsWon"].int{
                                                        
                                                        self.userlolTotal.win = String(format:"%.2f %", (Double(win)/Double(total)) * 100) + " %"
                                                        
                                                    }//win ratio
                                                    
                                                    if let gold = myjson["champions"][i]["stats"]["totalGoldEarned"].int{
                                                       
                                                        println(gold)
                                                         self.userlolTotal.goldpergame = String(format:"%.2f %", Double(gold)/Double(total))
                                                        
                                                        println(self.userlolTotal.goldpergame )
                                                    }//win ratio
                                                    
                                                    if let kills = myjson["champions"][i]["stats"]["totalChampionKills"].int{
                                                       
                                                       
                                                        self.userlolTotal.killspergame = String(format:"%.2f %", Double(kills)/Double(total))
                                                        
                                                    }// damage
                                                    
                                                }// total 0
                                            }//
                                            
                                            if let penta = myjson["champions"][i]["stats"]["totalPentaKills"].int{
                                                
                                                 self.userlolTotal.penta = penta
                                                
                                            }
                                            
                                            
                                           
                                            if let death = myjson["champions"][i]["stats"]["totalDeathsPerSession"].int{
                                                var kills = 0
                                                var assist = 0
                                                
                                                if let kill = myjson["champions"][i]["stats"]["totalChampionKills"].int{
                                                    kills = kill
                                                }
                                                
                                                
                                                if let ass = myjson["champions"][i]["stats"]["totalAssists"].int{
                                                    
                                                    assist = ass
                                                    
                                                }
                                                
                                                if death != 0 {
                                                    
                                                    self.userlolTotal.kda = String(format:"%.2f", Double(kills + assist) / Double(death))
                                                    
                                                    
                                                }else{
                                                    
                                                    self.userlolTotal.kda = String(format:"%.2f ", Double(kills + assist))
                                                    
                                                }
                                                
                                            }//kda
                                        }
                                        
                                    }//id
                                    self.userLoLinfo.append(champion)
                                } //for
                                
                                self.userLoLinfo.sort({ $0.game > $1.game })
                                
                                self.resulttabel.reloadData()
                                
                            }//nil
                            
                            else{
                            
                            self.number = 1
                            self.resulttabel.reloadData()
                            
                            }
                            
                    }//end
                    
                    
                    
                }//json nil
                
                
        }//end request
        


    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if number == 0{
        return 0
            
        }else if number <  15 {
       
            return number
            
        }
        else {
         return 15
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      
        if indexPath.row == 0{
            return 160
        }
        else  if indexPath.row == 1{
            return 320
        }
        else{
            return 80
        }

        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        
        
        if indexPath.row == 0 {
        
        var cell: Team_Member_Top?  = tableView.dequeueReusableCellWithIdentifier("top") as? Team_Member_Top
            
        if cell == nil{
            
            cell = NSBundle.mainBundle().loadNibNamed("tableCell", owner: 0, options: nil)[1] as? Team_Member_Top
            
            cell?.setCell(name, school: school, icon: self.usericon)
            
        }
    
            
        return cell!
            
        }
        else if indexPath.row == 1 {
            
               var cell: Team_Member_middle?  = tableView.dequeueReusableCellWithIdentifier("mid") as? Team_Member_middle
            
            if cell == nil{
                
                cell =  NSBundle.mainBundle().loadNibNamed("tableCell", owner: 0, options: nil)[2] as? Team_Member_middle
                
               cell?.setCell(self.lolname, winRatio: userlolTotal.win, games: "\(userlolTotal.game)", kda: userlolTotal.kda, killspergame:self.userlolTotal.killspergame, goldpergame:  self.userlolTotal.goldpergame, PentaKills: "\(self.userlolTotal.penta)", rank: self.rank)
            }
            
            return cell!
        
        }else{
        
              var cell: Team_Member_bot?  = tableView.dequeueReusableCellWithIdentifier("bot") as? Team_Member_bot
            
            if cell == nil{
                
                cell = NSBundle.mainBundle().loadNibNamed("tableCell", owner: 0, options: nil)[3] as? Team_Member_bot
                
                
            }
            
            cell?.setCell("\(self.userLoLinfo[indexPath.row - 2].game)", win: self.userLoLinfo[indexPath.row - 2].win , kda: self.userLoLinfo[indexPath.row - 2].kda, icon: "\(self.userLoLinfo[indexPath.row - 2].id)")
                
                return cell!
            }
            
    
    }
    
    
    

}
