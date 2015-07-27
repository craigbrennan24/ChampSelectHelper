class Button
{
  String buttonText;
  float xPos, yPos;
  float hitboxX, hitboxY;
  color baseColor, hoverColor;
  
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
  
  Button(float xPos, float yPos, float hitboxX, float hitboxY, color baseColor, color hoverColor)
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
  
  Button(float xPos, float yPos, float hitboxX, float hitboxY, color baseColor, color hoverColor, String name)
  {
    this(xPos,yPos,hitboxX,hitboxY,baseColor,hoverColor);
    buttonText = name;
  }
  
  void draw()
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

  
  boolean hovered()
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
  
  String createOutputString( int currentDisplay, boolean add )
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
  
  void draw()
  {
    super.draw();
    shape(arrow, arrowRightX, arrowY);
    pushMatrix();
    translate(arrowLeftX, arrowY);
    rotate(radians(180));
    shape(arrow, 0, -15);
    popMatrix();
  }
  
  boolean hoverArrow( int which )
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
  
  void draw()
  {
    super.draw();
    update();
    textSize(17);
    text( championLib[currentDisplay], xPos, currentChampY );
    displayMisc();
  }
  
  void displayMisc()
  {
    textSize(12);
    text( total, totalX, miscTextY );
    text( current, currentX, miscTextY );
  }
  
  void update()
  {
    current = "Current: " + str(currentDisplay+1);
  }
  
  void cycleRight()
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
  
  void cycleLeft()
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
  
  void insert()
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
  
  void draw()
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
  
  void displayMisc()
  {
    textSize(12);
    text( total, totalX, miscTextY );
    text( current, currentX, miscTextY );
  }
  
  void update()
  {
    total = "Total: " + str(lib.get(editNumber).champions.size());
    current = "Current: ";
    if( !lib.get(editNumber).isEmpty() )
    {
      current += str(currentDisplay+1);
    }
  }
  
  void cycleRight()
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
  
  void cycleLeft()
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
  
  void delete()
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
