int halfWidth;        // half of screen x resolution. set in setup()
int halfHeight;       // half of screen y resulution. set in setup()
float xRes;           // screen resolution
float yRes;           // screen resolution
PGraphics pg;         // graphics buffer (clock)
int numSpokes = 12;   // number of spokes in kaleidoscope background
Clock clock;
PixelEngine PE;

// SETTINGS
float alpha = 0.03;
float masterSpeed = 1;

float fDetail = 1;
float hDetail = 1;
float sDetail = 1;
float bDetail = 1;
float fSpeed = 1;
float hSpeed = 1;
float sSpeed = 1;
float bSpeed = 1;
float fOffset = 0.0;
float hOffset = 0;
float sOffset = 0.25;
float bOffset = 0.25;
float bandOffset = 30;
float[] bandStart = { 0.20 , 0.37 , 0.47 , 0.57 , 0.70 };
float[] bandEnd   = { 0.30 , 0.43 , 0.53 , 0.63 , 0.80 };
float bw = 0.007;
float[] bandWidth = { bw , bw , bw , bw , bw };
int numBands = 5;



int backgroundR = 0;
int backgroundG = 0;
int backgroundB = 0;
int outlineR = 255;
int outlineG = 255;
int outlineB = 255;