void mousePressed()
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
    }
    checkArrows();//Check all arrows for user input
    if( editScreen_delButton.hovered() && mouseButton == LEFT )
    {
      editScreen_delButton.delete();
    }
  }
}

void checkArrows()
{
  if( editScreen_addButton.hoverArrow(0) )
    {
      changeChampionLibDisplayed(0);
    }
    if( editScreen_addButton.hoverArrow(1) )
    {
      changeChampionLibDisplayed(1);
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
