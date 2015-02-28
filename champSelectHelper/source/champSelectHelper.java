import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.datatransfer.*; 
import java.awt.Toolkit; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class champSelectHelper extends PApplet {

//Created by Craig Brennan - Aug/Sept 2014
/****
 *champSelectHelper is a tool that helps players
 *access their familiar champion pool in League of Legends
 *using the client's champion select search features
 ****/
 



ArrayList<Role> lib = new ArrayList<Role>();
int divSize;
String stringSplit[] = new String[] { "^", "$|^", "$" };
boolean finishMoveScreen = false;
int finishMoveScreen_flag = 0;
boolean showMsg = false;

public void setup()
{
  float wHeight = calcPercent( displayHeight, 88 );
  divSize = PApplet.parseInt(calcPercent( wHeight, 9.5f));
  size( 250, PApplet.parseInt(wHeight) );
  frame.setResizable(false);
  populateLib(loadData());
  setTitle();
  msgRoll();
}

public void draw()
{
  moveScreen();
  background(200);
  drawButtons();
  msg();
}

public void moveScreen()
{
  if( !finishMoveScreen )
  {
    frame.setLocation( PApplet.parseInt(( displayWidth - width ) - (calcPercent(displayWidth, 1.3f ))), PApplet.parseInt(calcPercent(displayHeight, 1.3f)) );
    if( finishMoveScreen_flag++ > 4 )
    {
      finishMoveScreen = true;
    }
  }
}

public void setTitle()
{
  int i = PApplet.parseInt(random(0, 10));
  if( i <= 4 )
  {
    frame.setTitle("(~\u02d8\u25be\u02d8)~");
  }
  else
  {
    frame.setTitle("~(\u02d8\u25be\u02d8~)");
  }
}

public void msgRoll()
{
  int i = PApplet.parseInt(random(0, 15));
  int chance = 1;
  if( i == chance )
  {
    showMsg = true;
  }
}

public void msg()
{
  if( showMsg )
  {
    textSize(15);
    text("It's all ogre now", width/2, 20 );
  }
}

public float calcPercent( float x, float y )
{
  float perc = 0;
  perc = x/100;
  perc *= y;
  return perc;
}

public void drawButtons()
{
  for( int i = 0; i < lib.size(); i++ )
  {
    Role temp = lib.get(i);
    temp.draw();
  }
}

public void copyToClipboard( Role role )
{
  role.copied = true;
  role.copied_timer = millis();
  String searchString = setupSearchString( role );
  StringSelection stringSelect = new StringSelection (searchString);
  Clipboard clpbrd = Toolkit.getDefaultToolkit().getSystemClipboard();
  clpbrd.setContents(stringSelect, null);
}

public void mousePressed()
{
  for( int i = 0; i < lib.size(); i++ )
  {
    Role temp = lib.get(i);
    if( temp.buttonHover() )
    {
      copyToClipboard(temp);
      break;
    }
  }
}

public String setupSearchString( Role role )
{
  String champSelectSearch = stringSplit[0];
  champSelectSearch += "Random$|^";
  for( int i = 0; i < role.champions.size(); i++ )
  {
    champSelectSearch += role.champions.get(i);
    if( i != (role.champions.size()-1) )
    {
      champSelectSearch += stringSplit[1];
    }
    else
    {
      champSelectSearch += stringSplit[2];
    }
  }
  return champSelectSearch;
}

public void populateLib(ArrayList<String[]> data)
{
  String[] all, topAD, topAP, midAD, midAP, adc, supp, jungAP, jungAD;
  /*topAD = new String[] { "TopAD", "Jayce", "Renekton", "Riven", "Jax", "Rengar", "Master Yi", "Aatrox", "Irelia" };
  topAP = new String[] { "TopAP", "Ryze", "Lissandra", "Rumble", "Vladimir" };
  midAD = new String[] { "MidAD", "Yasuo", "Zed", "Riven" };
  midAP = new String[] { "MidAP", "Ahri", "Orianna", "Lissandra", "Leblanc", "Syndra", "Lux", "Fizz" };
  adc = new String[] { "ADC", "Twitch", "Graves", "Vayne", "Lucian", "Sivir", "Kalista" };
  supp = new String[] { "Supp", "Thresh", "Braum", "Nami", "Janna", "Blitzcrank" };
  jungAP = new String[] { "JungAP", "Elise", "Udyr", "Volibear" };
  jungAD = new String[] { "JungAD", "Lee Sin", "Kha'zix", "Jarvan IV", "Nocturne", "Udyr", "Vi", "Wukong", "Rengar" };
  */
  topAD = data.get(0);
  topAP = data.get(1);
  midAD = data.get(2);
  midAP = data.get(3);
  adc = data.get(4);
  supp = data.get(5);
  jungAD = data.get(6);
  jungAP = data.get(7);
  
  float xPos, yPos;
  xPos = width/2;
  yPos = divSize;
  int m = 1;
  //lib.add(new Role(all, xPos, (yPos * (m++))));
  lib.add(new Role(topAD, xPos, (yPos * 2)));//The number after yPos is what position the buttons will be on the screen
  lib.add(new Role(topAP, xPos, (yPos * 3)));
  lib.add(new Role(midAD, xPos, (yPos * 4)));
  lib.add(new Role(midAP, xPos, (yPos * 5)));
  lib.add(new Role(adc, xPos, (yPos * 6)));
  lib.add(new Role(supp, xPos, (yPos * 7)));
  lib.add(new Role(jungAD, xPos, (yPos * 8)));
  lib.add(new Role(jungAP, xPos, (yPos * 9)));
  
  
  ArrayList<String> allTemp = new ArrayList<String>();
  for( Role r : lib )
  {
    for( int i = 0; i < r.champions.size(); i++ )
    {
      String next = r.champions.get(i);
      if( !allTemp.contains(next) )
      {
        allTemp.add(next);
      }
    }
  }
  all = new String[allTemp.size()+1];
  all[0] = "All";
  for( int i = 0; i < allTemp.size(); i++ )
  {
    all[i+1] = allTemp.get(i);
  }
  lib.add( new Role(all, xPos, yPos));
}

public ArrayList<String[]> loadData()
{
  ArrayList<String[]> ret = new ArrayList<String[]>();
  String[] s = loadStrings("data.txt");
  
  for( int i = 0; i < s.length; i++ )
  {
    String[] t = split(s[i], ",");
    for( int j = 0; j < t.length; j++ )
    {
      t[j] = t[j].replaceAll("\"", "");
    }
    ret.add(t);
  }
  
  return ret;
}
class Role
{
  String name;
  ArrayList<String> champions;
  float xPos, yPos;
  float hitboxX, hitboxY;
  int button, buttonMouseOver;
  boolean copied;
  float copied_timer;
  
  Role( String[] array, float x, float y )
  {
    champions = new ArrayList<String>();
    button = color( 140 );
    buttonMouseOver = color( 160 );
    copied = false;
    copied_timer = 0;
    xPos = x;
    yPos = y;
    hitboxX = 100;
    hitboxY = 60;
    name = array[0];
    for( int i = 1; i < array.length; i++ )
    {
      addChamp(array[i]);
    }
  }
  
  public void draw()
  {
    textSize(20);
    if( !buttonHover())
    {
      fill(button);
    }
    else
    {
      fill(buttonMouseOver);
    }
    rectMode(CENTER);
    rect( xPos, yPos, hitboxX, hitboxY);
    textAlign(CENTER, CENTER);
    fill(0);
    text( name, xPos, yPos );
    if( copied )
    {
      confirmCopied();
    }
  }
  
  public void confirmCopied()
  {
    fill(0);
    textSize(15);
    text( "Copied!", (( xPos + (hitboxX/2) ) + 35), yPos);
    if( millis() - copied_timer >= 500 )
    {
      copied = false;
      copied_timer = 0;
    }
  }
  
  public boolean contains( String champion )
  {
    boolean ret = false;
    for( String s : champions )
    {
      if( champion == s )
        ret = true;
    }
    return ret;
  }
  
  public boolean buttonHover()
  {
    float x = mouseX;
    float y = mouseY;
    float buttonRight, buttonLeft, buttonTop, buttonBot;
    buttonRight = xPos + (hitboxX/2);
    buttonLeft = buttonRight - hitboxX;
    buttonTop = yPos - (hitboxY/2);
    buttonBot = buttonTop + hitboxY;
    boolean over = false;
    if( x <= buttonRight && x >= buttonLeft )
    {
      if( y <= buttonBot && y >= buttonTop )
      {
        over = true;
      }
    }
    return over;
  }
  
  public void addChamp( String champion )
  {
    if( !champions.contains(champion) )
    {
      champions.add(champion);
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "champSelectHelper" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
