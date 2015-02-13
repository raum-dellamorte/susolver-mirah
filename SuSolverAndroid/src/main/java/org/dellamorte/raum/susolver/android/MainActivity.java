package org.dellamorte.raum.susolver.android;

import android.app.Activity;
import android.os.Bundle;

public class MainActivity extends Activity
{
  DrawPuzzle v;  
	
	/** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);
    //setContentView(R.layout.main);
    v = new DrawPuzzle(this);
		setContentView(v);
		
  }
}
