# Weather3Days4ecast.iOS

## Test project of request curent and forecast Weather

**The Tasks:**

Code an iOS Swift app that fetches weather forecast data from a remote API, for example: https://openweathermap.org/ (beware that you need to register and account activation may take up to 2 hours) and displays weather forecast for a set of cities.
 
The app will be composed of 2 main screens:
A screen with a static list of city names (the list can be hardcoded)
A screen with the weather forecast detail for a specific city
 
Tapping on a city name in the first screen will lead the user on the weather detail screen for the city that was tapped
The weather forecast is fetched for the current day and with forecast data for the next 3 days
 
You can choose any coding library/dependency you find suitable to achieve the task
If a decision you have to make is not specified in this requirements, use your best judgment
 
Note:
despite we like it, due to our backward compatibility policy we don’t use SwiftUI and we will not be able to introduce it in the new few months. If you know other ways to solve this coding challenge they are preferred. If you decide to go for SwiftUI we will assume that is the only way you know.
 
Parameters that will be used to judge your application:
- easiness to run it, including necessary documentation, best practices regarding dependencies management and code versioning
- cleanness of the code and following best practices in terms of software architecture models
- quality of the UI

**Time limit:** 3 days

**Short describe:**

Used frameworks and CocoaPods:

1. Weathersama pod - access to OpenWeathermap with simple data modeling and parsiing of JSON result from REST API request

1.1. Under Weathersama used Alamorfire pod for parsing of JSON response

2. SwiftVideoBackground - create live background based on short video files

3. LatLongToTimezone - determitation of TimeZone based on coordinates


**ToDo**

1. Add forecasr request
2. Umprove design of interface
3. Add search and edit function for Cities listing
4. Add geolocation function

**License**

Not licensed, absilutly free for use and fun
