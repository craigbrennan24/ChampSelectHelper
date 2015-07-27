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
  
  boolean isEmpty()
  {
    boolean ret = false;
    if( champions.size() == 0 )
    {
      ret = true;
    }
    return ret;
  }
  
  void addChamp( String champion, boolean inRuntime )
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
