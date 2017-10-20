
class Clock {

  int[] clockOrder = { 0 , 6 , 10 , 9 , 4 , 1 , 2 , 5 , 8 , 7 , 3 };
  int numClocks = clockOrder.length;
  int clockTicker = 0;
  int clockID = clockOrder[clockTicker];
  
  String API_URL_forecast ="http://api.wunderground.com/api/" + APIkey + "/forecast/q/" + zip + ".xml";
  String API_URL_astronomy ="http://api.wunderground.com/api/" + APIkey + "/astronomy/q/" + zip + ".xml";
  
  PFont font1;
  PFont font2;
  PFont font3;
  PFont font4;
  String[] monthText = { "January" , "February" , "March" , "April" , "May" , "June" ,
                       "July" , "August" , "September" , "October" , "November" , "December" };
  
  // WEATHER VARIABLES
  XML w;
  String day0_dayName;
  String day0_dayNum;
  String day0_high;
  String day0_low;
  String day0_icon_url;
  String day0_icon_url_night;
  String day0_windavg;
  String day0_winddir;
  String day0_dateText;
  String day0_tempText;
  String day0_windText;
  String day0_windTextMin;
  PImage icon0;
  PImage icon0Night;
  String day1_dayName;
  String day1_dayNum;
  String day1_high;
  String day1_low;
  String day1_icon_url;
  String day1_windavg;
  String day1_winddir;
  String day1_dateText;
  String day1_tempText;
  String day1_windText;
  String day1_windTextMin;
  PImage icon1;
  String day2_dayName;
  String day2_dayNum;
  String day2_high;
  String day2_low;
  String day2_icon_url;
  String day2_windavg;
  String day2_winddir;
  String day2_dateText;
  String day2_tempText;
  String day2_windText;
  String day2_windTextMin;
  PImage icon2;
  String day3_dayName;
  String day3_dayNum;
  String day3_high;
  String day3_low;
  String day3_icon_url;
  String day3_windavg;
  String day3_winddir;
  String day3_dateText;
  String day3_tempText;
  String day3_windText;
  String day3_windTextMin;
  PImage icon3;
  
  // Astronomy variables
  XML astro;
  int sunriseHour;
  int sunsetHour;
  
  
  
  
  Clock() {
    font1 = createFont("OpenSans-Regular.ttf",100);
    font2 = createFont("TruenoRg.otf",100);
    font3 = createFont("TruenoRg.otf",100);
    font4 = createFont("TruenoRg.otf",100);
    updateWeather();
    updateAstronomy();
  }
  
  void nextClock() {
    clockTicker++;
    clockTicker %= numClocks;
    clockID = clockOrder[clockTicker];
    println( "Current clockID = " + clockID );
  }
  void prevClock() {
    clockTicker--;
    if( clockTicker < 0 ) { clockTicker = numClocks - 1; }
    clockID = clockOrder[clockTicker];
    println( "Current clockID = " + clockID );
  }
  
  void drawClock() {
    int sec = second();
    int min = minute();
    int hou = hour();
    float secondAngle = sec/60.0*TWO_PI;
    float minuteAngle = (min+sec/60.0)/60.0*TWO_PI;
    float hourAngle = (hou%12+min/60.0+sec/3600.0)/12.0*TWO_PI ;
    
    if( second() != prevSecond ) {
      prevSecond = second();
      secondChanged = true;
    }
    if( minute() != prevMin ) {
      prevMin = minute();
      minuteChanged = true;
    }
    if( hour() != prevHour ) {
      prevHour = hour();
      hourChanged = true;
      clock.updateWeather();
    }
    if( day() != prevDay ) {
      prevDay = day();
      dayChanged = true;
      clock.updateAstronomy();
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CLOCK TYPE 10 ///////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if( clockID == 10 ) {
      if( secondChanged || resetClock ) {
        
        secondChanged = false;
        resetClock = false;
        
        
        pg.beginDraw();
        pg.textAlign( LEFT , TOP );
        // values
        color bgColor = color( 0 , 0 , 0 , 160 );
        color textColor = color( 255 , 255 , 255 , 196 );
        String dateText = dayOfTheWeek(month(),day(),year()) + ", " + monthText[month()-1] + " " + day(); 
        
        pg.textFont(font1);
        pg.clear();
        pg.noStroke();

        float weatherWidth = 100;
        float weatherHeight = 0.24*height;
        float weatherGap = (height-4*weatherHeight)/5.0;
        float weatherX = width - 0.5*weatherWidth - weatherGap;
        float weatherCorner = 4;
        float day0_y = weatherGap*1+0.5*weatherHeight;
        float day1_y = weatherGap*2+1.5*weatherHeight;
        float day2_y = weatherGap*3+2.5*weatherHeight;
        float day3_y = weatherGap*4+3.5*weatherHeight;
        
        pg.fill( bgColor );
        pg.rect( weatherX - 0.5*weatherWidth , day0_y - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
        pg.rect( weatherX - 0.5*weatherWidth , day1_y - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
        pg.rect( weatherX - 0.5*weatherWidth , day2_y - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
        pg.rect( weatherX - 0.5*weatherWidth , day3_y - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
                 
        float dayTextSize = 20;
        float dayTextOffset = -45;
        float iconOffset = -30;
        float iconSize = icon0.width*0.7;
        float tempTextSize = 20;
        float tempTextOffset = 15;
        float windTextSize = 14;
        float windTextOffset = 40;
        
        
        pg.fill( textColor );
        pg.textAlign( CENTER , CENTER );
        pg.textSize( dayTextSize );
        pg.text( day0_dateText , weatherX , day0_y + dayTextOffset );
        pg.text( day1_dateText , weatherX , day1_y + dayTextOffset );
        pg.text( day2_dateText , weatherX , day2_y + dayTextOffset );
        pg.text( day3_dateText , weatherX , day3_y + dayTextOffset );
        pg.textSize( tempTextSize );
        pg.text( day0_tempText , weatherX , day0_y + tempTextOffset );
        pg.text( day1_tempText , weatherX , day1_y + tempTextOffset );
        pg.text( day2_tempText , weatherX , day2_y + tempTextOffset );
        pg.text( day3_tempText , weatherX , day3_y + tempTextOffset );
        pg.textSize( windTextSize );
        pg.text( day0_windTextMin , weatherX , day0_y + windTextOffset );
        pg.text( day1_windTextMin , weatherX , day1_y + windTextOffset );
        pg.text( day2_windTextMin , weatherX , day2_y + windTextOffset );
        pg.text( day3_windTextMin , weatherX , day3_y + windTextOffset );
        if( hour() >= sunsetHour - 1 ) {
          pg.image( icon0Night , weatherX - 0.5*iconSize , day0_y + iconOffset , iconSize , iconSize);
        } else {
          pg.image( icon0 , weatherX - 0.5*iconSize , day0_y + iconOffset , iconSize , iconSize );
        }
        pg.image( icon1 , weatherX - 0.5*iconSize , day1_y + iconOffset , iconSize , iconSize );
        pg.image( icon2 , weatherX - 0.5*iconSize , day2_y + iconOffset , iconSize , iconSize );
        pg.image( icon3 , weatherX - 0.5*iconSize , day3_y + iconOffset , iconSize , iconSize );
        
        
        
        float hourWidth = 12;
        float hourLengthFront = 140;
        float hourLengthBack = 30;
        float minuteWidth = 10;
        float minuteLengthFront = 170;
        float minuteLengthBack = 35;
        float shadowWidth = 4;
        float numShadows = 4;
        float shadowGrad = 4;
        
        color handColor = color( 255 , 255 , 255 , 255 );
        color shadowColor = color( 0 , 0 , 0 , 64 );
        color ridgeColor = color( 200 );
        float ridgeWidth = 0.2;
        
        pg.pushMatrix();
        
        pg.translate( halfWidth , halfHeight );

        pg.pushMatrix();
        pg.rotate(hourAngle);
        pg.stroke( shadowColor );
        for( float i = 1 ; i < numShadows ; i++ ) {
          pg.strokeWeight( hourWidth+shadowWidth+shadowGrad*i );
          pg.line( 0 , -hourLengthFront - 0.25*shadowWidth , 0 , hourLengthBack + 0.25*shadowWidth );
        }
        pg.stroke( handColor );
        pg.strokeWeight( hourWidth );
        pg.line( 0 , -hourLengthFront , 0 , hourLengthBack );
        pg.stroke(ridgeColor);
        pg.strokeWeight( hourWidth*ridgeWidth );
        pg.line( 0 , -hourLengthFront , 0 , hourLengthBack );
        pg.popMatrix();
        
        pg.pushMatrix();
        pg.rotate(minuteAngle);pg.stroke( shadowColor );
        for( float i = 1 ; i < numShadows ; i++ ) {
          pg.strokeWeight( minuteWidth+shadowWidth+shadowGrad*i );
          pg.line( 0 , -minuteLengthFront - 0.25*shadowWidth , 0 , minuteLengthBack + 0.25*shadowWidth );
        }
        pg.stroke( handColor );
        pg.strokeWeight( minuteWidth );
        pg.line( 0 , -minuteLengthFront , 0 , minuteLengthBack );
        pg.stroke(ridgeColor);
        pg.strokeWeight( minuteWidth*ridgeWidth );
        pg.line( 0 , -minuteLengthFront , 0 , minuteLengthBack );
        pg.popMatrix();
        
        
        pg.popMatrix();
        
        pg.endDraw();
        if( logClockUpdateTime) { println(dateText + " " +hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) ); }
      }
      image(pg , 0 , 0 );
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CLOCK TYPE 9 ///////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if( clockID == 9 ) {
      if( secondChanged || resetClock ) {
        
        secondChanged = false;
        resetClock = false;
        
        
        pg.beginDraw();
        pg.textAlign( LEFT , TOP );
        // values
        color bgColor = color( 0 , 0 , 0 , 160 );
        color textColor = color( 255 , 255 , 255 , 196 );;
        String dateText = dayOfTheWeek(month(),day(),year()) + ", " + monthText[month()-1] + " " + day(); 
        
        
        pg.clear();
        pg.noStroke();
                    
        
        float weatherWidth = 100;
        float weatherHeight = 0.24*height;
        float weatherGap = (height-4*weatherHeight)/5.0;
        float weatherX = width - 0.5*weatherWidth - weatherGap;
        float weatherCorner = 4;
        float day0_y = weatherGap*1+0.5*weatherHeight;
        float day1_y = weatherGap*2+1.5*weatherHeight;
        float day2_y = weatherGap*3+2.5*weatherHeight;
        float day3_y = weatherGap*4+3.5*weatherHeight;
        
        pg.fill( bgColor );
        pg.rect( weatherX - 0.5*weatherWidth , day0_y - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
        pg.rect( weatherX - 0.5*weatherWidth , day1_y - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
        pg.rect( weatherX - 0.5*weatherWidth , day2_y - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
        pg.rect( weatherX - 0.5*weatherWidth , day3_y - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
                 
        float dayTextSize = 20;
        float dayTextOffset = -45;
        float iconOffset = -30;
        float iconSize = icon0.width*0.7;
        float tempTextSize = 20;
        float tempTextOffset = 15;
        float windTextSize = 14;
        float windTextOffset = 40;
        
        
        pg.fill( textColor );
        pg.textAlign( CENTER , CENTER );
        pg.textSize( dayTextSize );
        pg.text( day0_dateText , weatherX , day0_y + dayTextOffset );
        pg.text( day1_dateText , weatherX , day1_y + dayTextOffset );
        pg.text( day2_dateText , weatherX , day2_y + dayTextOffset );
        pg.text( day3_dateText , weatherX , day3_y + dayTextOffset );
        pg.textSize( tempTextSize );
        pg.text( day0_tempText , weatherX , day0_y + tempTextOffset );
        pg.text( day1_tempText , weatherX , day1_y + tempTextOffset );
        pg.text( day2_tempText , weatherX , day2_y + tempTextOffset );
        pg.text( day3_tempText , weatherX , day3_y + tempTextOffset );
        pg.textSize( windTextSize );
        pg.text( day0_windTextMin , weatherX , day0_y + windTextOffset );
        pg.text( day1_windTextMin , weatherX , day1_y + windTextOffset );
        pg.text( day2_windTextMin , weatherX , day2_y + windTextOffset );
        pg.text( day3_windTextMin , weatherX , day3_y + windTextOffset );
        if( hour() >= sunsetHour - 1 ) {
          pg.image( icon0Night , weatherX - 0.5*iconSize , day0_y + iconOffset , iconSize , iconSize);
        } else {
          pg.image( icon0 , weatherX - 0.5*iconSize , day0_y + iconOffset , iconSize , iconSize );
        }
        pg.image( icon1 , weatherX - 0.5*iconSize , day1_y + iconOffset , iconSize , iconSize );
        pg.image( icon2 , weatherX - 0.5*iconSize , day2_y + iconOffset , iconSize , iconSize );
        pg.image( icon3 , weatherX - 0.5*iconSize , day3_y + iconOffset , iconSize , iconSize );
        
        
        
        float hourWidth = 12;
        float hourLengthFront = 140;
        float hourLengthBack = 30;
        float minuteWidth = 10;
        float minuteLengthFront = 170;
        float minuteLengthBack = 35;
        float secondWidth = 6;
        float secondLengthFront = 210;
        float secondLengthBack = 40;
        float shadowWidth = 4;
        float numShadows = 4;
        float shadowGrad = 4;
        
        color handColor = color( 255 , 255 , 255 , 255 );
        color shadowColor = color( 0 , 0 , 0 , 64 );
        color ridgeColor = color( 200 );
        float ridgeWidth = 0.2;
        
        pg.pushMatrix();
        
        pg.translate( halfWidth , halfHeight );

        pg.pushMatrix();
        pg.rotate(hourAngle);
        pg.stroke( shadowColor );
        for( float i = 1 ; i < numShadows ; i++ ) {
          pg.strokeWeight( hourWidth+shadowWidth+shadowGrad*i );
          pg.line( 0 , -hourLengthFront - 0.25*shadowWidth , 0 , hourLengthBack + 0.25*shadowWidth );
        }
        pg.stroke( handColor );
        pg.strokeWeight( hourWidth );
        pg.line( 0 , -hourLengthFront , 0 , hourLengthBack );
        pg.stroke(ridgeColor);
        pg.strokeWeight( hourWidth*ridgeWidth );
        pg.line( 0 , -hourLengthFront , 0 , hourLengthBack );
        pg.popMatrix();
        
        pg.pushMatrix();
        pg.rotate(minuteAngle);pg.stroke( shadowColor );
        for( float i = 1 ; i < numShadows ; i++ ) {
          pg.strokeWeight( minuteWidth+shadowWidth+shadowGrad*i );
          pg.line( 0 , -minuteLengthFront - 0.25*shadowWidth , 0 , minuteLengthBack + 0.25*shadowWidth );
        }
        pg.stroke( handColor );
        pg.strokeWeight( minuteWidth );
        pg.line( 0 , -minuteLengthFront , 0 , minuteLengthBack );
        pg.stroke(ridgeColor);
        pg.strokeWeight( minuteWidth*ridgeWidth );
        pg.line( 0 , -minuteLengthFront , 0 , minuteLengthBack );
        pg.popMatrix();
        
        pg.pushMatrix();
        pg.rotate(secondAngle);
        pg.stroke( shadowColor );
        for( float i = 1 ; i < numShadows ; i++ ) {
          pg.strokeWeight( secondWidth+shadowWidth+shadowGrad*i );
          pg.line( 0 , -secondLengthFront - 0.25*shadowWidth , 0 , secondLengthBack + 0.25*shadowWidth );
        }
        pg.stroke( handColor );
        pg.strokeWeight( secondWidth );
        pg.line( 0 , -secondLengthFront , 0 , secondLengthBack );
        pg.stroke(ridgeColor);
        pg.strokeWeight( secondWidth*ridgeWidth );
        pg.line( 0 , -secondLengthFront , 0 , secondLengthBack );
        pg.popMatrix();
        
        pg.popMatrix();
        
        pg.endDraw();
        if( logClockUpdateTime) { println(dateText + " " +hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) ); }
      }
      image(pg , 0 , 0 );
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CLOCK TYPE 7 ///////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if( clockID == 7 ) {
      if( secondChanged || resetClock ) {
        
        secondChanged = false;
        resetClock = false;
        
        pg.beginDraw();
        //pg.strokeCap( SQUARE );
        pg.clear();
        
        float hourWidth = 12;
        float hourLengthFront = 140;
        float hourLengthBack = 30;
        float minuteWidth = 10;
        float minuteLengthFront = 170;
        float minuteLengthBack = 35;
        float secondWidth = 6;
        float secondLengthFront = 210;
        float secondLengthBack = 40;
        float shadowWidth = 4;
        float numShadows = 4;
        float shadowGrad = 4;
        
        color handColor = color( 255 , 255 , 255 , 255 );
        color shadowColor = color( 0 , 0 , 0 , 64 );
        color ridgeColor = color( 200 );
        float ridgeWidth = 0.2;
        
        pg.pushMatrix();
        
        pg.translate( halfWidth , halfHeight );

        pg.pushMatrix();
        pg.rotate(hourAngle);
        pg.stroke( shadowColor );
        for( float i = 1 ; i < numShadows ; i++ ) {
          pg.strokeWeight( hourWidth+shadowWidth+shadowGrad*i );
          pg.line( 0 , -hourLengthFront - 0.25*shadowWidth , 0 , hourLengthBack + 0.25*shadowWidth );
        }
        pg.stroke( handColor );
        pg.strokeWeight( hourWidth );
        pg.line( 0 , -hourLengthFront , 0 , hourLengthBack );
        pg.stroke(ridgeColor);
        pg.strokeWeight( hourWidth*ridgeWidth );
        pg.line( 0 , -hourLengthFront , 0 , hourLengthBack );
        pg.popMatrix();
        
        pg.pushMatrix();
        pg.rotate(minuteAngle);pg.stroke( shadowColor );
        for( float i = 1 ; i < numShadows ; i++ ) {
          pg.strokeWeight( minuteWidth+shadowWidth+shadowGrad*i );
          pg.line( 0 , -minuteLengthFront - 0.25*shadowWidth , 0 , minuteLengthBack + 0.25*shadowWidth );
        }
        pg.stroke( handColor );
        pg.strokeWeight( minuteWidth );
        pg.line( 0 , -minuteLengthFront , 0 , minuteLengthBack );
        pg.stroke(ridgeColor);
        pg.strokeWeight( minuteWidth*ridgeWidth );
        pg.line( 0 , -minuteLengthFront , 0 , minuteLengthBack );
        pg.popMatrix();
        
        pg.pushMatrix();
        pg.rotate(secondAngle);
        pg.stroke( shadowColor );
        for( float i = 1 ; i < numShadows ; i++ ) {
          pg.strokeWeight( secondWidth+shadowWidth+shadowGrad*i );
          pg.line( 0 , -secondLengthFront - 0.25*shadowWidth , 0 , secondLengthBack + 0.25*shadowWidth );
        }
        pg.stroke( handColor );
        pg.strokeWeight( secondWidth );
        pg.line( 0 , -secondLengthFront , 0 , secondLengthBack );
        pg.stroke(ridgeColor);
        pg.strokeWeight( secondWidth*ridgeWidth );
        pg.line( 0 , -secondLengthFront , 0 , secondLengthBack );
        pg.popMatrix();
        
        pg.popMatrix();
        
        pg.endDraw();
        if( logClockUpdateTime) { println(hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) ); }
      }
      image( pg , 0 , 0 );
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CLOCK TYPE 8 ///////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if( clockID == 8 ) {
      if( secondChanged || resetClock ) {
        
        secondChanged = false;
        resetClock = false;
        
        pg.beginDraw();
        //pg.strokeCap( SQUARE );
        pg.clear();
        
        float hourWidth = 12;
        float hourLengthFront = 140;
        float hourLengthBack = 30;
        float minuteWidth = 10;
        float minuteLengthFront = 170;
        float minuteLengthBack = 35;
        float shadowWidth = 4;
        float numShadows = 4;
        float shadowGrad = 4;
        
        color handColor = color( 255 , 255 , 255 , 255 );
        color shadowColor = color( 0 , 0 , 0 , 64 );
        color ridgeColor = color( 200 );
        float ridgeWidth = 0.2;
        
        pg.pushMatrix();
        
        pg.translate( halfWidth , halfHeight );

        pg.pushMatrix();
        pg.rotate(hourAngle);
        pg.stroke( shadowColor );
        for( float i = 1 ; i < numShadows ; i++ ) {
          pg.strokeWeight( hourWidth+shadowWidth+shadowGrad*i );
          pg.line( 0 , -hourLengthFront - 0.25*shadowWidth , 0 , hourLengthBack + 0.25*shadowWidth );
        }
        pg.stroke( handColor );
        pg.strokeWeight( hourWidth );
        pg.line( 0 , -hourLengthFront , 0 , hourLengthBack );
        pg.stroke(ridgeColor);
        pg.strokeWeight( hourWidth*ridgeWidth );
        pg.line( 0 , -hourLengthFront , 0 , hourLengthBack );
        pg.popMatrix();
        
        pg.pushMatrix();
        pg.rotate(minuteAngle);pg.stroke( shadowColor );
        for( float i = 1 ; i < numShadows ; i++ ) {
          pg.strokeWeight( minuteWidth+shadowWidth+shadowGrad*i );
          pg.line( 0 , -minuteLengthFront - 0.25*shadowWidth , 0 , minuteLengthBack + 0.25*shadowWidth );
        }
        pg.stroke( handColor );
        pg.strokeWeight( minuteWidth );
        pg.line( 0 , -minuteLengthFront , 0 , minuteLengthBack );
        pg.stroke(ridgeColor);
        pg.strokeWeight( minuteWidth*ridgeWidth );
        pg.line( 0 , -minuteLengthFront , 0 , minuteLengthBack );
        pg.popMatrix();
        
        pg.popMatrix();
        
        pg.endDraw();
        if( logClockUpdateTime) { println(hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) ); }
      }
      image( pg , 0 , 0 );
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CLOCK TYPE 0 ///////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if( clockID == 0 ) {
      if( minuteChanged || resetClock ) {
        
        minuteChanged = false;
        resetClock = false;
        
        pg.beginDraw();
        pg.textAlign( LEFT , TOP );
        // values
        float timeCorner = 4;
        float dateCorner = 4;
        color bgColor = color( 0 , 0 , 0 , 160 );
        color textColor = color( 255 , 255 , 255 , 196 );
        float timeBorderX = 10;
        float timeBorderY = 0;
        float timeX = halfWidth;
        float timeY = height*0.2;
        float dateBorderX = 10;
        float dateBorderY = 5;
        float dateX = halfWidth;
        float dateY = height*0.05;
        float timeTextSize = 100;
        float ampmTextSize = 30;
        float dateTextSize = 20;
        float vertOffset = 0.6;
        float ampmOffset = -1;
        float dateOffset = -4;
        String timeText = hour()%12 + ":" + nf(minute(),2);
        if( hour()%12 == 0 ) {
          timeText = "12:" + nf(minute(),2);
        }
        String ampmText = " am";
        if( hour() > 12 ) { ampmText = " pm"; }
        String dateText = dayOfTheWeek(month(),day(),year()) + ", " + monthText[month()-1] + " " + day(); 
        
        pg.textFont(font1);
        pg.textSize( timeTextSize );
        float timeTextWidth = pg.textWidth( timeText );
        pg.textSize( ampmTextSize );
        float ampmTextWidth = pg.textWidth( ampmText );
        pg.textSize( dateTextSize );
        float dateTextWidth = pg.textWidth( dateText );
  
        pg.clear();
        pg.noStroke();
        pg.fill( bgColor );
        pg.rect( timeX - 0.5*(timeTextWidth+ampmTextWidth)-timeBorderX , timeY - 0.5*timeTextSize - timeBorderY , 
                 timeTextWidth+ampmTextWidth + 2*timeBorderX , timeTextSize + 2*timeBorderY , timeCorner , timeCorner , timeCorner , timeCorner );
        pg.fill( textColor );
        pg.textSize( timeTextSize );
        pg.text( timeText ,  timeX-0.5*(timeTextWidth+ampmTextWidth) , timeY - vertOffset*timeTextSize ); 
        pg.textSize( ampmTextSize );
        pg.text( ampmText ,  timeX-0.5*(timeTextWidth+ampmTextWidth)+timeTextWidth , 
                 timeY - vertOffset*timeTextSize + (timeTextSize-ampmTextSize) + ampmOffset ); 
                 
        pg.fill( bgColor );
        pg.rect( dateX - 0.5*(dateTextWidth)-timeBorderX , dateY - 0.5*dateTextSize - dateBorderY , 
                 dateTextWidth + 2*dateBorderX , dateTextSize + 2*dateBorderY , dateCorner , dateCorner , dateCorner , dateCorner );
        pg.fill( textColor );
        pg.textSize( dateTextSize );
        pg.text( dateText ,  dateX-0.5*(dateTextWidth) , dateY - 0.5*dateTextSize + dateOffset ); 
                 
        
        float weatherWidth = 0.16*width;
        float weatherHeight = 0.30*height;
        float weatherGap = (width-4*weatherWidth)/5.0;
        float weatherY = 0.83*height;
        float weatherCorner = 4;
        float day0_x = weatherGap*1+0.5*weatherWidth;
        float day1_x = weatherGap*2+1.5*weatherWidth;
        float day2_x = weatherGap*3+2.5*weatherWidth;
        float day3_x = weatherGap*4+3.5*weatherWidth;
        
        pg.fill( bgColor );
        pg.rect( day0_x - 0.5*weatherWidth , weatherY - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
        pg.rect( day1_x - 0.5*weatherWidth , weatherY - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
        pg.rect( day2_x - 0.5*weatherWidth , weatherY - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
        pg.rect( day3_x - 0.5*weatherWidth , weatherY - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
                 
        float dayTextSize = 25;
        float dayTextOffset = -60;
        float tempTextSize = 25;
        float tempTextOffset = 30;
        float windTextSize = 15;
        float windTextOffset = 55;
        float iconOffset = -35;
        float iconSize = icon0.width;
        
        pg.fill( textColor );
        pg.textAlign( CENTER , CENTER );
        pg.textSize( dayTextSize );
        pg.text( day0_dateText , day0_x , weatherY + dayTextOffset );
        pg.text( day1_dateText , day1_x , weatherY + dayTextOffset );
        pg.text( day2_dateText , day2_x , weatherY + dayTextOffset );
        pg.text( day3_dateText , day3_x , weatherY + dayTextOffset );
        pg.textSize( tempTextSize );
        pg.text( day0_tempText , day0_x , weatherY + tempTextOffset );
        pg.text( day1_tempText , day1_x , weatherY + tempTextOffset );
        pg.text( day2_tempText , day2_x , weatherY + tempTextOffset );
        pg.text( day3_tempText , day3_x , weatherY + tempTextOffset );
        pg.textSize( windTextSize );
        pg.text( day0_windText , day0_x , weatherY + windTextOffset );
        pg.text( day1_windText , day1_x , weatherY + windTextOffset );
        pg.text( day2_windText , day2_x , weatherY + windTextOffset );
        pg.text( day3_windText , day3_x , weatherY + windTextOffset );
        if( hour() >= sunsetHour - 1 ) {
          pg.image( icon0Night , day0_x - 0.5*iconSize , weatherY + iconOffset );
        } else {
          pg.image( icon0 , day0_x - 0.5*iconSize , weatherY + iconOffset );
        }
        pg.image( icon1 , day1_x - 0.5*iconSize , weatherY + iconOffset );
        pg.image( icon2 , day2_x - 0.5*iconSize , weatherY + iconOffset );
        pg.image( icon3 , day3_x - 0.5*iconSize , weatherY + iconOffset );
        
        
        pg.endDraw();
        if( logClockUpdateTime) { println(dateText + " " +hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) ); }
      }
      image(pg , 0 , 0 );
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CLOCK TYPE 6 ///////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if( clockID == 6 ) {
      if( minuteChanged || resetClock ) {
        
        minuteChanged = false;
        resetClock = false;
        
        pg.beginDraw();
        pg.textAlign( LEFT , TOP );
        // values
        float timeCorner = 4;
        float dateCorner = 4;
        color bgColor = color( 0 , 0 , 0 , 160 );
        color textColor = color( 255 , 255 , 255 , 196 );
        
        float timeTextSize = 60;
        float ampmTextSize = 30;
        float dateTextSize = 20;
        float vertOffset = 0.6;
        float ampmOffset = -1;
        float dateOffset = -4;
        String timeText = hour()%12 + ":" + nf(minute(),2);
        if( hour()%12 == 0 ) {
          timeText = "12:" + nf(minute(),2);
        }
        String ampmText = " am";
        if( hour() > 12 ) { ampmText = " pm"; }
        String dateText = dayOfTheWeek(month(),day(),year()) + ", " + monthText[month()-1] + " " + day(); 
        
        pg.textFont(font1);
        pg.textSize( timeTextSize );
        float timeTextWidth = pg.textWidth( timeText );
        pg.textSize( ampmTextSize );
        float ampmTextWidth = pg.textWidth( ampmText );
        pg.textSize( dateTextSize );
        float dateTextWidth = pg.textWidth( dateText );
        
        float timeBorderX = 10;
        float timeBorderY = 0;
        float timeX = 4+0.5*(timeTextWidth+ampmTextWidth)+timeBorderX;
        float timeY = 4+0.5*(timeTextSize+timeBorderY);
        float dateBorderX = 10;
        float dateBorderY = 5;
        float dateX = 4+0.5*(dateTextWidth)+dateBorderX;;
        float dateY = height - ( 6+0.5*(dateTextSize+dateBorderY) );
        
        pg.clear();
        pg.noStroke();
        pg.fill( bgColor );
        pg.rect( timeX - 0.5*(timeTextWidth+ampmTextWidth)-timeBorderX , timeY - 0.5*timeTextSize - timeBorderY , 
                 timeTextWidth+ampmTextWidth + 2*timeBorderX , timeTextSize + 2*timeBorderY , timeCorner , timeCorner , timeCorner , timeCorner );
        pg.fill( textColor );
        pg.textSize( timeTextSize );
        pg.text( timeText ,  timeX-0.5*(timeTextWidth+ampmTextWidth) , timeY - vertOffset*timeTextSize ); 
        pg.textSize( ampmTextSize );
        pg.text( ampmText ,  timeX-0.5*(timeTextWidth+ampmTextWidth)+timeTextWidth , 
                 timeY - vertOffset*timeTextSize + (timeTextSize-ampmTextSize) + ampmOffset ); 
                 
        pg.fill( bgColor );
        pg.rect( dateX - 0.5*(dateTextWidth)-timeBorderX , dateY - 0.5*dateTextSize - dateBorderY , 
                 dateTextWidth + 2*dateBorderX , dateTextSize + 2*dateBorderY , dateCorner , dateCorner , dateCorner , dateCorner );
        pg.fill( textColor );
        pg.textSize( dateTextSize );
        pg.text( dateText ,  dateX-0.5*(dateTextWidth) , dateY - 0.5*dateTextSize + dateOffset ); 
                 
        
        float weatherWidth = 100;
        float weatherHeight = 0.24*height;
        float weatherGap = (height-4*weatherHeight)/5.0;
        float weatherX = width - 0.5*weatherWidth - weatherGap;
        float weatherCorner = 4;
        float day0_y = weatherGap*1+0.5*weatherHeight;
        float day1_y = weatherGap*2+1.5*weatherHeight;
        float day2_y = weatherGap*3+2.5*weatherHeight;
        float day3_y = weatherGap*4+3.5*weatherHeight;
        
        pg.fill( bgColor );
        pg.rect( weatherX - 0.5*weatherWidth , day0_y - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
        pg.rect( weatherX - 0.5*weatherWidth , day1_y - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
        pg.rect( weatherX - 0.5*weatherWidth , day2_y - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
        pg.rect( weatherX - 0.5*weatherWidth , day3_y - 0.5*weatherHeight , weatherWidth , weatherHeight ,
                 weatherCorner , weatherCorner , weatherCorner , weatherCorner );
                 
        float dayTextSize = 20;
        float dayTextOffset = -45;
        float iconOffset = -30;
        float iconSize = icon0.width*0.7;
        float tempTextSize = 20;
        float tempTextOffset = 15;
        float windTextSize = 14;
        float windTextOffset = 40;
        
        
        pg.fill( textColor );
        pg.textAlign( CENTER , CENTER );
        pg.textSize( dayTextSize );
        pg.text( day0_dateText , weatherX , day0_y + dayTextOffset );
        pg.text( day1_dateText , weatherX , day1_y + dayTextOffset );
        pg.text( day2_dateText , weatherX , day2_y + dayTextOffset );
        pg.text( day3_dateText , weatherX , day3_y + dayTextOffset );
        pg.textSize( tempTextSize );
        pg.text( day0_tempText , weatherX , day0_y + tempTextOffset );
        pg.text( day1_tempText , weatherX , day1_y + tempTextOffset );
        pg.text( day2_tempText , weatherX , day2_y + tempTextOffset );
        pg.text( day3_tempText , weatherX , day3_y + tempTextOffset );
        pg.textSize( windTextSize );
        pg.text( day0_windTextMin , weatherX , day0_y + windTextOffset );
        pg.text( day1_windTextMin , weatherX , day1_y + windTextOffset );
        pg.text( day2_windTextMin , weatherX , day2_y + windTextOffset );
        pg.text( day3_windTextMin , weatherX , day3_y + windTextOffset );
        if( hour() >= sunsetHour - 1 ) {
          pg.image( icon0Night , weatherX - 0.5*iconSize , day0_y + iconOffset , iconSize , iconSize);
        } else {
          pg.image( icon0 , weatherX - 0.5*iconSize , day0_y + iconOffset , iconSize , iconSize );
        }
        pg.image( icon1 , weatherX - 0.5*iconSize , day1_y + iconOffset , iconSize , iconSize );
        pg.image( icon2 , weatherX - 0.5*iconSize , day2_y + iconOffset , iconSize , iconSize );
        pg.image( icon3 , weatherX - 0.5*iconSize , day3_y + iconOffset , iconSize , iconSize );
        
        
        pg.endDraw();
        if( logClockUpdateTime) { println(dateText + " " +hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) ); }
      }
      image(pg , 0 , 0 );
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CLOCK TYPE 1 ///////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if( clockID == 1 ) {
      if( minuteChanged || resetClock ) {
        
        minuteChanged = false;
        resetClock = false;
        pg.beginDraw();
        pg.textAlign( LEFT , TOP );
        // values
        float timeCorner = 6;
        color bgColor = color( 0 , 0 , 0 , 160 );
        color textColor = color( 255 , 255 , 255 , 196 );
        float timeBorderX = 10;
        float timeBorderY = 0;
        float timeX = halfWidth;
        float timeY = halfHeight;
        float timeTextSize = 100;
        float ampmTextSize = 40;
        float vertOffset = 0.6;
        float ampmOffset = -10;
        String timeText = hour()%12 + ":" + nf(minute(),2);
        if( hour()%12 == 0 ) {
          timeText = "12:" + nf(minute(),2);
        }
        String ampmText = " am";
        if( hour() > 12 ) { ampmText = " pm"; }
        
        pg.textFont(font1);
        pg.textSize( timeTextSize );
        float timeTextWidth = pg.textWidth( timeText );
        pg.textSize( ampmTextSize );
        float ampmTextWidth = pg.textWidth( ampmText );
  
        pg.clear();
        pg.noStroke();
        pg.fill( bgColor );
        pg.rect( timeX - 0.5*(timeTextWidth+ampmTextWidth)-timeBorderX , timeY - 0.5*timeTextSize - timeBorderY , 
                 timeTextWidth+ampmTextWidth + 2*timeBorderX , timeTextSize + 2*timeBorderY , timeCorner , timeCorner , timeCorner , timeCorner );
        pg.fill( textColor );
        pg.textSize( timeTextSize );
        pg.text( timeText ,  timeX-0.5*(timeTextWidth+ampmTextWidth) , timeY - vertOffset*timeTextSize ); 
        pg.textSize( ampmTextSize );
        pg.text( ampmText ,  timeX-0.5*(timeTextWidth+ampmTextWidth)+timeTextWidth , 
                 timeY - vertOffset*timeTextSize + (timeTextSize-ampmTextSize) + ampmOffset ); 
        pg.endDraw();
        if( logClockUpdateTime) { println(hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) ); }
      }
      image(pg , 0 , 0 );
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CLOCK TYPE 2 ///////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if( clockID == 2  ) {
      if(  minuteChanged || resetClock ) {
        
        minuteChanged = false;
        resetClock = false;
        pg.beginDraw();
        pg.textAlign( LEFT , TOP );
        // values
        float timeCorner = 10;
        color bgColor = color( 0 , 0 , 0 , 160 );
        color textColor = color( 255 , 255 , 255 , 196 );
        float timeTextSize = 200;
        float ampmTextSize = 40;
        float timeBorderX = 10;
        float timeBorderY = -10;
        float timeX = halfWidth;
        float timeY = halfHeight;
        float vertOffset = 0.6;
        float ampmOffset = -10;
        String timeText = hour()%12 + ":" + nf(minute(),2);
        if( hour()%12 == 0 ) {
          timeText = "12:" + nf(minute(),2);
        }
        String ampmText = " am";
        if( hour() > 12 ) { ampmText = " pm"; }
        
        pg.textFont(font1);
        pg.textSize( timeTextSize );
        float timeTextWidth = pg.textWidth( timeText );
        pg.textSize( ampmTextSize );
        float ampmTextWidth = pg.textWidth( ampmText );
  
        pg.clear();
        pg.noStroke();
        pg.fill( bgColor );
        pg.rect( timeX - 0.5*(timeTextWidth+ampmTextWidth)-timeBorderX , timeY - 0.5*timeTextSize - timeBorderY , 
                 timeTextWidth+ampmTextWidth + 2*timeBorderX , timeTextSize + 2*timeBorderY , timeCorner , timeCorner , timeCorner , timeCorner );
        pg.fill( textColor );
        pg.textSize( timeTextSize );
        pg.text( timeText ,  timeX-0.5*(timeTextWidth+ampmTextWidth) , timeY - vertOffset*timeTextSize ); 
        pg.textSize( ampmTextSize );
        pg.text( ampmText ,  timeX-0.5*(timeTextWidth+ampmTextWidth)+timeTextWidth , 
                 timeY - vertOffset*timeTextSize + (timeTextSize-ampmTextSize) + ampmOffset ); 
        pg.endDraw();
        if( logClockUpdateTime) { println(hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) ); }
      }
      image(pg , 0 , 0 );
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CLOCK TYPE 3 ///////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if( clockID == 3 ) {
      if( resetClock ) {
        
      }
      // no clock
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CLOCK TYPE 4 ///////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if( clockID == 4 ) {
      if( minuteChanged || resetClock ) {
        
        resetClock = false;
        minuteChanged = false;
        pg.beginDraw();
        pg.textAlign( LEFT , TOP );
        // values
        float timeCorner = 6;
        float dateCorner = 4;
        float timeTextSize = 80;
        float ampmTextSize = 30;
        float dateTextSize = 30;
        color bgColor = color( 0 , 0 , 0 , 160 );
        color textColor = color( 255 , 255 , 255 , 196 );
        float timeBorderX = 10;
        float timeBorderY = -2;
        float timeX = halfWidth;
        float timeY = 6 + 0.5*timeTextSize + timeBorderY;
        float dateBorderX = 10;
        float dateBorderY = 5;
        float dateX = halfWidth;
        float dateY = height - (6 + 0.5*dateTextSize + dateBorderY);
        float vertOffset = 0.6;
        float ampmOffset = 0;
        float dateOffset = -4;
        String timeText = hour()%12 + ":" + nf(minute(),2);
        if( hour()%12 == 0 ) {
          timeText = "12:" + nf(minute(),2);
        }
        String ampmText = " am";
        if( hour() > 12 ) { ampmText = " pm"; }
        String dateText = dayOfTheWeek(month(),day(),year()) + ", " + monthText[month()-1] + " " + day(); 
                
        pg.textFont(font1);
        pg.textSize( timeTextSize );
        float timeTextWidth = pg.textWidth( timeText );
        pg.textSize( ampmTextSize );
        float ampmTextWidth = pg.textWidth( ampmText );
        pg.textSize( dateTextSize );
        float dateTextWidth = pg.textWidth( dateText );
  
        pg.clear();
        pg.noStroke();
        pg.fill( bgColor );
        pg.rect( timeX - 0.5*(timeTextWidth+ampmTextWidth)-timeBorderX , timeY - 0.5*timeTextSize - timeBorderY , 
                 timeTextWidth+ampmTextWidth + 2*timeBorderX , timeTextSize + 2*timeBorderY , timeCorner , timeCorner , timeCorner , timeCorner );
        pg.fill( textColor );
        pg.textSize( timeTextSize );
        pg.text( timeText ,  timeX-0.5*(timeTextWidth+ampmTextWidth) , timeY - vertOffset*timeTextSize ); 
        pg.textSize( ampmTextSize );
        pg.text( ampmText ,  timeX-0.5*(timeTextWidth+ampmTextWidth)+timeTextWidth , 
                 timeY - vertOffset*timeTextSize + (timeTextSize-ampmTextSize) + ampmOffset ); 
                 
        pg.fill( bgColor );
        pg.rect( dateX - 0.5*(dateTextWidth)-timeBorderX , dateY - 0.5*dateTextSize - dateBorderY , 
                 dateTextWidth + 2*dateBorderX , dateTextSize + 2*dateBorderY , dateCorner , dateCorner , dateCorner , dateCorner );
        pg.fill( textColor );
        pg.textSize( dateTextSize );
        pg.text( dateText ,  dateX-0.5*(dateTextWidth) , dateY - 0.5*dateTextSize + dateOffset ); 
                 
        
        pg.endDraw();
        if( logClockUpdateTime) { println(dateText + " " +hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) ); }
      }
      image(pg , 0 , 0 );
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CLOCK TYPE 5 ///////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if( clockID == 5  ) {
      if( minuteChanged || resetClock ) {
        
        resetClock = false;
        minuteChanged = false;
        pg.beginDraw();
        pg.textAlign( LEFT , TOP );
        // values
        float timeCorner = 12;
        float dateCorner = 6;
        color bgColor = color( 0 , 0 , 0 , 160 );
        color textColor = color( 255 , 255 , 255 , 196 );
        float timeBorderX = 10;
        float timeBorderY = -20;
        float timeX = halfWidth;
        float timeY = halfHeight;
        float dateBorderX = 10;
        float dateBorderY = 5;
        float dateX = halfWidth;
        float dateY = height*0.75;
        float timeTextSize = 200;
        float ampmTextSize = 40;
        float dateTextSize = 40;
        float vertOffset = 0.6;
        float ampmOffset = -10;
        float dateOffset = -4;
        String timeText = hour()%12 + ":" + nf(minute(),2);
        if( hour()%12 == 0 ) {
          timeText = "12:" + nf(minute(),2);
        }
        String ampmText = " am";
        if( hour() > 12 ) { ampmText = " pm"; }
        String dateText = dayOfTheWeek(month(),day(),year()) + ", " + monthText[month()-1] + " " + day(); 
        
        pg.textFont(font1);
        pg.textSize( timeTextSize );
        float timeTextWidth = pg.textWidth( timeText );
        pg.textSize( ampmTextSize );
        float ampmTextWidth = pg.textWidth( ampmText );
        pg.textSize( dateTextSize );
        float dateTextWidth = pg.textWidth( dateText );
  
        pg.clear();
        pg.noStroke();
        pg.fill( bgColor );
        pg.rect( timeX - 0.5*(timeTextWidth+ampmTextWidth)-timeBorderX , timeY - 0.5*timeTextSize - timeBorderY , 
                 timeTextWidth+ampmTextWidth + 2*timeBorderX , timeTextSize + 2*timeBorderY , timeCorner , timeCorner , timeCorner , timeCorner );
        pg.fill( textColor );
        pg.textSize( timeTextSize );
        pg.text( timeText ,  timeX-0.5*(timeTextWidth+ampmTextWidth) , timeY - vertOffset*timeTextSize ); 
        pg.textSize( ampmTextSize );
        pg.text( ampmText ,  timeX-0.5*(timeTextWidth+ampmTextWidth)+timeTextWidth , 
                 timeY - vertOffset*timeTextSize + (timeTextSize-ampmTextSize) + ampmOffset ); 
                 
        pg.fill( bgColor );
        pg.rect( dateX - 0.5*(dateTextWidth)-timeBorderX , dateY - 0.5*dateTextSize - dateBorderY , 
                 dateTextWidth + 2*dateBorderX , dateTextSize + 2*dateBorderY , dateCorner , dateCorner , dateCorner , dateCorner );
        pg.fill( textColor );
        pg.textSize( dateTextSize );
        pg.text( dateText ,  dateX-0.5*(dateTextWidth) , dateY - 0.5*dateTextSize + dateOffset ); 
                 
        
        pg.endDraw();
        if( logClockUpdateTime) { println(dateText + " " +hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) ); }
      }
      image(pg , 0 , 0 );
    }
    
    
  }
  
  void updateAstronomy() {
    if( liveData ) {
      try {
        astro = loadXML( API_URL_astronomy );
        saveXML( astro , "weatherdata/mostRecentAstro.xml" );
      } catch ( Exception e ) {
        astro = loadXML("weatherdata/mostRecentAstro.xml");
      }
    } else {
      astro = loadXML("weatherdata/mostRecentAstro.xml");
    }
    
    sunriseHour = Integer.parseInt(astro.getChild("sun_phase/sunrise/hour").getContent("hour"));
    sunsetHour = Integer.parseInt(astro.getChild("sun_phase/sunset/hour").getContent("hour"));
    println( "---------------" );
    println( "sunriseHour = " + sunriseHour + "  ;  sunsetHour = " + sunsetHour );
    println("UPDATED ASTRONOMY AT " + hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) );
    println( API_URL_astronomy );
    println( "---------------" );
  }
  
  void updateWeather() {
    if( liveData ) {
      try {
        w = loadXML( API_URL_forecast );
        saveXML( w , "weatherdata/mostRecentWeather.xml" );
      } catch(Exception e) {
        w =  loadXML("weatherdata/mostRecentWeather.xml");
      }
    } else {
      w =  loadXML("weatherdata/mostRecentWeather.xml");
    }
    println( "---------------" );
    day0_dayName = w.getChild("forecast/simpleforecast/forecastdays").getChild(1).getChild("date/weekday_short").getContent("weekday_short");
    day0_dayNum = w.getChild("forecast/simpleforecast/forecastdays").getChild(1).getChild("date/day").getContent("day");
    day0_high = w.getChild("forecast/simpleforecast/forecastdays").getChild(1).getChild("high/fahrenheit").getContent("fahrenheit");
    day0_low = w.getChild("forecast/simpleforecast/forecastdays").getChild(1).getChild("low/fahrenheit").getContent("fahrenheit");
    day0_icon_url = w.getChild("forecast/simpleforecast/forecastdays").getChild(1).getChild("icon_url").getContent("icon_url");
    day0_icon_url_night = w.getChild("forecast/txt_forecast/forecastdays").getChild(3).getChild("icon_url").getContent("icon_url");
    day0_windavg = w.getChild("forecast/simpleforecast/forecastdays").getChild(1).getChild("avewind/mph").getContent("mph");
    day0_winddir = w.getChild("forecast/simpleforecast/forecastdays").getChild(1).getChild("avewind/dir").getContent("dir");
    try {
      icon0 = loadImage( day0_icon_url );
      icon0.save( "weatherdata/icon0.png" );
    } catch(Exception e ) {
      icon0 = loadImage( "weatherdata/icon0.png" );
    }
    try {
      icon0Night = loadImage( day0_icon_url_night );
      icon0Night.save( "weatherdata/icon0Night.png" );
    } catch(Exception e ) {
      icon0Night = loadImage( "weatherdata/icon0.png" );
    }
    day0_dateText = ( day0_dayName + " | " + day0_dayNum );
    day0_tempText = ( day0_high + " | " + day0_low );
    day0_windText = ( day0_winddir + " at " + day0_windavg + " mph" );
    day0_windTextMin = ( day0_winddir + " at " + day0_windavg );
    println( day0_dayName + " , " + day0_dayNum );
    println( day0_high + " | " + day0_low );
    println( day0_icon_url );
    println( day0_winddir + " at " + day0_windavg + " mph" );
    println( "-----" );
    
    day1_dayName = w.getChild("forecast/simpleforecast/forecastdays").getChild(3).getChild("date/weekday_short").getContent("weekday_short");
    day1_dayNum = w.getChild("forecast/simpleforecast/forecastdays").getChild(3).getChild("date/day").getContent("day");
    day1_high = w.getChild("forecast/simpleforecast/forecastdays").getChild(3).getChild("high/fahrenheit").getContent("fahrenheit");
    day1_low = w.getChild("forecast/simpleforecast/forecastdays").getChild(3).getChild("low/fahrenheit").getContent("fahrenheit");
    day1_icon_url = w.getChild("forecast/simpleforecast/forecastdays").getChild(3).getChild("icon_url").getContent("icon_url");
    day1_windavg = w.getChild("forecast/simpleforecast/forecastdays").getChild(3).getChild("avewind/mph").getContent("mph");
    day1_winddir = w.getChild("forecast/simpleforecast/forecastdays").getChild(3).getChild("avewind/dir").getContent("dir");
    try {
      icon1 = loadImage( day1_icon_url );
      icon1.save( "weatherdata/icon1.png" );
    } catch(Exception e ) {
      icon1 = loadImage( "weatherdata/icon1.png" );
    }
    day1_dateText = ( day1_dayName + " | " + day1_dayNum );
    day1_tempText = ( day1_high + " | " + day1_low );
    day1_windText = ( day1_winddir + " at " + day1_windavg + " mph" );
    day1_windTextMin = ( day1_winddir + " at " + day1_windavg );
    println( day1_dayName + " , " + day1_dayNum );
    println( "hi: " + day1_high + " | lo: " + day1_low );
    println( day1_icon_url );
    println( day1_winddir + " at " + day1_windavg + " mph" );
    println( "-----" );
    
    day2_dayName = w.getChild("forecast/simpleforecast/forecastdays").getChild(5).getChild("date/weekday_short").getContent("weekday_short");
    day2_dayNum = w.getChild("forecast/simpleforecast/forecastdays").getChild(5).getChild("date/day").getContent("day");
    day2_high = w.getChild("forecast/simpleforecast/forecastdays").getChild(5).getChild("high/fahrenheit").getContent("fahrenheit");
    day2_low = w.getChild("forecast/simpleforecast/forecastdays").getChild(5).getChild("low/fahrenheit").getContent("fahrenheit");
    day2_icon_url = w.getChild("forecast/simpleforecast/forecastdays").getChild(5).getChild("icon_url").getContent("icon_url");
    day2_windavg = w.getChild("forecast/simpleforecast/forecastdays").getChild(5).getChild("avewind/mph").getContent("mph");
    day2_winddir = w.getChild("forecast/simpleforecast/forecastdays").getChild(5).getChild("avewind/dir").getContent("dir");
    try {
      icon2 = loadImage( day2_icon_url );
      icon2.save( "weatherdata/icon2.png" );
    } catch(Exception e ) {
      icon2 = loadImage( "weatherdata/icon2.png" );
    }
    day2_dateText = ( day2_dayName + " | " + day2_dayNum );
    day2_tempText = ( day2_high + " | " + day2_low );
    day2_windText = ( day2_winddir + " at " + day2_windavg + " mph" );
    day2_windTextMin = ( day2_winddir + " at " + day2_windavg );
    println( day2_dayName + " , " + day2_dayNum );
    println( "high: " + day2_high + " | low: " + day2_low );
    println( day2_icon_url );
    println( day2_winddir + " at " + day2_windavg + " mph" );
    println( "-----" );
    
    day3_dayName = w.getChild("forecast/simpleforecast/forecastdays").getChild(7).getChild("date/weekday_short").getContent("weekday_short");
    day3_dayNum = w.getChild("forecast/simpleforecast/forecastdays").getChild(7).getChild("date/day").getContent("day");
    day3_high = w.getChild("forecast/simpleforecast/forecastdays").getChild(7).getChild("high/fahrenheit").getContent("fahrenheit");
    day3_low = w.getChild("forecast/simpleforecast/forecastdays").getChild(7).getChild("low/fahrenheit").getContent("fahrenheit");
    day3_icon_url = w.getChild("forecast/simpleforecast/forecastdays").getChild(7).getChild("icon_url").getContent("icon_url");
    day3_windavg = w.getChild("forecast/simpleforecast/forecastdays").getChild(7).getChild("avewind/mph").getContent("mph");
    day3_winddir = w.getChild("forecast/simpleforecast/forecastdays").getChild(7).getChild("avewind/dir").getContent("dir");
    try {
      icon3 = loadImage( day3_icon_url );
      icon3.save( "weatherdata/icon3.png" );
    } catch(Exception e ) {
      icon3 = loadImage( "weatherdata/icon3.png" );
    }
    day3_dateText = ( day3_dayName + " | " + day3_dayNum );
    day3_tempText = ( day3_high + " | " + day3_low );
    day3_windText = ( day3_winddir + " at " + day3_windavg + " mph" );
    day3_windTextMin = ( day3_winddir + " at " + day3_windavg );
    println( day3_dayName + " , " + day3_dayNum );
    println( "high: " + day3_high + " | low: " + day3_low );
    println( day3_icon_url );
    println( day3_winddir + " at " + day3_windavg + " mph" );
    println( "-----" );
    println("UPDATED WEATHER AT " + hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) );
    println( API_URL_forecast );
    println( "---------------" );
    
  }
  
}




String dayOfTheWeek( int m , int d , int y ) {
  int c = 0;
  int g = 0;
  if( m >= 3 ) {
    c = floor( y/100 );
    g = y - 100*c;
  } else {
    c = floor( (y-1)/100 );
    g = y-1-100*c;
  }
  int[] e = { 0 , 3 , 2 , 5 , 0 , 3 , 5 , 1 , 4 , 6 , 2 , 4 };
  int[] f = { 0 , 5 , 3 , 1 };
  int w = ( d + e[m-1] + f[c%4] + g + floor(g/4) ) % 7;
  String[] dayText = { "Sunday" , "Monday" , "Tuesday" , "Wednesday" , "Thursday" , "Friday" , "Saturday" };
  return dayText[w];
}