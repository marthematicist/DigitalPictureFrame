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
    Photos = new SlideShow( "F:\\" , 4000 );
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
}