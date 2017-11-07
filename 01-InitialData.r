#Date: 07/11/2017#
#Author: Abhishek Dasgupta#

require(RGoogleAnalytics)
require(httpuv)
require(data.table)
require(stringr)
require(RCurl)
require(rjson)
require(xlsx)
require(date)

#Table IDs
TableID.RUP="ga:xxxxxxxx"
TableID.Web="ga:xxxxxxxx"
TableID.Wap="ga:xxxxxxxx"
TableID.App="ga:xxxxxxxx"

#Date Ranges
StartDate="yyyy-mm-dd"    #TODO: Convert to dynamic input fields#
EndDate="yyyy-mm-dd"      #TODO: Convert to dynamic input fields#

#Validate Token File# load("./<tokenfile>") ValidateToken(token)

#Session and User Data#
TrafficQuery.List<-Init(start.date=StartDate,end.date=EndDate,
                        dimensions="ga:date,ga:sourcePropertyDisplayName,ga:deviceCategory,ga:sourceMedium,ga:campaign",
                        metrics="ga:sessions,ga:users,ga:newUsers,ga:pageViews,ga:screenViews",
                        max.results=99999,sort="-ga:date",table.id=TableID.RUP)
TrafficQuery.Query<-QueryBuilder(TrafficQuery.List)
TrafficQuery.Data<-GetReportData(TrafficQuery.Query,token,split_daywise=T,paginate_query=T)
TrafficQuery.Data$date<-paste(substr(TrafficQuery.Data$date,7,8),"/",substr(TrafficQuery.Data$date,5,6),"/",substr(TrafficQuery.Data$date,1,4),sep="")

#Registration Data#
RegQuery.List<-Init(start.date=StartDate, end.date=EndDate,
                    dimensions="ga:date,ga:sourcePropertyDisplayName,ga:deviceCategory,ga:sourceMedium,ga:campaign",
                    metrics="ga:totalEvents,ga:uniqueEvents",
                    filters="ga:eventCategory=~reg;ga:eventCategory!~reg_modal;ga:eventAction=~signup",
                    max.results=99999,sort="-ga:date",table.id=TableID.RUP)
RegQuery.Query<-QueryBuilder(RegQuery.List)
RegQuery.Data<-GetReportData(RegQuery.Query,token,split_daywise=T,paginate_query=T)
RegQuery.Data$date<-paste(substr(RegQuery.Data$date,7,8),"/",substr(RegQuery.Data$date,5,6),"/",substr(RegQuery.Data$date,1,4),sep="")

#Order Data#
#Web
WebOrderQuery.List<-Init(start.date=StartDate,end.date=EndDate,
                         dimensions="ga:date,ga:deviceCategory,ga:transactionID,ga:sourceMedium,ga:campaign,ga:adGroup,ga:keyword",
                         metrics="ga:itemRevenue,ga:transactionRevenue",
                         max.results=99999,sort="-ga:date",table.id=TableID.Web)
WebOrderQuery.Query<-QueryBuilder(WebOrderQuery.List)
WebOrderQuery.Data<-GetReportData(WebOrderQuery.Query,token,split_daywise=T,paginate_query=T)
WebOrderQuery.Data$orderPlatform="Web"
#Wap
WapOrderQuery.List<-Init(start.date=StartDate,end.date=EndDate,
                         dimensions="ga:date,ga:deviceCategory,ga:transactionID,ga:sourceMedium,ga:campaign,ga:adGroup,ga:keyword",
                         metrics="ga:itemRevenue,ga:transactionRevenue",
                         max.results=99999,sort="-ga:date",table.id=TableID.Wap)
WapOrderQuery.Query<-QueryBuilder(WapOrderQuery.List)
WapOrderQuery.Data<-GetReportData(WapOrderQuery.Query,token,split_daywise=T,paginate_query=T)
WapOrderQuery.Data$orderPlatform="Wap"
#App
AppOrderQuery.List<-Init(start.date=StartDate,end.date=EndDate,
                         dimensions="ga:date,ga:deviceCategory,ga:transactionID,ga:sourceMedium,ga:campaign,ga:adGroup,ga:keyword",
                         metrics="ga:itemRevenue,ga:transactionRevenue",
                         max.results=99999,sort="-ga:date",table.id=TableID.App)
AppOrderQuery.Query<-QueryBuilder(AppOrderQuery.List)
AppOrderQuery.Data<-GetReportData(AppOrderQuery.Query,token,split_daywise=T,paginate_query=T)
AppOrderQuery.Data$orderPlatform="App"
#Combined Order Data
GAOrderData<-rbind(WebOrderQuery.Data,WapOrderQuery.Data,AppOrderQuery.Data)
GAOrderData$date<-paste(substr(GAOrderData$date,7,8),"/",substr(GAOrderData$date,5,6),"/",substr(GAOrderData$date,1,4),sep="")

#Cleanup
rm(WebOrderQuery.List,WebOrderQuery.Query,WapOrderQuery.List,WapOrderQuery.Query,AppOrderQuery.List,AppOrderQuery.Query,WebOrderQuery.Data,WapOrderQuery.Data,AppOrderQuery.Data)
rm(TrafficQuery.List,TrafficQuery.Query)
rm(RegQuery.List,RegQuery.Query)
rm(StartDate,EndDate,TableID.RUP,TableID.Web,TableID.Wap,TableID.App,token)

#End
