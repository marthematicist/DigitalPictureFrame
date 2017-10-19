SlideShow Photos;
import java.util.Calendar;
WeatherCanvas W;

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
    image( W.buf, 0, 0 );
  } catch( Exception e ) {
    println( e.getMessage() );
    exit();
  }
  println( -5%20 );
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