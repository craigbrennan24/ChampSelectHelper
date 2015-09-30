void setTitle()
{
  int i = int(random(0, 10));
  if( i <= 4 )
  {
    frame.setTitle("(~˘▾˘)~");
  }
  else
  {
    frame.setTitle("~(˘▾˘~)");
  }
}

void moveScreen()
{
  if( !finishMoveScreen )
  {
    frame.setLocation( int(( displayWidth - width ) - (calcPercent(displayWidth, 1.3 ))), int(calcPercent(displayHeight, 1.3)) );
    if( finishMoveScreen_flag++ > 4 )
    {
      finishMoveScreen = true;
    }
  }
}

void populateChampLib()
{
  
  String[] s = loadStrings("/data/championLib.txt");
  if( s != null )
  {
    championLib = split(s[0], "|");
    championLib = sort(championLib);
  }
  else
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
    "Kha'Zix", "Kindred", "Kog'Maw", "Leblanc", "Lee Sin", "Leona",
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
    dataFileFound = false;
    errorCode = 2;
  }
}

void msgRoll()
{
  int i = int(random(0, 15));
  int chance = 1;
  if( i == chance )
  {
    showMsg = true;
  }
}

float calcPercent( float x, float y )
{
  float perc = 0;
  perc = x/100;
  perc *= y;
  return perc;
}

void populateLib(ArrayList<String[]> data)
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

ArrayList<String[]> loadData()
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
    errorCode = 1;
  }
  
  return ret;
}
