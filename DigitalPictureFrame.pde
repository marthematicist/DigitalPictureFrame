String zip = "98264";
String APIkey = "41ece43d5325fc28";
Boolean liveData = true;    // set true to get real data from api, false for testing
Boolean logClockUpdateTime = false;
Boolean testing = false;
WeatherCanvas W;
int bgMode = 0;
int numModes = 2;
boolean modeChangeSwitch;
SlideShow Photos;
float offsetAngle = 0;
float offsetPix = 10;
float offsetAngleSpeed = 0.000001;

void settings() {
  fullScreen();
}
void setup() {
  if( testing ) { frameRate(16); }
  size( 800 , 480 );
  pg = createGraphics( width , height );
  halfWidth = width/2;
  halfHeight = height/2;
  xRes = float(width);
  yRes = float(height);
  
  //clock = new Clock();
  try {
    W = new WeatherCanvas(width, height);
    if( bgMode == 0 ) {
      W.bgColor = color( 0,64 );
    }
    if( bgMode == 1 ) {
      W.bgColor = color( 0,128 );
    }
    W.update( true );
    W.drawCanvas();
    Photos = new SlideShow( "E:\\media" );
  } catch( Exception e) {
    println( e.getMessage() );
    exit();
  }
  
  PE = new PixelEngine(2);
  PE.createNewRandomizerThread();
  PE.startRandomizerThread();
}

boolean debug = false;

void draw() {
  if( modeChangeSwitch ) {
    modeChangeSwitch = false;
    bgMode++;
    if( bgMode >= numModes ) {
      bgMode = 0;
    }
    if( bgMode == 0 ) {
      W.bgColor = color( 0,64 );
    }
    if( bgMode == 1 ) {
      W.bgColor = color( 0,128 );
    }
    W.update( true );
    W.drawCanvas();
  }
  
  
  if( bgMode == 1 ) {
    int st = millis();
    // Randomizer:
    // stop randomizer
    
    PE.interruptRandomizerThread();
    PE.waitForRandomizerThreadToFinish();
    if( debug ) { println( frameCount + " randomizer Thread Finished At " + (millis()-st) ); }
    // if randomizer is done, update with new random numbers
    if( PE.randomNumbersReady() ) {
      PE.updateRandomNumbers();
      if( debug ) { println( frameCount + " random Numbers Updated At " + (millis()-st) ); }
    }
    // update randomizer progress
    PE.updateRandomizerProgress();
    if( debug ) { println( frameCount + " randomizer progress updated at " + (millis()-st) ); }
    
    // start pixel block threads
    PE.createNewBlockThreads();
    PE.startBlockThreads();
    if( debug ) { println( frameCount + " pixel threads started at " + (millis()-st) ); }
    
    // restart randomizer thread
    PE.createNewRandomizerThread();
    PE.startRandomizerThread();
    if( debug ) { println( frameCount + " randomizer thread started at " + (millis()-st) ); }
    
    // get pixel data
    //int[] pixelColors = PE.outputPixelData();
    //if( debug ) { println( frameCount + " pixel data retrieved at " + (millis()-st) ); }
    
    // update pixels
    loadPixels();
    PE.writePixelData();
    updatePixels();
    if( debug ) { println( frameCount + " pixels drawn at " + (millis()-st) ); }
      
    PE.waitForBlockThreadsToFinish();
    if( debug ) { println( frameCount + " pixel threads done at " + (millis()-st) ); }
    
    PE.fixColorValues();
    if( debug ) { println( frameCount + " color values fixed at " + (millis()-st) ); }
    
    if( frameCount%60 == 0 ) {
      println( frameCount , frameRate );
    }
    if( debug ) { println( frameCount + " frame over at " + (millis()-st) ); }
    if( debug ) { println( "_________________________" ); }
  }
  
  if( bgMode == 0 ) {
    try {
      Photos.draw();
      image( Photos.buffer , 0 , 0 );
    } catch( Exception e ) {
      println( e.getMessage() );
      exit();
    }
  }
  
  if( weatherOn ) {
    try {
      W.update(false);
      offsetAngle = millis()*offsetAngleSpeed;
      image( W.buf, offsetPix*cos(offsetAngle) , offsetPix*sin(offsetAngle) );
    } catch( Exception e ) {
      println( e.getMessage() );
      exit();
    }
  }
  
  if( mouseDownQuit ) {
    if( millis() - mousePressTime > mousePressTimeout ) {
      exit();
    }
    if( millis() - mousePressTime > mouseMessageDelay ) {
      String msg = "CLOSING IN " + ( (mousePressTimeout - (millis() - mousePressTime) )/1000+1 );
      showSystemMessage( msg );
    }
  }
  
  if( alphaSliderEngaged ) {
    alpha = lerpCube( alphaMin , alphaMax , float(mouseX)/float(width) );
    String msg = "smoothness =  " + nf( float( round( alpha*1000 ) ) / 1000 , 0 , 3);
    showSystemMessage( msg );
  }
  if( speedSliderEngaged ) {
    masterSpeed = lerpCube( speedMin , speedMax , float(mouseX)/float(width) );
    String msg = "speed =  " + nf( float( round( masterSpeed*100 ) ) / 100 , 0 , 2);
    showSystemMessage( msg );
  }
  
  if( captureScreenshot ) {
    captureScreenshot = false;
    save( "screenShot.jpg" );
  }
}


int prevSecond = -1;
int prevMin = -1;
int prevHour = -1;
int prevDay = -1;
boolean secondChanged = false;
boolean minuteChanged = false;
boolean hourChanged = false;
boolean dayChanged = false;
boolean resetClock = false;

boolean mouseDownQuit = false;
int mousePressTime = 0;
int mousePressTimeout = 6000;
int mouseMessageDelay = 1000;

float sliderHeight = 30;
boolean speedSliderEngaged = false;
boolean alphaSliderEngaged = false;
float alphaMin = 0.001;
float alphaMax = 1;
float speedMin = 0;
float speedMax = 10;
boolean weatherOn = true;
boolean captureScreenshot = false;

void mousePressed() {
  if( mouseY >= sliderHeight && height - mouseY >= sliderHeight ) { 
    mouseDownQuit = true;
    weatherOn = !weatherOn;
    /*
    if( mouseX >= halfWidth ) { clock.nextClock(); }
    else { clock.prevClock(); }
    */
  } else {
    if( mouseY >sliderHeight ) {
      speedSliderEngaged = true;
    }
    if( height - mouseY > sliderHeight ) {
      alphaSliderEngaged = true;
    }
  }
  
  resetClock = true;
  mousePressTime = millis();
}

void mouseReleased() {
  mouseDownQuit = false;
  speedSliderEngaged = false;
  alphaSliderEngaged = false;
  
}

void keyPressed() {
  println( keyCode );
  if( key == 's' ) {
    captureScreenshot = true;
  }
  if( keyCode == 32 ) {
    modeChangeSwitch = true;
  }
  if( keyCode == 38 ) {
    Photos.rotateCommandFlag = true;
    Photos.rotateCommandAng = -90;
  }
  if( keyCode == 40 ) {
    Photos.rotateCommandFlag = true;
    Photos.rotateCommandAng = 90;
  }
  if( keyCode == 37 || keyCode == 39 ) {
    Photos.rotateCommandFlag = true;
    Photos.rotateCommandAng = 180;
  }
  if( keyCode == 33 ) {
    Photos.nextImageTrigger = true;
  }
  if( keyCode == 34 ) {
    Photos.prevImageTrigger = true;
  }
}

void showSystemMessage( String systemText ) {
  textAlign(CENTER,CENTER);
      textSize(40);
      rectMode(CENTER);
      fill(255,0,0,196);
      stroke( 255 );
      strokeWeight( 5);
      float msgWidth = textWidth( systemText );
      rect(halfWidth , halfHeight+5 , msgWidth + 20 , 60 , 10 , 10 , 10 , 10 );
      fill(255);
      text( systemText , halfWidth , halfHeight );
}


float lerpSquare( float val1 , float val2 , float amt ) {
  return lerp( val1 , val2 , amt*amt );
}

float lerpCube( float val1 , float val2 , float amt ) {
  return lerp( val1 , val2 , amt*amt*amt );
}