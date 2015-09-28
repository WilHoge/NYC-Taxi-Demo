# server.R  

library(sp)  
library(rjson)  
library(RJSONIO)  

#Connect to the database
idaInit(idaConnect("BLUDB","",""))

q <- ida.data.frame('taxisample01')

shinyServer(function(input, output) {  
  
  # default rectangle for selection
  NE1=40.765693
  NE2=-73.9677
  SW1=40.759988
  SW2=-73.976693
 
  output$json <- reactive({ 
    
    # rectangle set, so get data from it
    if(length(input$NE1)>0){  
      NE1=input$NE1
      NE2=input$NE2
      SW1=input$SW1
      SW2=input$SW2
    }  
    
    if(length(input$Earth)>0){  
        
      if(input$Earth==1 | input$Earth==2){  
        
        # query data // filter pickup 
        bdf <- q[(q$"pickup latitude">SW1)&(q$"pickup latitude"<NE1)&
                   (q$"pickup longitude">SW2)&(NE2>q$"pickup longitude")
                 ,]
      }
      else {
        # query data // filter dropoff
        bdf <- q[(q$"dropoff latitude">SW1)&(q$"dropoff latitude"<NE1)&
                   (q$"dropoff longitude">SW2)&(NE2>q$"dropoff longitude")
                 ,]        
      }

      nr=nrow(bdf)
      message("rows in result-set: ", nr)
        
      # copy data to local environmen
      df <- as.data.frame(bdf)
        
      # format values
        df$date <- strptime(df$"pickup datetime",'%Y-%m-%d %H:%M:%S')
        df$hour <- format(df$date,'%H')
        df$min <- format(df$date,'%M')
        df$dayyear <- as.numeric(format(df$date,'%j'))
        df$dayweeknum <- df$dayyear%%7
        df$dayweek <- format(df$date,'%a')
        df$day <- as.numeric(format(df$date,'%d'))
        df$month <- as.numeric(format(df$date,'%m'))
        df$dayweek <- as.factor(df$dayweek)
        
        df$timeofday <- (as.numeric(df$hour)*60+as.numeric(df$min))/60.0
        df$trip_distance <- as.numeric(df$"trip distance")
        df$trip_time <- as.numeric(df$"trip time in secs")/60.0
        df$speed <- as.numeric(df$"trip distance")/as.numeric(df$"trip time in secs")
        df$EST <- format(df$date,'%Y-%m-%d')        
        
        df$lon  <- df$"pickup longitude"
        df$lat  <- df$"pickup latitude"
        df$lon2 <- df$"dropoff longitude"
        df$lat2 <- df$"dropoff latitude"
        df$passenger <- df$"passenger count"
        
      # prepare list of values for map
      if(nrow(df)>0){  
          lis <- list()
          for(i in 1:nrow(df)){  
            
            if(df$trip_time[i]<=25){icon="http://maps.gstatic.com/mapfiles/ridefinder-images/mm_20_green.png"}  
            else if(df$trip_time[i]>25&df$trip_time[i]<=40){icon="http://maps.gstatic.com/mapfiles/ridefinder-images/mm_20_yellow.png"}  
            else if(df$trip_time[i]>40&df$trip_time[i]<=60){icon="http://maps.gstatic.com/mapfiles/ridefinder-images/mm_20_orange.png"}  
            else {icon="http://maps.gstatic.com/mapfiles/ridefinder-images/mm_20_red.png"}  

            lis[[i]]  <- list(i,df$lon[i],df$lat[i],icon,df$trip_distance[i],df$trip_time[i],df$passenger[i],df$day[i],df$timeofday[i],df$lon2[i],df$lat2[i])
            
          } # of for loop   
          
        if(input$Earth==1){  
          #This code creates the variable test directly in javascript for export the grid in the Google Maps API  
          #I have taken this part from:http://stackoverflow.com/questions/26719334/passing-json-data-to-a-javascript-object-with-shiny  
          paste('<script>test=',         
                RJSONIO::toJSON(lis),        
                ';setAllMap();Cities_Markers();',        
                '</script>')  
        }
        else if (input$Earth==2) {
          paste('<script>test=',         
                RJSONIO::toJSON(lis),        
                ';setAllMap();Draw_Lines();',        
                '</script>')            
        }
        else {
          paste('<script>test=',         
                RJSONIO::toJSON(lis),        
                ';setAllMap();Draw_Lines();',        
                '</script>')            
        } # of else
    } # if (nrow)  
  
  } # if(length(input$Earth)>0)

})  # output$json <- reactive

})  # shinyServer(function(input, output)