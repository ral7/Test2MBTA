# Test2MBTA

It is an iOS app that can be used to track the T. It is basically used to find out when a T is going to arrive at a particular stop. This can be very helpful and useful to the people of Massachusetts as they can actually save their time by going to the stop according to the predicted times. They do not have to waste their time standing at the stops and expecting a T to arrive.

The app makes use of dynamic API calls to web services to provide user with the data. The API services that is being used are:
•	Nextbus API
•	MBTA Realtime API

The app has two ways to give you the predicted time of a T:
•	By Stop : Uses Nextbus API
•	By Location: Uses MBTA Realtime API




Nexbus API:
Is a publicly accessible web service that provides live feed about the predictions time of the bus. You do not need any authentication key for using it.

MBTA Realtime API:
Is a API provided by MBTA themselves. You need to create a developer account and then have the MBTA people approve your app so that you can use their API key.
They provide an api key for you to access their service. The data is returned in the form of JSON or XML format as per your requirements.

Requirements:
iOS 7.0 and above.
