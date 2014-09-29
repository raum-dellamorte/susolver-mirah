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
import com.codename1.ui.geom.Dimension
import com.codename1.ui.layouts.FlowLayout
import com.codename1.ui.Component
import com.codename1.ui.events.ActionEvent
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
	def self.calculateDPI
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
	
	def self.puzMaxWH():int
		w = Display.getInstance.getDisplayWidth
		h = Display.getInstance.getDisplayHeight
		if w < h
			w - 90
		else
			h - 90
		end 
	end
	/*
	def self.switchBtnW():int
		w = Display.getInstance.getDisplayWidth
		h = Display.getInstance.getDisplayHeight
		if w > h
			((w - h) - 60)
		else
			((h - w) - 60)
		end 
	end
	*/
	def self.cellCanBe(cel:int, n:int):boolean
		return true if n == 0
		out = true
		tc = @@puzE[cel]
		81.times do |i:int|
			next if cel == i
			next unless out
			c = @@puzE[i]
			next unless (((c.box() == tc.box()) or (c.row() == tc.row())) or (c.col() == tc.col()))
			next if c.val() == 0
			next if c.val() != n
			out = false
		end
		out
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
		@@suEntry = buildSuEntryPuzzle()
		#@@suSolve = buildSuSolvePuzzle()
		@@suEntry.show()
	end
	
	def buildSuEntryPuzzle():Form
		sz = SuSolverGui.puzMaxWH()
		@@puzE = SuEntryCell[81]
		threeby3 = GridLayout.new(3,3)
		@@puzC = Container.new(threeby3)
		@@puzC.setPreferredSize(Dimension.new(sz,sz))
		se = Form.new() # "SuSolver"
		3.times do |brw:int|
			3.times do |bcl:int|
				bx = Container.new(threeby3)
				isz = int(sz / 3) - 12
				bx.setPreferredSize(Dimension.new(isz,isz))
				bx.getStyle().setMargin(2, 2, 2, 2)
				3.times do |crw:int|
					3.times do |ccl:int|
						loc = ((((brw * 27) + (crw * 9)) + (bcl * 3)) + ccl)
						cel = SuEntryCell.new().setLoc(loc)
						@@puzE[loc] = cel
						bx.addComponent(cel)
					end
				end
				@@puzC.addComponent(bx)
			end
		end
		boxl = Container.new(BoxLayout.new(BoxLayout.Y_AXIS))
		@@toSolver = Button.new("To Solver ->")
		@@toSolver.addActionListener do |e:ActionEvent|
			
		end
		@@toSolver.setPreferredW(sz - 40) #(SuSolverGui.switchBtnW())
		@@toSolver.setPreferredH(30)
		boxl.addComponent(@@puzC)
		boxl.addComponent(@@toSolver)
		#se.addComponent(@@toSolver)
		#se.addComponent(@@puzC)
		flow = FlowLayout.new(Component.CENTER)
		se.setLayout(flow)
		se.addOrientationListener do |e:ActionEvent|
			
		end
		se.addComponent(boxl)
		return se
	end
	
	def buildSuSolvePuzzle():Form
		
	end
end
