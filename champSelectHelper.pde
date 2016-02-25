//Created by Craig Brennan - Aug/Sept 2014
/****
 *champSelectHelper is a tool that helps players
 *access their familiar champion pool in League of Legends
 *using the client's champion select search features
 ****/
 
import java.awt.datatransfer.*;
import java.awt.Toolkit;
import java.io.File;

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
DelButton editScreen_delButton;
AddButton editScreen_addButton;
Button helpButton;
int championLibDisplayed = 0;
boolean editScreen_setup = false;
boolean mainScreen_setup = false;
boolean dataFileFound = true;
int errorCode = 0;
float wHeight = 1080;

void settings()
{
  wHeight = calcPercent( displayHeight, 88 );
  size( 250, int(wHeight), P2D);
}

void setup()
{
  divSize = int(calcPercent( wHeight, 9.5));
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
    if( mainScreen_setup )
    {
      drawButtons();
      msg();
      if( !dataFileFound )
      {
        errorMsg();
      }
    }
    else
    {
      helpButton = new Button( (width-25), 25, 30, 30, "?" );
      mainScreen_setup = true;
    }
  }
  else
  {
    editScreen(editNumber);
  }
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
    editScreen_delButton.draw();
    editScreen_backButton.draw();
  }
  else
  {
    editScreen_backButton = new Button( width/2, height-80, 75, 40, "Back" );
    editScreen_addButton = new AddButton( width/2, (height/2)+100, 75, 40, "Add" );
    editScreen_delButton = new DelButton( width/2, (height/2)-100, 75, 40, "Del" );
    editScreen_setup = true;
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

void drawButtons()
{
  for( int i = 0; i < lib.size(); i++ )
  {
    Role temp = lib.get(i);
    temp.draw();
  }
  helpButton.draw();
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
  //Currently not being used but I don't want to delete incase it might be useful
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

void errorMsg()
{
  fill(color(255,0,0));
  textSize(15);
  text( "Error" + str(errorCode) + ": unable to locate data file", width/2, height-40);
}