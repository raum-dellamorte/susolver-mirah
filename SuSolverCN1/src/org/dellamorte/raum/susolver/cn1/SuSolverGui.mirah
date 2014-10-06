package org.dellamorte.raum.susolver.cn1

import org.dellamorte.raum.susolver.supuzzle.*

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
	
	def self.updateBoard():void
		@@puzzle = SuPuzzle.new(3)
		board = int[81]
		81.times do |i:int|
			n = @@puzE[i].val()
			board[i] = n
		end
		@@puzzle.setCells(board)
		81.times do |c:int|
			@@puzS[c].set(@@puzzle.cells[c])
			@@puzS[c].setClue(true) unless (@@puzzle.cells[c].val() == 0)
		end
	end
	
	/**
	* SuSolverGui.cellCanBe(cel:int, n:int):boolean
	* cel - int from 0 to 80 referencing a Sudoku cell.
	* n   - int from 1 to 9 to check against all cells in the same block, row, or column.
	* Returns True if:
	*		- n == 0
	*		- no other cells in same block, row, or column have the value n.
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
		@@suSolve = buildSuSolvePuzzle()
		#@@suSolve.setTransitionInAnimator(@@suEntry.getTransitionInAnimator.copy(true))
		#@@suSolve.setTransitionOutAnimator(@@suEntry.getTransitionOutAnimator.copy(true))
		toEntry()
	end
	
	def self.toEntry():void
		@@suEntry.show()
	end
	
	def self.toSolve():void
		SuSolverGui.updateBoard()
		@@suSolve.show()
	end
	
	def buildSuEntryPuzzle():Form
		sz = SuSolverGui.puzMaxWH()
		@@puzE = SuEntryCell[81]
		g3x3 = GridLayout.new(3,3)
		@@eGrid = Container.new(g3x3)
		@@eGrid.setPreferredSize(Dimension.new(sz,sz))
		se = Form.new() # "SuSolver"
		3.times do |brw:int|
			3.times do |bcl:int|
				bx = Container.new(g3x3)
				bsz = int(sz / 3) - 12
				bx.setPreferredSize(Dimension.new(bsz,bsz))
				bx.getStyle().setMargin(2, 2, 2, 2)
				3.times do |crw:int|
					3.times do |ccl:int|
						loc = ((((brw * 27) + (crw * 9)) + (bcl * 3)) + ccl)
						csz = int(bsz / 3)
						#(csz -= 4) if (csz > 15)
						cel = SuEntryCell.build(loc, csz)
						@@puzE[loc] = cel
						bx.addComponent(cel)
					end
				end
				@@eGrid.addComponent(bx)
			end
		end
		boxl = Container.new(BoxLayout.new(BoxLayout.Y_AXIS))
		@@toSolver = Button.new("To Solver ->")
		@@toSolver.addActionListener do |e:ActionEvent|
			SuSolverGui.toSolve()
		end
		@@toSolver.setPreferredW(sz - 40) #(SuSolverGui.switchBtnW())
		@@toSolver.setPreferredH(30)
		boxl.addComponent(@@eGrid)
		boxl.addComponent(@@toSolver)
		flow = FlowLayout.new(Component.CENTER)
		se.setLayout(flow)
		/*se.addOrientationListener do |e:ActionEvent|; ;end*/
		se.addComponent(boxl)
		return se
	end
	
	def buildSuSolvePuzzle():Form
		sz = SuSolverGui.puzMaxWH()
		@@puzS = SuSolveCell[81]
		g3x3 = GridLayout.new(3,3)
		@@sGrid = Container.new(g3x3)
		@@sGrid.setPreferredSize(Dimension.new(sz,sz))
		se = Form.new() # "SuSolver"
		3.times do |brw:int|
			3.times do |bcl:int|
				bx = Container.new(g3x3)
				bsz = int(sz / 3) - 12
				bx.setPreferredSize(Dimension.new(bsz,bsz))
				bxStl = bx.getStyle()
				bxStl.setMargin(1, 1, 1, 1)
				bxStl.setPadding(0, 0, 0, 0)
				3.times do |crw:int|
					3.times do |ccl:int|
						loc = ((((brw * 27) + (crw * 9)) + (bcl * 3)) + ccl)
						csz = (bsz / 3)
						#(csz -= 6) if (csz > 15)
						cel = SuSolveCell.build(loc, csz)
						@@puzS[loc] = cel
						bx.addComponent(cel)
					end
				end
				@@sGrid.addComponent(bx)
			end
		end
		boxl = Container.new(BoxLayout.new(BoxLayout.Y_AXIS))
		@@toEntry = Button.new("<- To Puzzle Entry")
		@@toEntry.addActionListener do |e:ActionEvent|
			SuSolverGui.toEntry()
		end
		@@toEntry.setPreferredW(sz - 40) #(SuSolverGui.switchBtnW())
		@@toEntry.setPreferredH(30)
		boxl.addComponent(@@sGrid)
		boxl.addComponent(@@toEntry)
		flow = FlowLayout.new(Component.CENTER)
		se.setLayout(flow)
		/*se.addOrientationListener do |e:ActionEvent|; ;end*/
		se.addComponent(boxl)
		return se
	end
end
