# Mars Weather

"Mars Weather" is an app developed to practice CLLocation and capturing the user's location before making an API call, as well as practicing the JSON, MVC structure and Unit tests.

"Mars Weather" downloads the user's current weather data and compares it to the current weather on Mars.

## Install

To check out the weather in your neighborhood and on Mars:

1. Clone or download my repository:
` $ https://github.com/ginnypx1/MarsWeather.git `

2. Enter the "Mars Weather" directory:
` $ cd /MarsWeather-master/ `

3. Open "Mars Weather" in XCode:
` $ open MarsWeather.xcodeproj `

To run the project in XCode, you will need to add a Private.swift file with your API key information:

```
let MARS_API_KEY = <YOUR_API_KEY>
let DARK_SKY_API_KEY = <YOUR_API_KEY>
```

## Instructions

Simply launch the app, and the current weather in your location and the current weather on Mars will load.

## Technical Information

The weather on Earth is [Powered by DarkSky](https://darksky.net/poweredby/)
The weather on Mars is provided by the [MAAS API](http://marsweather.ingenology.com/)