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
      addChamp(array[i]);
    }
  }
  
  void draw()
  {
    button.draw();
    if( copied )
    {
      confirmCopied();
    }
  }
  
  void confirmCopied()
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
  
  boolean contains( String champion )
  {
    boolean ret = false;
    for( String s : champions )
    {
      if( champion == s )
        ret = true;
    }
    return ret;
  }
  
  void addChamp( String champion )
  {
    if( !champions.contains(champion) )
    {
      champions.add(champion);
    }
  }
}
