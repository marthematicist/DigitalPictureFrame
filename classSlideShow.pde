class SlideShow {
  int num;              // number of images
  File[] imageFiles;    // array of image File objects
  IntList fileOrder;    // order in which files will be displayed
  LoadImage LI;
  Thread LIthread;
  int counter;
  PImage currentImage;
  PImage nextImage;
  PGraphics buffer;
  int imageDuration = 1000;
  int fadeDuration = 0;
  int lastImageStartTime;
  int maxFileSize = 500000;
  int state = 0;            // 0 = loading ; 1 = waiting ; 2 = transitioning
  int stateEndTime;
  
  
  SlideShow( String path ) {
    buffer = createGraphics( width , height );
    //imageDuration = imageDurationIn;
    //fadeDuration =  fadeDurationIn;
    ArrayList<File> allFiles = listFilesRecursive(path);
    ArrayList<File> imageList = new ArrayList<File>();
    String[] imageExtensions = { "jpg" , "png" , "gif" , "tga" , "JPG" , "PNG" , "GIF" , "TGA" } ;
    for( File f : allFiles ) {
      String fileName = f.getName();
      int ind = fileName.lastIndexOf(".");
      if( ind != -1 ) {
        String ext = fileName.substring( ind+1 , fileName.length() );
        String name = fileName.substring( 0,ind );
        for( String e : imageExtensions ) {
          if( ext.compareToIgnoreCase( e ) == 0 ) {
            imageList.add( f );
            println( fileName , name , ext );
          }
        }
      }
    }
    
    num = imageList.size();
    fileOrder = new IntList(num);
    imageFiles = new File[num];
    for( int i = 0 ; i < num ; i++ ) {
      imageFiles[i] = imageList.get(i);
      fileOrder.set( i , i );
    }
    //shuffleOrder();
    counter = 0;
    
    /*
    for( File f : imageFiles ) {
      if( f.length() > maxFileSize ) {
        println( "resizing file. Current size: " + f.length() );
        PImage pic = loadImage( f.getAbsolutePath() );
        float imageAspectRatio = float(pic.width) / float(pic.height);
        float frameAspectRatio = float(width) / float(height);
        int imageWidth = pic.width;
        int imageHeight = pic.height;
        if( imageAspectRatio > frameAspectRatio ) {
          // image is wider: set image height to frame height and
          // scale width by image aspect ratio
          imageHeight = height;
          imageWidth = round( imageHeight*imageAspectRatio );
        } else { 
          // image is taller: set image width to frame width and
          // scale height by image aspect ratio
          imageWidth = width;
          imageHeight = round( imageWidth/imageAspectRatio );
        }
        
        pic.resize( floor(1.2*imageWidth) , floor(1.2*imageHeight) );
        //pic.save( f.getAbsolutePath() );
        f = new File( f.getAbsolutePath() );
        println( "New size: " + f.length() ) ;
        println( "_______" );
      }
    }
    */
    String nextImagePath = imageFiles[fileOrder.get((counter)%num)].getAbsolutePath();
    LI = new LoadImage( nextImagePath , buffer.width , buffer.height );
    LIthread = new Thread( LI );
    LIthread.start();
    try {
      LIthread.join();
    } catch ( InterruptedException e) {
      return;
    }
    currentImage = LI.img;
    nextImagePath = imageFiles[fileOrder.get((counter+1)%num)].getAbsolutePath();
    LI = new LoadImage( nextImagePath , buffer.width , buffer.height );
    LIthread = new Thread( LI );
    LIthread.start();
    //loadImages();
  }
  
  void draw() {
    int t = millis();
    
    buffer.beginDraw();
    
    if( state == 0 ) {
      buffer.tint(255,255);
      buffer.image( currentImage , 0 , 0 );
      if( LI.done ) {
        nextImage = LI.img;
        counter++;
        counter%=num;
        String nextImagePath = imageFiles[fileOrder.get((counter+1)%num)].getAbsolutePath();
        LI = new LoadImage( nextImagePath , buffer.width , buffer.height );
        LIthread = new Thread( LI );
        LIthread.start();
        state = 1;
        stateEndTime = t + imageDuration;
      }
    }
    if( state == 1 ) {
      buffer.tint(255,255);
      buffer.image( currentImage , 0 , 0 );
      if( t > stateEndTime ) {
        state = 2;
        stateEndTime = t + fadeDuration;
      }
    }
    if( state == 2 ) {
      buffer.tint(255,255);
      buffer.image( currentImage , 0 , 0 );
      float amt = float(stateEndTime - t) / float(fadeDuration) *255.0;
      constrain(amt,0,255);
      buffer.tint(255,255-amt);
      buffer.image( nextImage , 0 , 0 );
      if( t > stateEndTime ) {
        state = 0;
        currentImage = nextImage;
      }
    }
    
    /*
    
    if( t > lastImageStartTime + imageDuration ) {
      nextImage();
    }
    int fadeStart = lastImageStartTime + fadeDuration;   
    
    buffer.tint(255,255);
    buffer.image( currentImage , 0 , 0 );
    if( t > fadeStart ) {
      int alpha = round( 255 * ( float( t - fadeStart ) / float(imageDuration-fadeDuration) ) );
      buffer.tint( 255 , alpha );
      //buffer.image( nextImage , 0 , 0 );
    }
    */
    buffer.endDraw();
    
  }
  
  void nextImage() {
    counter++;
    counter %= num;
    currentImage = nextImage;
    String nextImagePath = imageFiles[fileOrder.get((counter+1)%num)].getAbsolutePath() ; 
    nextImage = loadImage( nextImagePath );
    nextImage.resize( width , height );
    lastImageStartTime = millis();
  }
  
  void shuffleOrder() {
    fileOrder.shuffle();
  }
  
  void loadImages() {
    String currentImagePath = imageFiles[fileOrder.get(counter)].getAbsolutePath() ;
    String nextImagePath = imageFiles[fileOrder.get((counter+1)%num)].getAbsolutePath() ; 
    currentImage = loadImage( currentImagePath );
    nextImage = loadImage( nextImagePath );
    currentImage.resize( width , height );
    nextImage.resize( width , height );
    lastImageStartTime = millis();
  }
  
  // lists all file names from a directory dir
  String[] listFileNames( String dir ) {
    File file = new File(dir);
    if( file.isDirectory() ) {
      String names[] = file.list();
      return names;
    } else {
      return null;
    }
  }
  
  // returns all files in a directory as an array of File objects
  File[] listFiles( String dir ) {
    File file = new File(dir);
    if( file.isDirectory() ) {
      File[] files = file.listFiles();
      return files;
    } else {
      return null;
    }
  }
  
  // traverses subdirectories
  void recurseDir( ArrayList<File> a , String dir ) {
    File file = new File(dir);
    if( file.isDirectory() ) {
      a.add( file );
      File[] subfiles = file.listFiles();
      for( int i = 0 ; i < subfiles.length ; i++ ) {
        recurseDir( a , subfiles[i].getAbsolutePath() );
      } 
    }else {
        a.add( file );
    }
  }
  
  // gets a list of all files int a directory and all subdirectories
  ArrayList<File> listFilesRecursive( String dir ) {
    ArrayList<File> fileList = new ArrayList<File>();
    recurseDir( fileList , dir );
    return fileList;
  }
  
  class LoadImage implements Runnable {
    String imagePath;
    boolean done;
    PGraphics img;
    int w;
    int h;
    
    LoadImage( String path , int wIn , int hIn ) {
      this.imagePath = path;
      this.w = wIn;
      this.h = hIn;
      this.done = true;
      img = createGraphics(w,h);
    }
    
    void run() {
      done = false;
      PImage raw = loadImage( imagePath );
      img.beginDraw();
      img.background(0);
      float ar0 = float(w)/float(h);
      float ar1 = float(raw.width)/float(raw.height);
      float h1=0;
      float w1=0;
      if( raw.width<raw.height ) {
        h1 = h;
        w1 = h1*ar1;
        
      } else {
        if( ar0 > ar1 ) {
          h1 = h*1.1;
          w1 = h1*ar1*1.1;
        } else {
          
          w1 = w;
          h1 = w1/ar1;
        }
      }
      img.image(  raw , 0.5*w - 0.5*w1 , 0.5*h - 0.5*h1 , w1 , h1 );
      img.endDraw();
      done = true;
    }
  }
  
}