// Fork by Rupert of Toxi's flood fill code, updated to modern Java and Processing and to my taste... :-P
// Also generalized to work on any PImage
// From https://forum.processing.org/one/topic/fill-tool-and-spray-tool-in-a-drawing-program.html
// Have fun.  

FloodFill1 myFloodFill ;
//
void setup() {
  size(900, 900);
  noFill();
  strokeWeight(23);
  ellipse(190, 190, 90, 90);
  rect (390, 390, 90, 90);
  int scale = 80;

  strokeWeight(2);
  beginShape();
  vertex(random(50) + scale * 1, random(50) + scale * 1);
  vertex(random(50) + scale * 2, random(50) + scale * 1);
  vertex(random(50) + scale * 2, random(50) + scale * 2);
  vertex(random(50) + scale * 3, random(50) + scale * 2);
  vertex(random(50) + scale * 3, random(50) + scale * 3);
  vertex(random(50) + scale * 1, random(50) + scale * 3);
  endShape(CLOSE);


  scale = 100;
  strokeWeight(2);
  beginShape();
  vertex(random(50) + scale * 1, random(50) + scale * 1);
  vertex(random(50) + scale * 2, random(50) + scale * 1);
  vertex(random(50) + scale * 2, random(50) + scale * 2);
  vertex(random(50) + scale * 3, random(50) + scale * 2);
  vertex(random(50) + scale * 3, random(50) + scale * 3);
  vertex(random(50) + scale * 1, random(50) + scale * 3);
  endShape(CLOSE);


  scale = 200;
  strokeWeight(2);
  beginShape();
  vertex(random(50) + scale * 1, random(50) + scale * 1);
  vertex(random(50) + scale * 2, random(50) + scale * 1);
  vertex(random(50) + scale * 2, random(50) + scale * 2);
  vertex(random(50) + scale * 3, random(50) + scale * 2);
  vertex(random(50) + scale * 3, random(50) + scale * 3);
  vertex(random(50) + scale * 1, random(50) + scale * 3);
  endShape(CLOSE);
}


//
void draw () {
  //
  // background (117);
  //


  strokeWeight(2);
  beginShape();
  vertex(20, 20);
  vertex(40, 20);
  vertex(40, 40);
  vertex(60, 40);
  vertex(60, 60);
  vertex(20, 60);
  endShape(CLOSE);




  loadPixels();
  myFloodFill = new FloodFill1();
  if (mousePressed) {
    myFloodFill.DoFill(mouseX, mouseY, color(random(255), random(255), random(255)));
    updatePixels();
  }
}
// =====================================================================
// I create a class to share variables between the functions...
public class FloodFill1
{
  protected int iw; // Image width
  protected int ih; // Image height
  protected color[] imagePixels;
  protected color backColor; // Color found at given position
  protected color fillColor; // Color to apply
  // Stack is almost deprecated and slow (synchronized).
  // I would use Deque but that's Java 1.6, excluding current (mid-2009) Macs...
  protected ArrayList stack = new ArrayList();
  //
  public FloodFill1()
  {
    iw = width;
    ih = height;
    imagePixels = pixels; // Assume loadPixels have been done before
  }
  //
  public FloodFill1(PImage imageToProcess)
  {
    iw = imageToProcess.width;
    ih = imageToProcess.height;
    imagePixels = imageToProcess.pixels; // Assume loadPixels have been done before if sketch image
  }
  //
  public void DoFill(int startX, int startY, color fc)
  {
    // start filling
    fillColor = fc;
    backColor = imagePixels[startX + startY * iw];
    // don't run if fill color is the same as background one
    if (fillColor == backColor)
      return;
    stack.add(new PVector(startX, startY));
    while (stack.size () > 0)
    {
      PVector p = (PVector) stack.remove(stack.size() - 1);
      // Go left
      FillScanLine((int) p.x, (int) p.y, -1);
      // Go right
      FillScanLine((int) p.x + 1, (int) p.y, 1);
    }
  }
  //
  protected void FillScanLine(int x, int y, int dir)
  {
    // compute current index in pixel buffer array
    int idx = x + y * iw;
    boolean inColorRunAbove = false;
    boolean inColorRunBelow = false;
    // fill until boundary in current scanline...
    // checking neighbouring pixel rows
    while (x >= 0 && x < iw && imagePixels[idx] == backColor)
    {
      imagePixels[idx] = fillColor;
      if (y > 0) // Not on top line
      {
        if (imagePixels[idx - iw] == backColor)
        {
          if (!inColorRunAbove)
          {
            // The above pixel needs to be flooded too, we memorize the fact.
            // Only once per run of pixels of back color (hence the inColorRunAbove test)
            stack.add(new PVector(x, y-1));
            inColorRunAbove = true;
          }
        } else // End of color run (or none)
        {
          inColorRunAbove = false;
        }
      }
      if (y < ih - 1) // Not on bottom line
      {
        if (imagePixels[idx + iw] == backColor)
        {
          if (!inColorRunBelow)
          {
            // Idem with pixel below, remember to process there
            stack.add(new PVector(x, y + 1));
            inColorRunBelow = true;
          }
        } else // End of color run (or none)
        {
          inColorRunBelow = false;
        }
      }
      // Continue in given direction
      x += dir;
      idx += dir;
    } //
  } // func
} // class
// ----------------------------------------------------------
