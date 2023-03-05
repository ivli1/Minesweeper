import de.bezier.guido.*;
int rows = 20;
int cols = 20;
int minecnt = (rows * cols) / 5;
int flgged = 0;
int flgcnt = 0;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
boolean fir = true;
String endn = "";
void setup ()
{
  size(800, 900);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );
  textSize(20);

  //your code to initialize buttons goes here
  buttons = new MSButton[rows][cols];
  for (int i = 0; i < buttons.length; i++) {
    for (int o = 0; o < buttons[i].length; o++) {
      buttons[i][o] = new MSButton(i, o);
    }
  }
}
public void setMines(int x, int y)
{
  ArrayList<MSButton> safety = new ArrayList<MSButton>();

  for (int i = -2; i < 3; i++) {
    for (int o = -2; o < 3; o++) {
      if (isValid(x+i, y+o)) {
        safety.add(buttons[x+i][y+o]);
      }
    }
  }
  while (mines.size () < minecnt) {
    int ex = (int)(Math.random()*cols);
    int wai = (int)(Math.random()*rows);
    if (mines.contains(buttons[ex][wai]) != true && safety.contains(buttons[ex][wai]) != true) {
      mines.add(buttons[ex][wai]);
    }
  }
}

public void draw ()
{
  background( 0 );
}
public boolean isWon()
{
  if (flgcnt == flgged) {
    if (flgcnt == minecnt) {
      endn = "win";
      return true;
    }
  }
  return false;
}
public boolean isValid(int r, int c)
{
  if (r >= 0 && c >= 0 && r < rows && c < cols) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int count = 0;
  for (int r = row-1; r<=row+1; r++)
    for (int c = col-1; c<=col+1; c++)
      if (isValid(r, c) && mines.contains(buttons[r][c]))
        count++;
  if (mines.contains(buttons[row][col]))
    count--;
  return count;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged = false;
  private String myLabel;
  private boolean first = true;
  private boolean fir = true;

  public MSButton ( int row, int col )
  {
    width = 800/cols;
    height = 800/rows;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    if (first && mouseButton != RIGHT) {
      setMines(myRow, myCol);
      first = false;
    }
    if (mouseButton == RIGHT) {
      if (!flagged && !clicked) {
        flagged = true;
        clicked = true;
        flgged += 1;
        if (mines.contains(buttons[myRow][myCol])) {
          flgcnt += 1;
        }
      } else if (flagged) {
        flagged = false;
        clicked = false;
        flgged -= 1;
        if (mines.contains(buttons[myRow][myCol])) {
          flgcnt -= 1;
        }
      }
    } else if (mines.contains(this)) {
      endn = "lose";
      clicked = true;
    } else if (countMines(myRow, myCol) > 0) {
      if (fir == true) {
        setLabel(countMines(myRow, myCol));
        clicked = true;
      }
    } else { 
      for (int r = myRow-1; r<=myRow+1; r++) {
        for (int c = myCol-1; c<=myCol+1; c++) {
          if (isValid(r, c) == true && buttons[r][c].clicked == false && !mines.contains(buttons[r][c])) {
            buttons[r][c].clicked = true;
            buttons[r][c].mousePressed();
          }
        }
      }
    }
  }
  public void draw () 
  {    
    textSize(20);
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
      fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
    fill(0, 255, 255);

    if (endn == "") {
      textSize(40);
      text("Total Mines: " + minecnt, 200, 850);
      text("Flags: " + flgged, 600, 850);
    } else if (endn == "win") {
      noLoop();
      textSize(60);
      text("YOU WON", 400, 850);
    } else if (endn == "lose") {
      noLoop();
      textSize(60);
      text("YOU LOST", 400, 850);
      
    }
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    if (fir = true) {
      int inc = 0;
      fir = false;
      if ((int)(Math.random()*10) < 5) {
        inc += 1;
      } else inc -= 1;
      myLabel = ""+ (newLabel + inc);
    }
  }
  public String getLabel() {
    return myLabel.toString();
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
