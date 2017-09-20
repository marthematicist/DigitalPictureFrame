SlideShow Photos;

void setup() {
  size( 800 , 480 );
  
  Photos = new SlideShow( "F:\\" , 4000 );
  
}

void draw() {
  Photos.draw();
  image( Photos.buffer , 0 , 0 );
  
}