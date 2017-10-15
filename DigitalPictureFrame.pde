SlideShow Photos;
import java.util.Calendar;
WeatherCanvas W;

void setup() {
  size( 800 , 480 );
  W = new WeatherCanvas(width, height);
  Photos = new SlideShow( "F:\\" , 4000 );
  
}

void draw() {
  Photos.draw();
  image( Photos.buffer , 0 , 0 );
  W.update();
  image( W.buf, 0, 0 );
  
}