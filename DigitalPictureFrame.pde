SlideShow Photos;
import java.util.Calendar;
WeatherCanvas W;
float offsetAngle = 0;
float offsetPix = 10;
float offsetAngleSpeed = 0.005*TWO_PI;

void settings() {
  fullScreen();
}

void setup() {
  //size( 1022,768   );
  try {
    W = new WeatherCanvas(width, height);
    Photos = new SlideShow( "/media/" );
  } catch( Exception e) {
    println( e.getMessage() );
    exit();
  }
}

void draw() {
  try {
    Photos.draw();
    image( Photos.buffer , 0 , 0 );
    W.update();
    
    offsetAngle += offsetAngleSpeed;
    image( W.buf, offsetPix*cos(offsetAngle) , offsetPix*sin(offsetAngle) );
  } catch( Exception e ) {
    println( e.getMessage() );
    exit();
  }
}



void keyPressed() {
  println(keyCode);
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
  if( keyCode == 32 ) {
    Photos.nextImageTrigger = true;
  }
  
}