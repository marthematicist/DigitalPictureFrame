import java.util.Calendar;

class WeatherCanvas {
  String[] DayOfWeekStringsLong = {"null","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
  String[] DayOfWeekStringsShort = {"null","Su","Mo","Tu","We","Th","Fr","Sa"};
  String[] MonthStringsShort = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
  String[] MonthStringsLong = {"January","February","March","April","May","June","July","August","September","October","November","December"};
  String[] DayStringsLong = {"null","1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th",
                             "11th","12th","13th","14th","15th","16th","17th","18th","19th","20th",
                             "21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st" };
                             
  String[] AMPMStrings = {"am" , "pm"};
  color bgColor = color( 0,128 );
  color drawColor = color( 255 );
  color drawColorShadow = color( 0 );
  int shadowAlpha = 32;
  float shadowAmount = 5;
  int textShadowDetail = 16;
  PGraphics buf;
  WeatherData weather;
  Icons iconsSmall;
  Icons iconsLarge;
  PFont OpenSansLight;
  PFont OpenSansRegular;
  Calendar nextWeatherUpdateTime;
  Calendar nextTimeUpdateTime;
  BasicDayForecast[] dayForecast;
  int numDayForecasts = 6;
  CurrentConditionsDisplay currentConditionsDisplay;
  DateDisplay dateDisplay;
  TimeDisplay timeDisplay;
  int CURRENT = -1;
  float cornerRadius;
  boolean drawBG = true;
  int secondsBetweenWeatherUpdates = 10*60;

  WeatherCanvas( int w, int h ) {
    shadowAmount = w*0.004;
    buf = createGraphics( w, h );
    OpenSansLight = createFont( "OpenSans-Light.ttf", 1,true);
    OpenSansRegular = createFont( "OpenSans-Regular.ttf", 1,true);
    weather = new WeatherData( "../weatherSettings.txt" );
    weather.FetchWeather();
    cornerRadius = 0.02*w;
    float dw = w / (numDayForecasts+1.0);
    float dh = 0.25*h;
    float cw = dw;
    float ch = dw;
    iconsSmall = new Icons( round(dh*0.5), round(dh*0.5), drawColor, drawColorShadow, shadowAmount );
    iconsLarge = new Icons( round(ch), round(ch), drawColor, drawColorShadow, shadowAmount );
    nextWeatherUpdateTime = Calendar.getInstance();
    nextWeatherUpdateTime.add( Calendar.SECOND, secondsBetweenWeatherUpdates );
    nextTimeUpdateTime = nextMinute();

    dayForecast = new BasicDayForecast[numDayForecasts];
    for ( int i = 0; i < numDayForecasts; i++ ) {
      float x0 = (i+0.5)*dw;
      float y0 = 0.75*h-0.25*dw;
      dayForecast[i] = new BasicDayForecast( x0, y0, round(0.9*dw), round(dh), i );
    }
    currentConditionsDisplay = new CurrentConditionsDisplay( 0.5*dw, 0.25*dw, round(2.25*dw), round(dw) );
    dateDisplay = new DateDisplay( 3.5*dw, 0.25*dw, round(3*dw), round(0.25*dw) );
    timeDisplay = new TimeDisplay( 3.5*dw, 0.50*dw, round(3*dw), round(0.75*dw) );
    drawCanvas();
  }

  void update() {
    Boolean drawIt = false;
    Calendar currentTime = Calendar.getInstance();
    if ( currentTime.after( nextWeatherUpdateTime ) ) {
      nextWeatherUpdateTime = Calendar.getInstance();
      nextWeatherUpdateTime.add( Calendar.SECOND, secondsBetweenWeatherUpdates );
      weather.FetchWeather();
      for ( int i = 0; i<numDayForecasts; i++ ) {
        dayForecast[i].update();
      }
      currentConditionsDisplay.update();
      drawIt = true;
    }
    if ( currentTime.after( nextTimeUpdateTime ) ) {
      nextTimeUpdateTime = nextMinute();
      dateDisplay.update();
      timeDisplay.update();
      drawIt = true;
    }
    if ( drawIt ) {
      drawCanvas();
    }
  }

  void drawCanvas() {
    float dw = buf.width / (numDayForecasts+1.0);
    buf.beginDraw();
    buf.clear();
    if( drawBG ) {
          buf.noStroke();
          buf.fill( bgColor );
          buf.rect(3.5*dw, 0.25*dw, round(3*dw) , round(dw),cornerRadius,cornerRadius,cornerRadius,cornerRadius);
        }
    for ( int i = 0; i<numDayForecasts; i++ ) {
      buf.image( dayForecast[i].can, round(dayForecast[i].x), round(dayForecast[i].y) );
    }
    buf.image( currentConditionsDisplay.can, round(currentConditionsDisplay.x), round(currentConditionsDisplay.y) );
    buf.image( dateDisplay.can, round(dateDisplay.x), round(dateDisplay.y) );
    buf.image( timeDisplay.can, round(timeDisplay.x), round(timeDisplay.y) );
    buf.endDraw();
  }

  void logout( String s ) {
    Calendar date = Calendar.getInstance();
    String newTimeString = date.get(Calendar.HOUR) + ":" + nf(date.get(Calendar.MINUTE),2) + ":" + nf(date.get(Calendar.SECOND),2) + AMPMStrings[date.get(Calendar.AM_PM)];
    println( newTimeString + ": " + s );
  }
  
  class TimeDisplay {
    float x;
    float y;
    int w;
    int h;
    PGraphics can;
    String timeString = " ";
    String ampmString = " ";
    TimeDisplay ( float xIn, float yIn, int wIn, int hIn ) {
      this.x = xIn;
      this.y = yIn;
      this.w = wIn;
      this.h = hIn;
      this.can = createGraphics(w, h);
      update();
    }
    void update() {
      Calendar date = Calendar.getInstance();
      int h = date.get(Calendar.HOUR);
      if( h == 0 ) { h = 12; }
      String newTimeString = nf(h) + ":" + nf(date.get(Calendar.MINUTE),2);
      String newAmpmString = AMPMStrings[date.get(Calendar.AM_PM)];
      if ( !timeString.equals(newTimeString ) ) {
        timeString = newTimeString;
        ampmString = newAmpmString;
        can.beginDraw();
        can.clear();
        if( false ) {
          can.noStroke();
          can.fill( bgColor );
          can.rect(0,0,w,h,0,0,cornerRadius,cornerRadius);
        }
        can.textFont( OpenSansLight );
        can.textSize( 0.9*h );
        float tw = can.textWidth( timeString );
        can.textSize( 0.45*h );
        float aw = can.textWidth( ampmString );
        can.textSize( 0.9*h );
        textWithShadow( can, timeString, 0.5*w-0.5*(tw+aw), h*0.8, drawColor, drawColorShadow, shadowAmount, textShadowDetail );
        can.textSize( 0.45*h );
        textWithShadow( can, ampmString, 0.5*w-0.5*(tw+aw)+tw, h*0.8, drawColor, drawColorShadow, shadowAmount, textShadowDetail );
        can.endDraw();
        logout( "rendered new time" );
      }
    }
  }
  
  class DateDisplay {
    float x;
    float y;
    int w;
    int h;
    PGraphics can;
    String dateString = " ";
    DateDisplay ( float xIn, float yIn, int wIn, int hIn ) {
      this.x = xIn;
      this.y = yIn;
      this.w = wIn;
      this.h = hIn;
      this.can = createGraphics(w, h);
      update();
    }
    void update() {
      Calendar date = Calendar.getInstance();
      String newDateString = DayOfWeekStringsLong[date.get(Calendar.DAY_OF_WEEK)] + ", " + MonthStringsLong[date.get(Calendar.MONTH)] + " " + DayStringsLong[date.get(Calendar.DATE)];
      if ( !dateString.equals(newDateString ) ) {
        dateString = newDateString;
        can.beginDraw();
        can.clear();
        if( false ) {
          can.noStroke();
          can.fill( bgColor );
          can.rect(0,0,w,h,cornerRadius,cornerRadius,0,0);
        }
        can.textFont( OpenSansRegular );
        can.textSize( 0.9*h );
        float tw = can.textWidth( dateString );
        textWithShadow( can, dateString, 0.5*w-0.5*tw, h*0.8, drawColor, drawColorShadow, shadowAmount, textShadowDetail );
        can.endDraw();
        logout( "rendered new date" );
      }
    }
  }
  
  class CurrentConditionsDisplay {
    float x;
    float y;
    int w;
    int h;
    PGraphics can;
    float scale = 0.8;
    WindDisplay wd;
    TempDisplay td;
    CurrentConditionsDisplay ( float xIn, float yIn, int wIn, int hIn ) {
      this.x = xIn;
      this.y = yIn;
      this.w = wIn;
      this.h = hIn;
      this.td = new TempDisplay( h, 0.5*h - scale*0.5*h, round(w-h), round(scale*0.5*h), -1 );
      this.wd = new WindDisplay( h, 0.5*h - 0, round(0.5*w), round(scale*0.5*h), -1 );
      this.can = createGraphics(w, h);
      update();
    }
    void update() {
      boolean b1 = td.update();
      boolean b2 = wd.update();
      if ( b1 || b2 ) {
        can.beginDraw();
        can.clear();
        if( drawBG ) {
          can.noStroke();
          can.fill( bgColor );
          can.rect(0,0,w,h,cornerRadius,cornerRadius,cornerRadius,cornerRadius);
        }
        can.image( iconsLarge.get(weather.current.icon), 0, 0 );
        can.image( td.can, round(td.x) , round(td.y) );
        can.image( wd.can, round(wd.x) , round(wd.y) );
        can.endDraw();
        logout( "rendered new conditions" );
      }
    }
  }


  class WindDisplay {
    int dayNum;
    float x;
    float y;
    int w;
    int h;
    PGraphics can;
    int windDir;
    int windSpeed;
    Icon compassIcon;
    Icon windIcon;
    PGraphics compassBuf;
    float compassAmt = 2;
    float compassSize;
    WindDisplay( float xIn, float yIn, int wIn, int hIn, int dayNumIn ) {
      this.x = xIn;
      this.y = yIn;
      this.w = wIn;
      this.h = hIn;
      this.compassSize = h*0.7;
      this.dayNum = dayNumIn;
      this.can = createGraphics(w, h);
      this.compassIcon = new Icon(round(compassSize*compassAmt), round(compassSize*compassAmt), drawColor, drawColorShadow, shadowAmount, "compass");
      this.windIcon = new Icon(round(h), round(h), drawColor, drawColorShadow, shadowAmount, "wind");
      this.compassBuf = createGraphics(h, h);
      //update();
    }
    boolean update() {
      int newWindDir;
      int newWindSpeed;
      if ( dayNum >= 0 && dayNum < 8 ) {
        newWindDir = round(weather.weekForecast[dayNum].windBearing);
        newWindSpeed = round(weather.weekForecast[dayNum].windSpeed);
      } else {
        newWindDir = round(weather.current.windBearing);
        newWindSpeed = round(weather.current.windSpeed);
      }
      if ( newWindDir != windDir ) {
        compassBuf.beginDraw();
        compassBuf.clear();
        compassBuf.pushMatrix();
        compassBuf.translate( 0.5*compassSize, 0.5*compassSize );
        compassBuf.rotate(newWindDir-1.5*PI);
        compassBuf.image(compassIcon.get(), round(0.5*(0-compassAmt)*compassSize), round(0.5*(0-compassAmt)*compassSize));
        compassBuf.popMatrix();
        compassBuf.stroke(255, 0, 0);
        compassBuf.strokeWeight(1);
        compassBuf.noFill();
        //compassBuf.rect(0, 0, compassSize-1, compassSize-1);
        compassBuf.endDraw();
      }
      if ( newWindDir != windDir || newWindSpeed != windSpeed ) {
        windSpeed = newWindSpeed;
        windDir = newWindDir;
        can.beginDraw();
        can.clear();
        can.textFont(OpenSansRegular);
        can.textSize(h);
        String windTxt = nf(windSpeed);
        float tw = can.textWidth( windTxt );
        textWithShadow( can, windTxt, 0.5*w-0.5*tw, h*0.85, drawColor, drawColorShadow, shadowAmount, textShadowDetail );
        //buf.text(windTxt,0.5*w-0.5*tw,h);
        can.image(windIcon.get(), round(0.5*w-0.5*tw-h), 0);
        can.image(compassBuf, round(0.5*w+0.5*tw+0.5*(h-compassSize)), round(0.5*(h-compassSize)));
        can.noFill();
        can.stroke(255, 0, 0);
        //can.rect(0, 0, w-1, h-1);
        can.endDraw();
        return true;
      }
      return false;
    }
  }
  
  class TempDisplay {
    int dayNum;
    float x;
    float y;
    int w;
    int h;
    PGraphics can;
    int temp;
    int thermValue;
    Icon[] thermIcons;
    float a = 1.5;
    TempDisplay( float xIn, float yIn, int wIn, int hIn, int dayNumIn ) {
      this.x = xIn;
      this.y = yIn;
      this.w = wIn;
      this.h = hIn;
      this.dayNum = dayNumIn;
      this.can = createGraphics(w, h);
      this.thermIcons = new Icon[5];
      for ( int i = 0; i < 5; i++ ) {
        thermIcons[i] = new Icon(round(h*a), round(h*a), drawColor, drawColorShadow, shadowAmount, "Thermometer-"+i);
      }
      //update();
    }
    void setThermValue() {
      if ( temp <= 10 ) { 
        thermValue = 0;
      }
      if ( temp > 10 && temp <= 35 ) { 
        thermValue = 1;
      }
      if ( temp > 35 && temp <= 60 ) { 
        thermValue = 2;
      }
      if ( temp > 60 && temp <= 85 ) { 
        thermValue = 3;
      }
      if ( temp > 85 ) { 
        thermValue = 4;
      }
    }
    boolean update() {
      int newTemp;
      if ( dayNum >= 0 && dayNum < 8 ) {
        newTemp = round(weather.weekForecast[dayNum].temperature);
      } else {
        newTemp = round(weather.current.temperature);
      }
      if ( newTemp != temp ) {
        temp = newTemp;
        setThermValue();
        can.beginDraw();
        can.clear();
        can.textFont(OpenSansRegular);
        can.textSize(h);
        String tempTxt = nf(temp) + "\u00B0";
        float tw = can.textWidth( tempTxt );
        textWithShadow( can, tempTxt, 0.5*w-0.5*(tw+h)+h, h*0.85, drawColor, drawColorShadow, shadowAmount, textShadowDetail );
        //buf.text(windTxt,0.5*w-0.5*tw,h);
        can.image(thermIcons[thermValue].get(), round(0.5*w-0.5*(tw+h)-0.5*(a*h-h)), round(-0.5*(a*h-h)));
        can.noFill();
        can.stroke(255, 0, 0);
        //can.rect(0, 0, w-1, h-1);
        can.endDraw();
        return true;
      }
      return false;
    }
  }

  class BasicDayForecast {
    int dayNum;
    float x;
    float y;
    int w;
    int h;
    PGraphics can;
    int dayOfWeek;
    int date;
    String icon;
    int hiTemp;
    int loTemp;
    String dayString;
    String tempString;
    //boolean drawBoxes = true;
    boolean drawBoxes = false;
    BasicDayForecast( float xIn, float yIn, int wIn, int hIn, int dayNumIn ) {
      this.x = xIn;
      this.y = yIn;
      this.w = wIn;
      this.h = hIn;
      this.dayNum = dayNumIn;
      this.icon =  " ";
      this.can = createGraphics(w, h);
      update();
    }
    boolean update() {
      boolean dayOfWeekChanged = !( dayOfWeek == weather.weekForecast[dayNum].date.get(Calendar.DAY_OF_WEEK) );
      boolean dateChanged = !( date == weather.weekForecast[dayNum].date.get(Calendar.DATE) );
      boolean hiTempChanged = !( hiTemp == round(weather.weekForecast[dayNum].temperatureHigh) );
      boolean loTempChanged = !( loTemp == round(weather.weekForecast[dayNum].temperatureLow) );
      boolean iconChanged = !( icon.equals(weather.weekForecast[dayNum].icon) );
      if ( dayOfWeekChanged || dateChanged || hiTempChanged || loTempChanged || iconChanged ) {
        this.dayOfWeek = weather.weekForecast[dayNum].date.get(Calendar.DAY_OF_WEEK);
        this.date = weather.weekForecast[dayNum].date.get(Calendar.DATE);
        this.dayString = DayOfWeekStringsShort[dayOfWeek] + " " + date;
        this.hiTemp = round(weather.weekForecast[dayNum].temperatureHigh);
        this.loTemp = round(weather.weekForecast[dayNum].temperatureLow);
        this.tempString = hiTemp + "\u00B0 " + loTemp + "\u00B0";
        this.icon = weather.weekForecast[dayNum].icon;
        render();
        return true;
      }
      return false;
    }
    void render() {
      float u = h/3.0;

      can.beginDraw();
      can.clear();
      if( drawBG ) {
        can.noStroke();
        can.fill( bgColor );
        can.rect(0,0,w,h,cornerRadius,cornerRadius,cornerRadius,cornerRadius);
      }
      can.image( iconsSmall.get(icon), round(0.5*w - 0.5*iconsSmall.w), round(0.525*h - 0.5*iconsSmall.h) );
      can.fill(0);
      float dh = u*0.6;
      can.textFont(OpenSansRegular);
      can.textSize(dh);
      float dw = can.textWidth(dayString);
      textWithShadow( can, dayString, 0.5*w-0.5*dw, 0.4*u+0.5*dh, drawColor, drawColorShadow, shadowAmount, textShadowDetail );
      float th = u*0.5;
      can.textFont(OpenSansRegular);
      can.textSize(th);
      float tw = can.textWidth(tempString);
      textWithShadow( can, tempString, 0.5*w-0.5*tw, 2.6*u+0.5*th, drawColor, drawColorShadow, shadowAmount, textShadowDetail );
      if ( drawBoxes ) {
        can.noFill();
        can.stroke(255, 0, 0);
        can.rect(0, 0, w-1, h-1);
        can.rect( 0.5*w - 0.5*iconsSmall.w, 0.525*h - 0.5*iconsSmall.h, iconsSmall.w, iconsSmall.h );
        can.rect( 0.5*w-0.5*dw, 0.4*u-0.5*dh, dw, dh );
        can.rect( 0.5*w-0.5*tw, 2.6*u-0.5*th, tw, th );
      }
      can.endDraw();
      logout( "rendered new day forecast" );
    }
  }
  
  
  Boolean logoutWeatherData = true;
  Boolean liveData = true;
  
  class WeatherData {
    String APIKey;
    // Settings Data
    JSONObject settingsJSON;
    float latitude;
    float longitude;
    String API_key;
    String weatherURL;
    // Weather Data
    JSONObject weatherJSON;
    Calendar weatherDate;
    HourConditions current;
    DayConditions[] weekForecast;
    WeatherData( String settingsFile ) {
      // load settings
      settingsJSON = loadJSONObject( settingsFile );
      latitude = settingsJSON.getFloat( "latitude" );
      longitude = settingsJSON.getFloat( "longitude" ) ;
      API_key = settingsJSON.getString( "API_key" ) ;
      weatherURL = "https://api.darksky.net/forecast/" + API_key + "/" + nf(latitude) + "," + nf(longitude) + "?exclude=minutely,hourly,alerts,flags" ;
      if( logoutWeatherData ) {
        println( "=================================================================" );
        println( "SETTINGS LOADED..." );
        println( "latitude = " + nf(latitude) + "    longitude = " + longitude + "     API_key = " + API_key );
        println( "weatherURL = " + weatherURL );
      }
    }
    void logout() {
      println( "=================================================================" );
      println( "SETTINGS LOADED..." );
      println( "latitude = " + nf(latitude) + "    longitude = " + longitude + "     API_key = " + API_key );
      println( "weatherURL = " + weatherURL );
      println( "Last weather update: " + weatherDate.getTime() );
      println( "=================================================================" );
      println( "CURRENT CONDITIONS..." );
      current.print();
      println( weatherJSON.getJSONObject("daily").getJSONArray("data").getJSONObject(0).getInt("time") );
      println( "=================================================================" );
      println( "WEEK FORECAST..." );
      for( int i = 0 ; i < 7 ; i++ ) {
        weekForecast[i].print();
      }
    }
    void FetchWeather() {
      if( liveData ) {
        try {
          weatherJSON = loadJSONObject( weatherURL );
          saveJSONObject( weatherJSON ,  "mostRecentWeather.json" );
        } catch( Exception e ) {
          weatherJSON = loadJSONObject( "mostRecentWeather.json" );
        }
      } else {
        weatherJSON = loadJSONObject(  "mostRecentWeather.json" );
      }
      weatherDate = Calendar.getInstance();
      weatherDate.setTimeInMillis((long)weatherJSON.getJSONObject("currently").getInt("time")*1000);
      // get current conditions
      current = new HourConditions( weatherJSON.getJSONObject("currently") );
      // get week forecast
      weekForecast = new DayConditions[7];
      for( int i = 0 ; i < 7 ; i++ ) {
        weekForecast[i] = new DayConditions( weatherJSON.getJSONObject("daily").getJSONArray("data").getJSONObject(i) );
      }
      if( logoutWeatherData ) {
        logout();
      }
    }
    class HourConditions {
      int time;
      Calendar date;
      String summary;
      float precipProbability;
      float visibility;
      float windGust;
      String icon;
      float cloudCover;
      float windBearing;
      float apparentTemperature;
      float pressure;
      float dewPoint;
      float ozone;
      float temperature;
      float humidity;
      float uvIndex;
      float windSpeed;
      HourConditions() {
      }
      HourConditions( JSONObject w ) {
        this.time = w.getInt("time");
        this.date = Calendar.getInstance();
        this.date.setTimeInMillis((long)this.time*1000);
        this.summary = w.getString("summary");
        this.precipProbability = w.getFloat("precipProbability");
        this.visibility = w.getFloat("visibility");
        this.windGust = w.getFloat("windGust");
        this.icon = w.getString("icon");
        this.cloudCover = w.getFloat("cloudCover");
        this.windBearing = w.getFloat("windBearing");
        this.apparentTemperature = w.getFloat("apparentTemperature");
        this.pressure = w.getFloat("pressure");
        this.dewPoint = w.getFloat("dewPoint");
        this.ozone = w.getFloat("ozone");
        this.temperature = w.getFloat("temperature");
        this.humidity = w.getFloat("humidity");
        this.uvIndex = w.getFloat("uvIndex");
        this.windSpeed = w.getFloat("windSpeed");
      }
      void print() {
        println( "Conditions for " + date.getTime() + "  ---------  " +  "summary: " , summary );
        println( "icon: " + icon + "\t temperature: " + temperature + "\t apparentTemperature: " , apparentTemperature + "\t humidity: " + humidity +  "\t precipProbability: " + precipProbability );
        println( "windSpeed: " + windSpeed , "\t windBearing: " + windBearing + "\t windGust: " + windGust );
        println( "cloudCover: " + cloudCover , "\t visibility: " + visibility + "\t pressure: " + pressure + "\t dewPoint: " + dewPoint + "\t ozone: " + ozone + "\t uvIndex: " + uvIndex );
      }
      HourConditions copy() {
        HourConditions that = new HourConditions();
        that.time = this.time;
        that.date = (Calendar) this.date.clone();
        that.summary = this.summary;
        that.precipProbability = this.precipProbability;
        that.visibility = this.visibility;
        that.windGust = this.windGust;
        that.icon = this.icon;
        that.cloudCover = this.cloudCover;
        that.windBearing = this.windBearing;
        that.apparentTemperature = this.apparentTemperature;
        that.pressure = this.pressure;
        that.dewPoint = this.dewPoint;
        that.ozone = this.ozone;
        that.temperature = this.temperature;
        that.humidity = this.humidity;
        that.uvIndex = this.uvIndex;
        that.windSpeed = this.windSpeed;
        return that;
      }
    } 
    
    class DayConditions {
      int time;
      Calendar date;
      String summary;
      float precipProbability;
      float visibility;
      float windGust;
      String icon;
      float cloudCover;
      float windBearing;
      float pressure;
      float dewPoint;
      float ozone;
      float temperature;
      float humidity;
      float uvIndex;
      float windSpeed;
      float temperatureHigh;
      float temperatureLow;
      float precipIntensity;
      float precipAccumulation;
      float moonPhase;
      Calendar temperatureLowTime;
      Calendar temperatureHighTime;
      Calendar sunriseTime;
      Calendar sunsetTime;
      DayConditions() {
      }
      DayConditions( JSONObject w ) {
        this.time = w.getInt("time");
        this.date = Calendar.getInstance();
        this.date.setTimeInMillis((long)this.time*1000);
        this.summary = w.getString("summary");
        this.precipProbability = w.getFloat("precipProbability");
        this.windGust = w.getFloat("windGust");
        this.icon = w.getString("icon");
        if( icon.equals("partly-cloudy-night" ) ) {
          icon = "clear-day";
        }
        this.cloudCover = w.getFloat("cloudCover");
        this.windBearing = w.getFloat("windBearing");
        this.pressure = w.getFloat("pressure");
        this.dewPoint = w.getFloat("dewPoint");
        this.ozone = w.getFloat("ozone");
        this.humidity = w.getFloat("humidity");
        this.uvIndex = w.getFloat("uvIndex");
        this.windSpeed = w.getFloat("windSpeed");
        
        temperatureHigh = w.getFloat("temperatureHigh");
        temperatureLow = w.getFloat("temperatureLow");
        if( w.isNull("precipAccumulation") ) {
          precipAccumulation = 0;
        } else { 
          precipAccumulation = w.getFloat("precipAccumulation");
        }
        if( w.isNull("precipIntensity") ) {
          precipIntensity = 0;
        } else { 
          precipIntensity = w.getFloat("precipIntensity");
        }
        moonPhase = w.getFloat("moonPhase");
        temperatureLowTime = Calendar.getInstance();
        temperatureHighTime = Calendar.getInstance();
        sunriseTime = Calendar.getInstance();
        sunsetTime = Calendar.getInstance();
        temperatureLowTime.setTimeInMillis((long)w.getInt("temperatureLowTime")*1000);
        temperatureHighTime.setTimeInMillis((long)w.getInt("temperatureHighTime")*1000);
        sunriseTime.setTimeInMillis((long)w.getInt("sunriseTime")*1000);
        sunsetTime.setTimeInMillis((long)w.getInt("sunsetTime")*1000);
      }
      
      void print() {
        println(" ---------------------------------------------------- " );
        println( DayOfWeekStringsLong[date.get(Calendar.DAY_OF_WEEK)] + " " + MonthStringsLong[date.get(Calendar.MONTH)] + " " + DayStringsLong[date.get(Calendar.DATE)] );
        println( DayOfWeekStringsShort[date.get(Calendar.DAY_OF_WEEK)] + " " + MonthStringsShort[date.get(Calendar.MONTH)] + " " + date.get(Calendar.DATE) );
        println( "summary: " , summary );
        println( "icon: " + icon + "\t temperatureLow: " + temperatureLow + "\t temperatureHigh: " , temperatureHigh );
        println( "temperatureLowTime: " + timeStringAMPM(temperatureLowTime) + "    temperatureHighTime: " + timeStringAMPM(temperatureHighTime) );
        println( "humidity: " + humidity + "\t precipProbability: " + precipProbability + "\t precipIntensity: " + precipIntensity + "\t precipAccumulation: " + precipAccumulation );
        println( "windSpeed: " + windSpeed , "\t windBearing: " + windBearing + "\t windGust: " + windGust );
        println( "cloudCover: " + cloudCover , "\t visibility: " + visibility + "\t pressure: " + pressure + "\t dewPoint: " + dewPoint + "\t ozone: " + ozone + "\t uvIndex: " + uvIndex );
        println( "sunriseTime: " + timeStringAMPM(sunriseTime) + "    sunsetTime: " + timeStringAMPM(sunsetTime) + "    moonPhase: " + moonPhase );
      }
      
      DayConditions copy() {
        DayConditions that = new DayConditions();
        that.time = this.time;
        that.date = (Calendar) this.date.clone();
        that.summary = this.summary;
        that.precipProbability = this.precipProbability;
        that.visibility = this.visibility;
        that.windGust = this.windGust;
        that.icon = this.icon;
        that.cloudCover = this.cloudCover;
        that.windBearing = this.windBearing;
        that.pressure = this.pressure;
        that.dewPoint = this.dewPoint;
        that.ozone = this.ozone;
        that.temperature = this.temperature;
        that.humidity = this.humidity;
        that.uvIndex = this.uvIndex;
        that.windSpeed = this.windSpeed;
        that.temperatureHigh = this.temperatureHigh;
        that.temperatureLow = this.temperatureLow;
        that.precipAccumulation = this.precipAccumulation;
        that.moonPhase = this.moonPhase;
        that.temperatureLowTime = (Calendar) this.temperatureLowTime.clone();
        that.temperatureHighTime = (Calendar) this.temperatureHighTime.clone();
        that.sunriseTime = (Calendar) this.sunriseTime.clone();
        that.sunsetTime = (Calendar) this.sunsetTime.clone();
        that.precipIntensity  = this.precipIntensity;
        return that;
      }
    } 
  }
  
  class Icons {
    int numIcons = 15;
    int w;
    int h;
    PGraphics[] img;
    String[] iconNames = { "clear-day", "clear-night", "rain", "snow", "sleet", "wind", "fog", 
                           "cloudy", "partly-cloudy-day", "partly-cloudy-night" , "hail", "thunderstorm", "tornado" , "umbrella" };
    Icons( int win , int hin , color drColor , color shColor , float shadowAmt ) {
      this.w = win;
      this.h = hin;
      this.img = new PGraphics[numIcons];
      for( int i = 0 ; i < numIcons-1 ; i++ ) {
        this.img[i] = createGraphics( w , h );
        String path = "icons/" + iconNames[i] + ".svg";
        PGraphics shadow = loadIconColor( path , w , h , shColor  );
        PGraphics fore = loadIconColor( path , w , h , drColor  );
        this.img[i].beginDraw();
        this.img[i].tint(255,shadowAlpha);
        for( int j = 0 ; j < 16 ; j++ ) {
          float ang = float(j)/float(32)*TWO_PI;
          this.img[i].image( shadow , shadowAmt*cos(ang) , shadowAmt*sin(ang) );
        }
        this.img[i].tint(255,255);
        this.img[i].image( fore , 0 , 0 );
        this.img[i].endDraw();
      }
      this.img[numIcons-1] = createGraphics( w , h );
    }
    PGraphics get( String s ) {
      PGraphics out = img[numIcons-1];
      for( int i = 0 ; i < numIcons-1 ; i++ ) {
        if( s.equals( iconNames[i] ) ) {
          out = img[i];
        }
      }
      return out;
    }
  }
  
  class Icon {
    int numIcons = 15;
    int w;
    int h;
    PGraphics img;               
    Icon( int win , int hin , color drColor , color shColor , float shadowAmt , String iconName ) {
      this.w = win;
      this.h = hin;
      this.img = createGraphics( w , h );
      String path = "icons/" + iconName + ".svg";
      PGraphics shadow = loadIconColor( path , w , h , shColor  );
      PGraphics fore = loadIconColor( path , w , h , drColor );
      this.img.beginDraw();
      this.img.tint(255,shadowAlpha);
      for( int j = 0 ; j < 16 ; j++ ) {
        float ang = float(j)/float(16)*TWO_PI;
        this.img.image( shadow , shadowAmt*cos(ang) , shadowAmt*sin(ang) );
      }
      this.img.tint(255,255);
      this.img.image( fore , 0 , 0 );
      this.img.endDraw();
    }
    PGraphics get() {
      return img;
    }
  }
  
  
  Calendar nextMinute() {
    Calendar out = Calendar.getInstance();
    out.add( Calendar.MINUTE , 1 );
    out.set( Calendar.SECOND , 0 );
    return out;
  }
  
  void textWithShadow( PGraphics buf , String txt , float x , float y , color txtColor , color shColor , float shAmt , int detail ) {
    buf.fill( red(shColor) , green(shColor) , blue(shColor) , shadowAlpha );
    for( int i = 0 ; i < detail ; i++ ) {
      float ang = float(i)/float(detail)*TWO_PI;
      buf.text(txt,x+shAmt*cos(ang),y+shAmt*sin(ang));
    }
    buf.fill( red(txtColor) , green(txtColor) , blue(txtColor) );
    buf.text(txt,x,y);
  }
  PGraphics loadIconColor( String path , int w , int h , color c  ) {
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    PGraphics out = createGraphics(w,h);
    PShape s = loadShape(path);
    float a = 0.7;
    float a0 = 1-a;
    out.beginDraw();
    float w0 = w/a;
    float h0 = h/a;
    out.shape(s,0-0.5*a0*w0,0-0.5*a0*h0,w0,h0);
    out.loadPixels();
    for( int p = 0 ; p < out.height*out.width ; p++ ) {
      color c1 = out.pixels[p];
      float al = alpha(c1);
      c = color( r , g , b , al );
      out.pixels[p] = c;
    }
    out.updatePixels();
    out.endDraw();
    return out;
  }
  String timeStringAMPM( Calendar d ) {
    return ( d.get(Calendar.HOUR_OF_DAY) + ":"  + nf(d.get(Calendar.MINUTE)) + " " + d.get(Calendar.AM_PM) );
  }
}