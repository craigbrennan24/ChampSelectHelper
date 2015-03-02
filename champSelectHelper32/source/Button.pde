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
  
}

class SelectButton extends Button
{
  float currentChampY, arrowY;
  float arrowLeftX, arrowRightX;
  float arrowSize;
  PShape arrow;
  
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
  AddButton( float xPos, float yPos, float hitboxX, float hitboxY, String buttonName )
  {
    super(xPos, yPos, hitboxX, hitboxY, buttonName);
  }
  
  void draw()
  {
    super.draw();
    textSize(17);
    text( championLib[championLibDisplayed], xPos, currentChampY );
  }
}

class DelButton extends SelectButton
{
  int currentDisplay = 0;
  
  DelButton( float xPos, float yPos, float hitboxX, float hitboxY, String buttonName )
  {
    super(xPos, yPos, hitboxX, hitboxY, buttonName);
  }
  
  void draw()
  {
    super.draw();
    textSize(17);
    if( lib.get(editNumber).champions.size() != 0 )
    {
      text( lib.get(editNumber).champions.get(currentDisplay), xPos, currentChampY );
    }
    else
    {
      text( "Empty", xPos, currentChampY );
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
    String skip = lib.get(editNumber).champions.get(currentDisplay);
    for( int i = 0; i < (lib.size()-1); i++ )//Skip last because 'All' is the last element
    {
      for( int j = 0; j < lib.get(i).champions.size(); j++ )
      {
        if( j == 0 )
        {
          output += "\"" + lib.get(i).name + "\",";
        }
        if( lib.get(i).champions.get(j) != skip )
        {
          output += "\"" + lib.get(i).champions.get(j) + "\"";
          if( j != (lib.get(i).champions.size()-1) )
          {
            output += ",";
          }
        }
      }
      if( i != (lib.size()-2) )
      {
        output += "|";
      }
    }
    writer.print(output);
    writer.flush();
    writer.close();
    //Then delete from virtual memory
    lib.get(editNumber).champions.remove(currentDisplay);
    currentDisplay = 0;
  }
}
