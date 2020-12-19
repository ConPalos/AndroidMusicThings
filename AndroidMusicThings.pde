/*
sources for letter and sound distribution:
 https://upload.wikimedia.org/wikipedia/commons/thumb/b/b0/English_letter_frequency_%28frequency%29.svg/380px-English_letter_frequency_%28frequency%29.svg.png
 https://spotifyinsights.files.wordpress.com/2015/05/keys.png
 */

import processing.sound.*;

PFont font;

SinOsc sine, sine2, sine3, sine4, sine5, sine6, sine7, sine8, sine9, sine10, sine11, sine12, bassTone, bassTone2;
Env env, env2, env3, env4, env5, env6, env7, env8, env9, env10, env11, env12, bassEnv, bassEnv2;

//Global Variables
float a = 440.00;
float aSharp = 466.16;
float b = 493.88;
float c = 523.25;
float cSharp = 554.37;
float d = 587.33;
float dSharp = 622.25;
float e = 659.25;
float f = 698.46;
float fSharp = 739.99;
float g = 783.99;
float gSharp = 830.61;
float a2 = 880.00;

float attackTime = 0.001;
float sustainTime = 0.004;
float sustainBass = 0.01;
float sustainLevel = 0.3;
float releaseTime = 0.19;
float frequency = 0;
float amp;
float attackOrig, sustainOrig, releaseOrig;

float[] aMajor = {a, b, cSharp, d, e, fSharp, gSharp, a2};
float[] aMinor = {a, b, c, d, e, f, g, a2};
float[] aSharpMajor = {aSharp, c, d, dSharp, f, g, a2, 2*aSharp};
float[] aSharpMinor = {aSharp, c, cSharp, dSharp, f, fSharp, gSharp, 2*aSharp};
float[] bMajor = {b, cSharp, dSharp, e, fSharp, gSharp, 2*aSharp, 2*b};
float[] bMinor = {b, cSharp, d, e, fSharp, g, a2, 2*b};
float[] cMajor = {c, d, e, f, g, a2, 2*b, 2*c};
float[] cMinor = {c, d, dSharp, f, g, gSharp, 2*aSharp, 2*c};
float[] cSharpMajor = {cSharp, dSharp, f, fSharp, gSharp, 2*aSharp, 2*c, 2*cSharp};
float[] cSharpMinor = {cSharp, dSharp, e, fSharp, gSharp, a2, 2*b, 2*cSharp};
float[] dMajor = {d, e, fSharp, g, a2, 2*b, 2*cSharp, 2*d};
float[] dMinor = {d, e, f, g, a2, 2*aSharp, 2*c, 2*d};
float[] dSharpMajor = {dSharp, f, g, gSharp, 2*aSharp, 2*c, 2*d, 2*dSharp};
float[] dSharpMinor = {dSharp, f, fSharp, gSharp, 2*aSharp, 2*b, 2*cSharp, 2*dSharp};
float[] eMajor = {e, fSharp, gSharp, a2, 2*b, 2*cSharp, 2*dSharp, 2*e};
float[] eMinor = {e, fSharp, g, a2, 2*b, 2*c, 2*d, 2*e};
float[] fMajor = {f, g, a2, 2*aSharp, 2*c, 2*d, 2*e, 2*f};
float[] fMinor = {f, g, gSharp, 2*aSharp, 2*c, 2*cSharp, 2*dSharp, 2*f};
float[] fSharpMajor = {fSharp, gSharp, 2*aSharp, 2*b, 2*cSharp, 2*dSharp, 2*f, 2*fSharp};
float[] fSharpMinor = {fSharp, gSharp, a2, 2*b, 2*cSharp, 2*d, 2*e, 2*fSharp};
float[] gMajor = {g, a2, 2*b, 2*c, 2*d, 2*e, 2*fSharp, 2*g};
float[] gMinor = {g, a2, 2*aSharp, 2*c, 2*d, 2*dSharp, 2*f, 2*g};
float[] gSharpMajor = {gSharp, 2*aSharp, 2*c, 2*cSharp, 2*dSharp, 2*f, 2*g, 2*gSharp};
float[] gSharpMinor = {gSharp, 2*aSharp, 2*b, 2*cSharp, 2*dSharp, 2*e, 2*fSharp, 2*gSharp};

float[] temp = cMajor;

char note = 'a';
int questionableNote = 0;

String[] lines;
char[]letters;

String wholeLine = "";
String BEE = "";

int capitalCheck;
int i = 0;
int h = 1;
int arthi = 0;
int exclamatory = 10;

int periodCount = 0;
int commaCount = 0;
int bassCount = 0;

int fps = 6;

boolean bee = false;
boolean click = true;

void setup() 
{
  //fullScreen();
  sine = new SinOsc(this);
  sine2 = new SinOsc(this);
  sine3 = new SinOsc(this);
  sine4 = new SinOsc(this);
  sine5 = new SinOsc(this);
  sine6 = new SinOsc(this);
  sine7 = new SinOsc(this);
  sine8 = new SinOsc(this);
  sine9 = new SinOsc(this);
  sine10 = new SinOsc(this);
  sine11 = new SinOsc(this);
  sine12 = new SinOsc(this);
  bassTone = new SinOsc(this);
  bassTone2 = new SinOsc(this);
  env = new Env(this);
  env2 = new Env(this);
  env3 = new Env(this);
  env4 = new Env(this);
  env5 = new Env(this);
  env6 = new Env(this);
  env7 = new Env(this);
  env8 = new Env(this);
  env9 = new Env(this);
  env10 = new Env(this);
  env11 = new Env(this);
  env12 = new Env(this);
  bassEnv = new Env(this);
  bassEnv2 = new Env(this);
  font = createFont("Arial Bold", 30);
  lines = loadStrings("lmao.txt");

  // store original times
  attackOrig = attackTime;
  sustainOrig = sustainTime;
  releaseOrig = releaseTime;

  //if (lines.length > 0) {
  for (int i = 0; i <lines.length; i++)
  {
    wholeLine += lines[i] + "\n"; // just append this line to the String holding all lines
  }
  //} else if (lines.length == 0) {
  //  if (keyPressed) {
  //    if (key == CODED) {
  //      if (key == BACKSPACE) {
  // wholeLine = wholeLine.substring(0, wholeLine.length());
  //      }
  //    } else {
  //      wholeLine += key;
  //    }
  //  }
  //}
  cursor(TEXT);
}

void draw()
{
  frameRate(fps);
  background(#648B66);

  letters = wholeLine.toCharArray();  // i think this is it

  amp = 0.8;

  attackTime = attackOrig;
  sustainTime = sustainOrig;
  releaseTime = releaseOrig;
  sustainBass = 0.024;

  if (i == letters.length) {
    i = 0;
  }

  //if (i%2 == 0)
  //{
  //  frameRate++;
  //}

  //if(((note == 'b' || note == 'B') && bee == false) || ((note == 'e' || note == 'E') && bee == true))
  //{
  //  BEE += note;
  //}
  //else if(BEE == "BEE" || BEE == "Bee" || BEE == "bee" || BEE == "bEE" || BEE == "bEe" || BEE == "beE" || BEE == "BEe" || BEE == "BeE") {
  //  frameRate(frameRate*2);
  //}
  //else {
  //  bee = false;
  //}

  if (wholeLine.length() != 0) {
    note = letters[i];
    print(letters[i]);
    i++;
    switch(note) {
    case 'A':
      temp = dMajor;
      frequency = temp[0];
      break;
    case 'B':
      temp = fSharpMinor;
      frequency = temp[0];
      break;
    case 'C':
      temp = eMajor;
      frequency = temp[0];
      break;
    case 'D':
      temp = eMinor;
      frequency = temp[0];
      break;
    case 'E':
      temp = gMajor;
      frequency = temp[0];
      break;
    case 'F':
      temp = fSharpMajor;
      frequency = temp[0];
      break;
    case 'G':
      temp = bMajor;
      frequency = temp[0];
      break;
    case 'H':
      temp = cMinor;
      frequency = temp[0];
      break;
    case 'I':
      temp = cSharpMajor;
      frequency = temp[0];
      break;
    case 'J':
      temp = cSharpMinor;
      frequency = temp[0];
      break;
    case 'K':
      temp = cMinor;
      frequency = temp[0];
      break;
    case 'L':
      temp = bMinor;
      frequency = temp[0];
      break;
    case 'M':
      temp = aSharpMinor;
      frequency = temp[0];
      break;
    case 'N':
      temp = fMajor;
      frequency = temp[0];
      break;
    case 'O':
      temp = aMajor;
      frequency = temp[0];
      break;
    case 'P':
      temp = dMinor;
      frequency = temp[0];
      break;
    case 'Q':
      temp = dSharpMinor;
      frequency = temp[0];
      break;
    case 'R':
      temp = gSharpMajor;
      frequency = temp[0];
      break;
    case 'S':
      temp = aMinor;
      frequency = temp[0];
      break;
    case 'T':
      temp = cMajor;
      frequency = temp[0];
      break;
    case 'U':
      temp = aSharpMajor;
      frequency = temp[0];
      break;
    case 'V':
      temp = dSharpMajor;
      frequency = temp[0];
      break;
    case 'W':
      temp = fMinor;
      frequency = temp[0];
      break;
    case 'X':
      temp = gSharpMinor;
      frequency = temp[0];
      break;
    case 'Y':
      temp = gMinor;
      frequency = temp[0];
      break;
    case 'Z':
      temp = cMajor;
      frequency = temp[0];
      break;
    case '.':
      frameRate(fps/4.0);
      //if (periodCount % 2 == 0) {
      //  for (int i = 0; i < 8; i++) {
      //    temp[i] = temp[i]*2;
      //  }
      //} else if (periodCount % 2 != 0) {
      //  for (int i = 0; i < 8; i++) {
      //    temp[i] = temp[i]/2;
      //  }
      //} else {
      //}
      //periodCount++;
      break;
    case ',':
      //if (commaCount % 2 == 0) {
      //    for (int i = 0; i < 8; i++) {
      //      temp[i] = temp[i]/2;
      //    }
      //  } else if (commaCount % 2 != 0) {
      //    for (int i = 0; i < 8; i++) {
      //      temp[i] = temp[i]*2;
      //    }
      //  } else {
      //  }
      //  commaCount++;
      frameRate(fps/2.0);
      break;
    case';':
      frameRate(fps*0.75);
      break;
    case '?':
      questionableNote = int(note);
      questionableNote = questionableNote*2;
      note = char(questionableNote);
      break;
    case '!':
      amp = 1;
      exclamatory = 0;
      break;
    case '(':
      amp = 0.6;
      break;
    case ')':
      amp = 0.6;
      break;
    case '-':
      frameRate(4);
      break;
    case '/':
      amp = 0;
      break;
    case '$':
      specialNote();
      break;
    case '#':
      specialNote();
      break;
    case '&':
      specialNote();
      break;
    case 'a':
      frequency = temp[3];
      break;
    case 'b':
      frequency = temp[6];
      break;
    case 'c':
      frequency = temp[5];
      break;
    case 'd':
      frequency = temp[2];
      break;
    case 'e':
      frequency = temp[0];
      break;
    case 'f':
      frequency = temp[1];
      break;
    case 'g':
      frequency = temp[5];
      break;
    case 'h':
      frequency = temp[4];
      break;
    case 'i':
      frequency = temp[7];
      break;
    case 'j':
      frequency = temp[6];
      break;
    case 'k':
      frequency = temp[6];
      break;
    case 'l':
      frequency = temp[2];
      break;
    case 'm':
      frequency = temp[1];
      break;
    case 'n':
      frequency = temp[7];
      break;
    case 'o':
      frequency = temp[3];
      break;
    case 'p':
      frequency = temp[5];
      break;
    case 'q':
      frequency = temp[6];
      break;
    case 'r':
      frequency = temp[3];
      break;
    case 's':
      frequency = temp[0];
      break;
    case 't':
      frequency = temp[4];
      break;
    case 'u':
      frequency = temp[1];
      break;
    case 'v':
      frequency = temp[6];
      break;
    case 'w':
      frequency = temp[5];
      break;
    case 'x':
      frequency = temp[6];
      break;
    case 'y':
      frequency = temp[1];
      break;
    case 'z':
      frequency = temp[6];
      break;
    default:
    }
    //frequency = frequency/2;
    playNote(frequency, amp);

    if (frameCount % 2 == 0) {
      playBass(temp[0], amp/4);
    }

    textFont(font);
    fill(0);
    text(wholeLine, width/15, height/6, width - (2 * width)/15, height - (2 * height)/8);
    if (note != '\n') {
      text("Letter: " + note + "\nFrequency: " + frequency + "\nSpeed: " + fps, 5, 30);
    } else {
      text("Letter:  \nFrequency: " + frequency + "\nSpeed: " + fps, 5, 30);
    }
  } else {
  }

  exclamatory++;

  if (frameCount % 2 == 0) {
    bassCount++;
  } else {
  }
  //sustainBass += 1.0/frameRate;
}
//playNote(temp[h]);

//h++;

//if (h >= temp.length) {
//  h = 0;
//}
//}

void playNote(float note, float volume)
{ 
  if (exclamatory < 10) {
    amp = 1;
  }
  if (frameCount % 12 == 0) {
    sine.play(note, volume);
    env.play(sine, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (frameCount % 12 == 1) {
    sine3.play(note, volume);
    env3.play(sine3, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (frameCount % 12 == 2) {
    sine4.play(note, volume);
    env4.play(sine4, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (frameCount % 12 == 3) {
    sine5.play(note, volume);
    env5.play(sine5, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (frameCount % 12 == 4) {
    sine6.play(note, volume);
    env6.play(sine6, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (frameCount % 12 == 5) {
    sine7.play(note, volume);
    env7.play(sine7, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (frameCount % 12 == 6) {
    sine8.play(note, volume);
    env8.play(sine8, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (frameCount % 12 == 7) {
    sine9.play(note, volume);
    env9.play(sine9, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (frameCount % 12 == 8) {
    sine10.play(note, volume);
    env10.play(sine10, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (frameCount % 12 == 9) {
    sine11.play(note, volume);
    env11.play(sine11, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (frameCount % 12 == 10) {
    sine12.play(note, volume);
    env12.play(sine12, attackTime, sustainTime, sustainLevel, releaseTime);
  } else {
    sine2.play(note, volume);
    env2.play(sine2, attackTime, sustainTime, sustainLevel, releaseTime);
  }
}

void playBass(float note, float volume) {
  if (frameCount % 2 == 0) {
    bassTone.play(note/2, volume);
    bassEnv.play(bassTone, attackTime, sustainBass, sustainLevel, releaseTime);
  } else if (frameCount % 2 == 1) {
    bassTone2.play(note/2, volume);
    bassEnv2.play(bassTone, attackTime, sustainBass, sustainLevel, releaseTime);
  }
}

void specialNote() {
  attackTime = attackTime*0.5; // 1/5th as long as original
  sustainTime = sustainTime*0.5;
  releaseTime = releaseTime*0.5;

  println( attackTime + "," + sustainTime + "," + releaseTime );
  for (int i = 0; i < 8; i++) {
    playNote(temp[i], amp);

    delay(60);
    frameCount++;
  }
}

void keyPressed() {
  if (key == BACKSPACE || key == DELETE) {
    wholeLine = wholeLine.substring(0, wholeLine.length() - 1);
    if(i >= letters.length) {
      i = 0;
    }
  }
  else if (key == SHIFT) {
    wholeLine += "";
  }
  else {
    wholeLine += key;
  }
}

void mousePressed() {
  if (click == true) {
    fps = 10;
    click = false;
  } else if (click == false) {
    fps = 6;
    click = true;
  }
}
