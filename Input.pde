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

void checkArrows()
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
