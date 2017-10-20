class Randomizer implements Runnable {
  int numRenderedPixels;
  float[] fld;                 // random values
  float[] hue;
  float[] sat;
  float[] bri;
  float tf = 0;                // time variables
  float th = 0;
  float ts = 0;
  float tb = 0;
  RenderedPixel[] RenderedPixels;
  int counter;
  float progress;
  boolean doneWithBatch = true;
  
  Randomizer( ArrayList<RenderedPixel> RPin ) {
    this.numRenderedPixels = RPin.size();
    this.fld = new float[numRenderedPixels];
    this.hue = new float[numRenderedPixels];
    this.sat = new float[numRenderedPixels];
    this.bri = new float[numRenderedPixels];
    this.RenderedPixels = new RenderedPixel[numRenderedPixels];
    for( int i = 0 ; i < numRenderedPixels ; i++ ) {
      fld[i] = 0.5;
      hue[i] = 180;
      sat[i] = 0.5;
      bri[i] = 0.5;
      RenderedPixels[i] = RPin.get(i).copy();
    }
    counter = 0;
    progress = 0;
    doneWithBatch = true;
  }
  
  void run() {
    if( doneWithBatch ) {
      doneWithBatch = false;
      progress = 0;
      counter = 0;
      for( int i = 0 ; i < numRenderedPixels ; i++ ) {
        RenderedPixels[i].setRandomLocationValues();
      }
    }
    while( !doneWithBatch ) {
      // crunch
      float xFld = RenderedPixels[counter].xFld;
      float xHue = RenderedPixels[counter].xHue;
      float xSat = RenderedPixels[counter].xSat;
      float xBri = RenderedPixels[counter].xBri;
      float yFld = RenderedPixels[counter].yFld;
      float yHue = RenderedPixels[counter].yHue;
      float ySat = RenderedPixels[counter].ySat;
      float yBri = RenderedPixels[counter].yBri;
      fld[counter] = constrain( noise( xFld , yFld , tf ) + fOffset , 0 , 1 );
      hue[counter] = (noise( xHue , yHue , th )*2000 + hOffset)%360;
      sat[counter] = constrain( noise( xSat , ySat , ts ) + sOffset , 0 , 1 );
      bri[counter] = constrain( noise( xBri , yBri , tb ) + bOffset , 0 , 1 );
      // cleanup
      counter++;
      progress = float(counter) / float(numRenderedPixels);
      if( counter >= numRenderedPixels ) {
        counter = 0;
        tf += fSpeed*masterSpeed*0.010;
        th += hSpeed*masterSpeed*0.005;
        ts += sSpeed*masterSpeed*0.05;
        tb += bSpeed*masterSpeed*0.05;
        progress = 0;
        doneWithBatch = true;
      }
      if( Thread.interrupted() ) {
        return;
      }
    }
    return;
  }
}

float lerp360( float a1 , float a2 , float amt ) {
  float output = 0;
  if( a2 > a1 ) {
    if( a2 - a1 <= 180 ) {
      output = lerp( a1 , a2 , amt );
    } else {
      output = lerp( a1 + 360 , a2 , amt ) % 360;
    }
  } else {
    if( a1 - a2 <= 180 ) {
      output = lerp( a1 , a2 , amt );
    } else {
      output = lerp( a1 , a2 + 360 , amt ) % 360;
    }
  }
  return output;
}