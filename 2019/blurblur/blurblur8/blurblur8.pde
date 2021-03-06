import toxi.math.noise.SimplexNoise;

int seed = 1;//1876;//int(random(99999999));

boolean export = false;
float timeExport = 40;

PImage text;
PShader blur;

void setup() {
  size(1920, 1080, P2D);
  frameRate(30);
  smooth(4);
  blur = loadShader("blur.glsl");
  text = loadImage("circleGrad.png");

  background(0);
}


void draw() {



  //if (frameCount%20 == 0) blur = loadShader("blur.glsl");

  float time = millis()*0.004;
  if (export) time = frameCount*1./30;

  time *= 0.03;
  if (frameCount%int(90+time*0.1) == 0) {
    generate();
  }

  randomSeed(seed);
  noiseSeed(seed);
  //filter(blur); 
  //filter(blur);  

  noStroke();

  int feed = -1;
  copy(0, 0, width, height, feed, feed, width-feed*2, height-feed*2);

  float ic = random(1000);
  //float x = width*map(cos(time*1.8), -1, 1, 0.3, 0.7);
  //float y = height*(0.5+sin(time)*0.05);

  float it = random(1000);
  float velCol = 10.1;
  fill(map(cos(time*velCol), -1, 1, 0, 255));

  float tt = ic+time*0.2;

  float grid = 40;

  int sub = 70;
  for (int i = 0; i < sub; i++) {
    float val = map(i, 0, sub, 1, 0);
    float s = max(abs(cos(time*0.71+i)*sin(time)), 0.3)*width*0.08;

    float dd = i*0.004;

    float det = random(0.1);  
    float xx = (float) (SimplexNoise.noise(1, det*i, tt)*0.5+0.5)*width;
    float yy = (float) (SimplexNoise.noise(det*i, 23, tt)*0.5+0.5)*height;

    float dx = (xx%grid)-grid*0.5;
    float dy = (yy%grid)-grid*0.5;

    float vx = abs(dx)/(grid*0.5);
    float vy = abs(dy)/(grid*0.5);

    //xx = lerp(xx, xx+dx, vx);
    //yy = lerp(yy, yy+dy, vy);

    float timeCol = 0.1;
    for (int j = 0; j < 1; j++) {
      float r = (cos(it+tt*0.98*timeCol+dd)*0.5+0.5)*255*0.8;
      float g = (cos(it+tt*0.99*timeCol+dd)*0.5+0.5)*255;
      float b = (cos(it+tt*0.10*timeCol+dd)*0.5+0.5)*255;

      float pwr = 1.1-val*0.4+j*0.005;

      boolean sprite = true;
      float ss = s*(1-val-j*0.1)*(0.2+cos(time+i)*0.2)*5;

      if (sprite) {
        imageMode(CENTER);
        tint(pow(r, pwr), pow(g, pwr), pow(b, pwr), 210);

        image(text, xx, yy, ss*2, ss*2);
        tint(255, 190);
        image(text, xx, yy, ss*0.3, ss*0.3);
      } else {
        fill(pow(r, pwr), pow(g, pwr), pow(b, pwr), 180);
        ellipse(xx, yy, ss, ss);
        fill(255, 220);
        ellipse(xx, yy, ss*0.2, ss*0.2);
      }
      noTint();
    }
  }



  float osc1 = cos(time*random(12))*2;
  float osc2 = cos(time*random(12))*2;
  float blurAmp = map(cos(time*10), -1, 1, 0.001, 0.005)*0.04;

  blur.set("time", time);
  for (int i = 0; i < 5; i++) {
    blur.set("direction", blurAmp*osc1, 0);
    filter(blur); 
    blur.set("direction", 0, blurAmp*osc2);
    filter(blur);
  }

  if (export) {
    if (timeExport < time) exit();
    else saveFrame("export/####.png");
  }
}

void keyPressed() {
  generate();
}

void generate() {
  seed = int(random(9999999));
}
