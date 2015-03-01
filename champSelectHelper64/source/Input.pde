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
    }
    if( editScreen_addButton.hoverArrow(0) )
    {
      changeChampionLibDisplayed(0);
    }
    if( editScreen_addButton.hoverArrow(1) )
    {
      changeChampionLibDisplayed(1);
    }
  }
}
