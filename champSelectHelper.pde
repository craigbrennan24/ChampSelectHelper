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
boolean showMainScreen = true;
int editNumber = -1;
String[] championLib;
Button editScreen_backButton;
Button editScreen_removeButton;
AddButton editScreen_addButton;
int championLibDisplayed = 0;
boolean editScreen_setup = false;

void setup()
{
  float wHeight = calcPercent( displayHeight, 88 );
  divSize = int(calcPercent( wHeight, 9.5));
  size( 250, int(wHeight), P2D );
  frame.setResizable(false);
  populateLib(loadData());
  populateChampLib();
  setTitle();
  msgRoll();
}

void draw()
{
  moveScreen();
  background(200);
  if( showMainScreen )
  {
    drawButtons();
    msg();
  }
  else
  {
    editScreen(editNumber);
  }
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

void populateChampLib()
{
  championLib = new String[] {
    "Aatrox", "Ahri", "Akali", "Alistar", "Amumu", "Anivia",
    "Annie", "Ashe", "Azir", "Blitzcrank", "Brand", "Braum",
    "Caitlyn", "Cassiopeia", "Cho'Gath", "Corki", "Darius",
    "Diana", "Dr. Mundo", "Draven", "Elise", "Evelynn",
    "Ezreal", "Fiddlesticks", "Fiora", "Fizz", "Galio",
    "Gangplank", "Garen", "Gnar", "Gragas", "Graves",
    "Hecarim", "Heimerdinger", "Irelia", "Janna", "Jarvan IV",
    "Jax", "Jayce", "Jinx", "Kalista", "Karma",
    "Karthus", "Kassadin", "Katarina", "Kayle", "Kennen",
    "Kha'Zix", "Kog'Maw", "Leblanc", "Lee Sin", "Leona",
    "Lissandra", "Lulu", "Lux", "Malphite", "Malzahar",
    "Maokai", "Master Yi", "Miss Fortune", "Mordekaiser",
    "Morgana", "Nami", "Nasus", "Nautilus", "Nidalee",
    "Nocturne", "Nunu", "Olaf", "Orianna", "Pantheon",
    "Poppy", "Quinn", "Rammus", "Rek'Sai", "Renekton",
    "Rengar", "Riven", "Rumble", "Ryze", "Sejuani",
    "Shaco", "Shen", "Shyvana", "Singed", "Sion",
    "Sivir", "Skarner", "Sona", "Soraka", "Swain",
    "Syndra", "Talon", "Taric", "Teemo", "Thresh",
    "Tristana", "Trundle", "Tryndamere", "Twisted Fate",
    "Twitch", "Udyr", "Urgot", "Varus", "Vayne",
    "Veigar", "Vel'Koz", "Vi", "Viktor", "Vladimir",
    "Volibear", "Warwick", "Wukong", "Xerath", "Xin Zhao",
    "Yasuo", "Yorick", "Zac", "Zed", "Ziggs",
    "Zilean", "Zyra" };
}

void editScreen( int index )
{
  if( editScreen_setup )
  {
    String editRole = lib.get(index).name;
    textSize(17);
    text( "Editing", width/2, 50 );
    line( (width/2)-60, 65, (width/2)+60, 65 );
    textSize(20);
    text( editRole, width/2, 85 );
    editScreen_addButton.draw();
    editScreen_removeButton.draw();
    editScreen_backButton.draw();
  }
  else
  {
    editScreen_backButton = new Button( width/2, height-80, 75, 40, "Back" );
    editScreen_addButton = new AddButton( width/2, (height/2)+100, 75, 40, "Add" );
    editScreen_removeButton = new Button( width/2, (height/2)-100, 75, 40, "Del" );
    editScreen_setup = true;
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

void changeChampionLibDisplayed( int up )
{
  //up = 0 | move down
  //up = 1 | move up
  if( up == 1 )
  {
    if( championLibDisplayed == championLib.length-1 )
    {
      championLibDisplayed = 0;
    }
    else
    {
      championLibDisplayed++;
    }
  }
  else
  {
    if( championLibDisplayed == 0 )
    {
      championLibDisplayed = (championLib.length-1);
    }
    else
    {
      championLibDisplayed--; 
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
  String[] all, role1, role2, role3, role4, role5, role6, role7, role8;
  role1 = data.get(0);
  role2 = data.get(1);
  role3 = data.get(2);
  role4 = data.get(3);
  role5 = data.get(4);
  role6 = data.get(5);
  role7 = data.get(6);
  role8 = data.get(7);
  
  float xPos, yPos;
  xPos = width/2;
  yPos = divSize;
  int m = 1;
  //lib.add(new Role(all, xPos, (yPos * (m++))));
  lib.add(new Role(role1, xPos, (yPos * 2)));//The number after yPos is what position the buttons will be on the screen
  lib.add(new Role(role2, xPos, (yPos * 3)));
  lib.add(new Role(role3, xPos, (yPos * 4)));
  lib.add(new Role(role4, xPos, (yPos * 5)));
  lib.add(new Role(role5, xPos, (yPos * 6)));
  lib.add(new Role(role6, xPos, (yPos * 7)));
  lib.add(new Role(role7, xPos, (yPos * 8)));
  lib.add(new Role(role8, xPos, (yPos * 9)));
  
  
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
