class Role
{
  String name;
  String[] champions;
  float xPos, yPos;
  float hitboxX, hitboxY;
  color button, buttonMouseOver;
  boolean copied;
  float copied_timer;
  
  Role( String[] array, float x, float y )
  {
    button = color( 140 );
    buttonMouseOver = color( 160 );
    copied = false;
    copied_timer = 0;
    xPos = x;
    yPos = y;
    hitboxX = 100;
    hitboxY = 60;
    int size = array.length;
    name = array[0];
    champions = new String[size-1];
    for( int i = 1; i < size; i++ )
    {
      champions[i-1] = array[i];
    }
  }
  
  void draw()
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
  
  void confirmCopied()
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
  
  boolean buttonHover()
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
