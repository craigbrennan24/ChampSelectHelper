import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.datatransfer.*; 
import java.awt.Toolkit; 
import java.io.File; 

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
boolean showMainScreen = true;
int editNumber = -1;
String[] championLib;
Button editScreen_backButton;
DelButton editScreen_delButton;
AddButton editScreen_addButton;
int championLibDisplayed = 0;
boolean editScreen_setup = false;
boolean dataFileFound = true;

public void setup()
{
  float wHeight = calcPercent( displayHeight, 88 );
  divSize = PApplet.parseInt(calcPercent( wHeight, 9.5f));
  size( 250, PApplet.parseInt(wHeight), P2D );
  frame.setResizable(false);
  populateLib(loadData());
  populateChampLib();
  setTitle();
  msgRoll();
}

public void draw()
{
  moveScreen();
  background(200);
  if( showMainScreen )
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
    editScreen(editNumber);
  }
}

public void editScreen( int index )
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

public void msg()
{
  if( showMsg )
  {
    textSize(15);
    text("It's all ogre now", width/2, 20 );
  }
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

public void changeChampionLibDisplayed( int up )
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

public void errorMsg()
{
  fill(color(255,0,0));
  textSize(15);
  text( "Error: unable to locate data file", width/2, height-40);
}
class Button
{
  String buttonText;
  float xPos, yPos;
  float hitboxX, hitboxY;
  int baseColor, hoverColor;
  
  Button(float xPos, float yPos, float hitboxX, float hitboxY)
  {
    buttonText = "";
    this.xPos = xPos;
    this.yPos = yPos;
    this.hitboxX = hitboxX;
    this.hitboxY = hitboxY;
    baseColor = color(140);
    hoverColor = color(160);
  }
  
  Button(float xPos, float yPos, float hitboxX, float hitboxY, int baseColor, int hoverColor)
  {
    this(xPos,yPos,hitboxX,hitboxY);
    this.baseColor = baseColor;
    this.hoverColor = hoverColor;
  }
  
  Button(float xPos, float yPos, float hitboxX, float hitboxY, String name )
  {
    this(xPos,yPos,hitboxX,hitboxY);
    buttonText = name;
  }
  
  Button(float xPos, float yPos, float hitboxX, float hitboxY, int baseColor, int hoverColor, String name)
  {
    this(xPos,yPos,hitboxX,hitboxY,baseColor,hoverColor);
    buttonText = name;
  }
  
  public void draw()
  {
    if( hovered())
    {
      fill(baseColor);
    }
    else
    {
      fill(hoverColor);
    }
    rectMode(CENTER);
    rect( xPos, yPos, hitboxX, hitboxY);
    if( buttonText != "" )
    {
      textSize(20);
      textAlign(CENTER, CENTER);
      fill(0);
      text( buttonText, xPos, yPos );
    }
  }

  
  public boolean hovered()
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
  
  public String createOutputString( int currentDisplay, boolean add )
  {
    //make delete = true to create output string that skips the currently selected champ.
    String output = "";
    String skip = null;
    if( !add )
    {
      skip = lib.get(editNumber).champions.get(currentDisplay);
    }
    for( int i = 0; i < (lib.size()-1); i++ )//Skip last because 'All' is the last element
    {
      if( lib.get(i).champions.size() == 0 )
      {
        output += "\"" + lib.get(i).name + "\"";
      }
      else
      {
        for( int j = 0; j < lib.get(i).champions.size(); j++ )
        {
          if( j == 0 )
          {
            output += "\"" + lib.get(i).name + "\"";
            if( !lib.get(i).isEmpty() )
            {
              output += ",";
            }
          }
          if( !lib.get(i).isEmpty() )
          {
            if( lib.get(i).champions.get(j) != skip )
            {
              output += "\"" + lib.get(i).champions.get(j) + "\"";
              if( j != (lib.get(i).champions.size()-1) )
              {
                output += ",";
              }
            }
          }
        }
      }
      if( i != (lib.size()-2) )
      {
        output += "|";
      }
    }
    
    return output;
  }
  
}

class SelectButton extends Button
{
  float currentChampY, arrowY;
  float arrowLeftX, arrowRightX;
  float arrowSize;
  PShape arrow;
  float totalX, currentX;
  float miscTextY;
  String current, total;
  
  SelectButton( float xPos, float yPos, float hitboxX, float hitboxY, String buttonName )
  {
    super(xPos,yPos,hitboxX,hitboxY,buttonName);
    currentChampY = yPos-40;
    arrowY = currentChampY-5;
    arrowSize = 15;
    arrowLeftX = xPos-75;
    arrowRightX = xPos+75;
    arrow = createShape();
    arrow.beginShape(TRIANGLES);
    arrow.fill(0);
    arrow.noStroke();
    arrow.vertex(0,0);
    arrow.vertex(0,arrowSize);
    arrow.vertex(arrowSize,(arrowSize/2));
    arrow.endShape();
  }
  
  public void draw()
  {
    super.draw();
    shape(arrow, arrowRightX, arrowY);
    pushMatrix();
    translate(arrowLeftX, arrowY);
    rotate(radians(180));
    shape(arrow, 0, -15);
    popMatrix();
  }
  
  public boolean hoverArrow( int which )
  {
    //0 = left arrow
    //else = right arrow
    boolean ret = false;
    float x = mouseX;
    float y = mouseY;
    float hitboxLeft, hitboxRight, hitboxTop, hitboxBot;
    hitboxLeft = 0;
    hitboxRight = 0;
    hitboxTop = 0;
    hitboxBot = 0;
    if( which == 0 )
    {
      hitboxLeft = arrowLeftX-arrowSize;
      hitboxRight = arrowLeftX;
      hitboxTop = arrowY-arrowSize;
      hitboxBot = arrowY+arrowSize;
    }
    else
    {
      hitboxLeft = arrowRightX;
      hitboxRight = arrowRightX+arrowSize;
      hitboxTop = arrowY-arrowSize;
      hitboxBot = arrowY+arrowSize;
    }
    if( x >= hitboxLeft && x <= hitboxRight )
    {
      if( y >= hitboxTop && y <= hitboxBot )
      {
        ret = true;
      }
    }
    return ret;
  }
  
}

class AddButton extends SelectButton
{
  int currentDisplay;
  
  AddButton( float xPos, float yPos, float hitboxX, float hitboxY, String buttonName )
  {
    super(xPos, yPos, hitboxX, hitboxY, buttonName);
    currentDisplay = 0;
    total = "Total: " + str(championLib.length);//championLib is static so total does not need to be in update()
    totalX = (width/2)+60;
    miscTextY = currentChampY-30;
    currentX = (width/2)-60;
  }
  
  public void draw()
  {
    super.draw();
    update();
    textSize(17);
    text( championLib[currentDisplay], xPos, currentChampY );
    displayMisc();
  }
  
  public void displayMisc()
  {
    textSize(12);
    text( total, totalX, miscTextY );
    text( current, currentX, miscTextY );
  }
  
  public void update()
  {
    current = "Current: " + str(currentDisplay+1);
  }
  
  public void cycleRight()
  {
    if( currentDisplay == (championLib.length-1) )
    {
      currentDisplay = 0;
    }
    else
    {
      currentDisplay++;
    }
  }
  
  public void cycleLeft()
  {
     if( currentDisplay == 0 )
     {
       currentDisplay = (championLib.length-1);
     }
     else
     {
       currentDisplay--;
     }
  }
  
  public void insert()
  {
    //Add to virtual memory
    lib.get(editNumber).addChamp(championLib[currentDisplay], true);
    
    //Add to file
    if( !dataFileFound )
    {
      dataFileFound = true;
    }
    PrintWriter writer;
    String fName = "data/data.txt";
    File f = new File(fName);
    if( f.exists() )
    {
      f.delete();
    }
    writer = createWriter(fName);
    //Create string in correct format for file
    String output = "";
    output = createOutputString(currentDisplay, true );
    writer.print(output);
    writer.flush();
    writer.close();
  }
}

class DelButton extends SelectButton
{
  int currentDisplay;
  
  DelButton( float xPos, float yPos, float hitboxX, float hitboxY, String buttonName )
  {
    super(xPos, yPos, hitboxX, hitboxY, buttonName);
    currentDisplay = 0;
    totalX = (width/2)+60;
    miscTextY = currentChampY-30;
    currentX = (width/2)-60;
  }
  
  public void draw()
  {
    super.draw();
    update();
    textSize(17);
    if( !lib.get(editNumber).isEmpty() )
    {
      text( lib.get(editNumber).champions.get(currentDisplay), xPos, currentChampY );
    }
    else
    {
      text( "Empty", xPos, currentChampY );
    }
    displayMisc();
  }
  
  public void displayMisc()
  {
    textSize(12);
    text( total, totalX, miscTextY );
    text( current, currentX, miscTextY );
  }
  
  public void update()
  {
    total = "Total: " + str(lib.get(editNumber).champions.size());
    current = "Current: ";
    if( !lib.get(editNumber).isEmpty() )
    {
      current += str(currentDisplay+1);
    }
  }
  
  public void cycleRight()
  {
    if( currentDisplay == (lib.get(editNumber).champions.size()-1) )
    {
      currentDisplay = 0;
    }
    else
    {
      currentDisplay++;
    }
  }
  
  public void cycleLeft()
  {
     if( currentDisplay == 0 )
     {
       currentDisplay = (lib.get(editNumber).champions.size()-1);
     }
     else
     {
       currentDisplay--;
     }
  }
  
  public void delete()
  {
    if( !dataFileFound )
    {
      dataFileFound = true;
    }
    //First delete the file from the file so it will be remembered next time
    PrintWriter writer;
    String fName = "data/data.txt";
    File f = new File(fName);
    if( f.exists() )
    {
      f.delete();
    }
    writer = createWriter(fName);
    //Create string in correct format for file
    String output = "";
    output = createOutputString(currentDisplay,false);
    writer.print(output);
    writer.flush();
    writer.close();
    //Then delete from virtual memory
    lib.get(lib.size()-1).champions.remove(lib.get(editNumber).champions.get(currentDisplay));//delete from 'all'
    lib.get(editNumber).champions.remove(currentDisplay);
    currentDisplay = 0;
  }
}
public void mousePressed()
{
  if( showMainScreen )
  {
    for( int i = 0; i < lib.size(); i++ )
    {
      Role temp = lib.get(i);
      if( temp.button.hovered() )
      {
        if( mouseButton == LEFT )
        {
          copyToClipboard(temp);
        }
        else
        {
          if( temp.name != "All" )
          {
            showMainScreen = false;
            editNumber = i;
          }
        }
        break;
      }
    }
  }
  else
  {
    if( editScreen_backButton.hovered() && mouseButton == LEFT )
    {
      showMainScreen = true;
      editScreen_delButton.currentDisplay = 0;
      editScreen_addButton.currentDisplay = 0;
    }
    checkArrows();//Check all arrows for user input
    if( editScreen_delButton.hovered() && mouseButton == LEFT )
    {
      if( !lib.get(editNumber).isEmpty() )
      {
        editScreen_delButton.delete();
      }  
    }
    if( editScreen_addButton.hovered() && mouseButton == LEFT )
    {
      editScreen_addButton.insert();
    }
  }
}

public void checkArrows()
{
  if( editScreen_addButton.hoverArrow(0) )
    {
      editScreen_addButton.cycleLeft();
    }
    if( editScreen_addButton.hoverArrow(1) )
    {
      editScreen_addButton.cycleRight();
    }
    if( editScreen_delButton.hoverArrow(0) )
    {
      editScreen_delButton.cycleLeft();
    }
    if( editScreen_delButton.hoverArrow(1) )
    {
      editScreen_delButton.cycleRight();
    }
}
class Role
{
  String name;
  ArrayList<String> champions;
  boolean copied;
  float copied_timer;
  Button button;
  
  Role( String[] array, float x, float y )
  {
    champions = new ArrayList<String>();
    copied = false;
    copied_timer = 0;
    name = array[0];
    button = new Button( x, y, 100, 60, name );
    for( int i = 1; i < array.length; i++ )
    {
      addChamp(array[i], false);
    }
  }
  
  Role( float x, float y )
  {
    champions = new ArrayList<String>();
    copied = false;
    copied_timer = 0;
    name = "role_name";
    button = new Button( x, y, 100, 60, name );
  }
  
  public void draw()
  {
    button.draw();
    if( copied )
    {
      confirmCopied();
    }
  }
  
  public void confirmCopied()
  {
    fill(0);
    textSize(15);
    text( "Copied!", (( button.xPos + (button.hitboxX/2) ) + 35), button.yPos);
    if( millis() - copied_timer >= 500 )
    {
      copied = false;
      copied_timer = 0;
    }
  }
  
  public boolean isEmpty()
  {
    boolean ret = false;
    if( champions.size() == 0 )
    {
      ret = true;
    }
    return ret;
  }
  
  public void addChamp( String champion, boolean inRuntime )
  {
    if( champions.size() == 0 | !champions.contains(champion) )
    {
      champions.add(champion);
    }
    //Add to all
    if( inRuntime )
    {
      int t = lib.size();
      t--;
      if( !lib.get(t).champions.contains(champion) )
      {
        lib.get(t).addChamp(champion, false);
      }
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

public void populateChampLib()
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

public void msgRoll()
{
  int i = PApplet.parseInt(random(0, 15));
  int chance = 1;
  if( i == chance )
  {
    showMsg = true;
  }
}

public float calcPercent( float x, float y )
{
  float perc = 0;
  perc = x/100;
  perc *= y;
  return perc;
}

public void populateLib(ArrayList<String[]> data)
{
  String[] all, role1, role2, role3, role4, role5, role6, role7, role8;
  role1 = new String[]{};
  role2 = new String[]{};
  role3 = new String[]{};
  role4 = new String[]{};
  role5 = new String[]{};
  role6 = new String[]{};
  role7 = new String[]{};
  role8 = new String[]{};
  if( data.size() > 0 )
  {
    role1 = data.get(0);
    role2 = data.get(1);
    role3 = data.get(2);
    role4 = data.get(3);
    role5 = data.get(4);
    role6 = data.get(5);
    role7 = data.get(6);
    role8 = data.get(7);
  }
  
  float xPos, yPos;
  xPos = width/2;
  yPos = divSize;
  if( data.size() > 0 )
  {
    lib.add(new Role(role1, xPos, (yPos * 2)));//The number after yPos is what position the buttons will be on the screen
    lib.add(new Role(role2, xPos, (yPos * 3)));
    lib.add(new Role(role3, xPos, (yPos * 4)));
    lib.add(new Role(role4, xPos, (yPos * 5)));
    lib.add(new Role(role5, xPos, (yPos * 6)));
    lib.add(new Role(role6, xPos, (yPos * 7)));
    lib.add(new Role(role7, xPos, (yPos * 8)));
    lib.add(new Role(role8, xPos, (yPos * 9)));
  }
  else
  {
    lib.add(new Role(xPos, (yPos * 2)));
    lib.add(new Role(xPos, (yPos * 3)));
    lib.add(new Role(xPos, (yPos * 4)));
    lib.add(new Role(xPos, (yPos * 5)));
    lib.add(new Role(xPos, (yPos * 6)));
    lib.add(new Role(xPos, (yPos * 7)));
    lib.add(new Role(xPos, (yPos * 8)));
    lib.add(new Role(xPos, (yPos * 9))); 
  }
  
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
  
  String[] s = loadStrings("/data/data.txt");
  if( s != null )
  {
    String[] t = split(s[0], "|");
    
    for( int i = 0; i < t.length; i++ )
    {
      String[] temp = split(t[i], ",");
      for( int j = 0; j < temp.length; j++ )
      {
        temp[j] = temp[j].replaceAll("\"", "");
      }
      ret.add(temp);
    }
  }
  else
  {
    dataFileFound = false;
  }
  
  return ret;
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
