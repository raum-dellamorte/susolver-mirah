package org.dellamorte.raum.susolver.cn1


import com.codename1.ui.Display
import com.codename1.ui.Form
import com.codename1.ui.Label
import com.codename1.ui.plaf.UIManager
import com.codename1.ui.util.Resources
import com.codename1.ui.Container
import com.codename1.ui.layouts.BoxLayout
import com.codename1.ui.Button
import com.codename1.ui.layouts.GridLayout
import java.io.IOException

class SuSolverGui 
	attr_accessor current:Form
	
	def init(context:Object):void
			begin
					theme = Resources(Resources.openLayered("/theme"))
					UIManager.getInstance().setThemeProps(theme.getTheme(theme.getThemeResourceNames()[0]));
			rescue IOException => e
					e.printStackTrace()
			end
			# Pro users - uncomment this code to get crash reports sent to you automatically
			/*Display.getInstance().addEdtErrorHandler ActionListener.new() do |evt:ActionEvent|
					evt.consume()
					Log.p("Exception in AppName version " + Display.getInstance().getProperty("AppVersion", "Unknown"))
					Log.p("OS " + Display.getInstance().getPlatformName())
					Log.p("Error " + evt.getSource())
					Log.p("Current Form " + Display.getInstance().getCurrent().getName())
					Log.e( Throwable(evt.getSource()) )
					Log.sendLog()
			end*/
	end
	
	/**
	 * We use this method to calculate a "fake" DPI based on screen resolution rather than its actual DPI
	 * this is useful so we can have large images on a tablet
	 */
	def calculateDPI
			pixels = Display.getInstance.getDisplayHeight * Display.getInstance.getDisplayWidth
			if pixels > 1000000
					Display.DENSITY_HD
			elsif pixels > 340000
					Display.DENSITY_VERY_HIGH
			elsif pixels > 150000
					Display.DENSITY_HIGH
			else
					Display.DENSITY_MEDIUM
			end
	end
	
	def start():void
			if (@current != nil)
					@current.show()
			else
				init()
			end
	end
	
	def stop():void
			@current = Display.getInstance().getCurrent();
	end
	
	def destroy():void
	end
	
	def init():void
		@suEntry = buildSuEntryPuzzle()
		#@suSolve = buildSuSolvePuzzle()
		@suEntry.show()
	end
	
	def buildSuEntryPuzzle():Form
		@puzE = Button[81]
		@puzC = Container.new(GridLayout.new(3,3))
		se = Form.new("SuSolver")
		3.times do |brw:int|
			3.times do |bcl:int|
				bx = Container.new(GridLayout.new(3,3))
				3.times do |crw:int|
					3.times do |ccl:int|
						loc = ((((brw * 27) + (crw * 9)) + (bcl * 3)) + ccl)
						locrw = ((brw * 3) + crw) + 1
						cel = Button.new("0")
						@puzE[loc] = cel
						bx.addComponent(cel)
					end
				end
				@puzC.addComponent(bx)
			end
		end
		se.addComponent(@puzC)
		return se
	end
	
	def buildSuEntryBox():Container
		
	end
end
