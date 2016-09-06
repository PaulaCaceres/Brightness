import processing.video.*;
Capture video;

void setup() {
  size(640, 480);

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    video = new Capture(this, 1280, 720);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    video = new Capture(this, cameras[0]);  
    video.start();
  }
}

  void captureEvent(Capture video) {
    video.read();
  }

void draw() {
  image(video, 0, 0, width, height);
  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++ ) {
      // Calculate the 1D location from a 2D grid
      int loc = x + y*video.width;
      // Get the R,G,B values from image
      float r,g,b;
      r = red (video.pixels[loc]);
      g = green (video.pixels[loc]);
      b = blue (video.pixels[loc]);
      
      // Calculate an amount to change brightness based on proximity to the mouse
      float maxdist = 50;//dist(0,0,width,height);
      float d = dist(x, y, mouseX, mouseY);
      float adjustbrightness = 255*(maxdist-d)/maxdist;
      r += adjustbrightness;
      g += adjustbrightness;
      b += adjustbrightness;
    
      // Constrain RGB to make sure they are within 0-255 color range
      r = constrain(r, 0, 255);
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);
    
      // Make a new color and set pixel in the window
      
      color c = color(r, g, b);
      video.pixels[y*width + x] = c;
    }
  }
  updatePixels();
}
 