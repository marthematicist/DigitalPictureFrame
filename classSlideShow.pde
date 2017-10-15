class SlideShow {
  int num;              // number of images
  File[] imageFiles;    // array of image File objects
  IntList fileOrder;    // order in which files will be displayed
  int counter;
  PImage currentImage;
  PImage nextImage;
  PGraphics buffer;
  int imageDuration;
  int fadeDuration;
  int lastImageStartTime;
  int maxFileSize = 500000;
  
  
  
  SlideShow( String path , int imageDurationIn ) {
    buffer = createGraphics( width , height );
    imageDuration = imageDurationIn;
    fadeDuration =  round(imageDuration*0.5);
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
    shuffleOrder();
    counter = 0;
    
    
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
    loadImages();
  }
  
  void draw() {
    int t = millis();    
    if( t > lastImageStartTime + imageDuration ) {
      nextImage();
    }
    int fadeStart = lastImageStartTime + fadeDuration;   
    buffer.beginDraw();
    buffer.tint(255,255);
    buffer.image( currentImage , 0 , 0 );
    if( t > fadeStart ) {
      int alpha = round( 255 * ( float( t - fadeStart ) / float(imageDuration-fadeDuration) ) );
      buffer.tint( 255 , alpha );
      buffer.image( nextImage , 0 , 0 );
    }
    
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
  
}