//Created by Craig Brennan - Aug/Sept 2014
/****
 *champSelectHelper is a tool that helps players
 *access their familiar champion pool in League of Legends
 *using the client's champion select search features
 ****/
 
import java.awt.datatransfer.*;
import java.awt.Toolkit;

ArrayList<Role> lib = new ArrayList<Role>();
int divSize;
String stringSplit[] = new String[] { "^", "$|^", "$" };
boolean finishMoveScreen = false;
int finishMoveScreen_flag = 0;
boolean showMsg = false;

void setup()
{
  float wHeight = calcPercent( displayHeight, 88 );
  divSize = int(calcPercent( wHeight, 9.5));
  size( 250, int(wHeight) );
  frame.setResizable(false);
  populateLib(loadData());
  setTitle();
  msgRoll();
}

void draw()
{
  moveScreen();
  background(200);
  drawButtons();
  msg();
}

void moveScreen()
{
  if( !finishMoveScreen )
  {
    frame.setLocation( int(( displayWidth - width ) - (calcPercent(displayWidth, 1.3 ))), int(calcPercent(displayHeight, 1.3)) );
    if( finishMoveScreen_flag++ > 4 )
    {
      finishMoveScreen = true;
    }
  }
}

void setTitle()
{
  int i = int(random(0, 10));
  if( i <= 4 )
  {
    frame.setTitle("(~˘▾˘)~");
  }
  else
  {
    frame.setTitle("~(˘▾˘~)");
  }
}

void msgRoll()
{
  int i = int(random(0, 15));
  int chance = 1;
  if( i == chance )
  {
    showMsg = true;
  }
}

void msg()
{
  if( showMsg )
  {
    textSize(15);
    text("It's all ogre now", width/2, 20 );
  }
}

float calcPercent( float x, float y )
{
  float perc = 0;
  perc = x/100;
  perc *= y;
  return perc;
}

void drawButtons()
{
  for( int i = 0; i < lib.size(); i++ )
  {
    Role temp = lib.get(i);
    temp.draw();
  }
}

void copyToClipboard( Role role )
{
  role.copied = true;
  role.copied_timer = millis();
  String searchString = setupSearchString( role );
  StringSelection stringSelect = new StringSelection (searchString);
  Clipboard clpbrd = Toolkit.getDefaultToolkit().getSystemClipboard();
  clpbrd.setContents(stringSelect, null);
}

void mousePressed()
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

String setupSearchString( Role role )
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

void populateLib(ArrayList<String[]> data)
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

ArrayList<String[]> loadData()
{
  ArrayList<String[]> ret = new ArrayList<String[]>();
  String[] s = loadStrings("data.txt");
  
  for( int i = 0; i < s.length; i++ )
  {
    if( !s[i].contains("#") )//Ignore the warning message in data.txt
    {
      String[] t = split(s[i], ",");
      for( int j = 0; j < t.length; j++ )
      {
        t[j] = t[j].replaceAll("\"", "");
      }
      ret.add(t);
    }
  }
  
  return ret;
}
