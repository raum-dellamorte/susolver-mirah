/*
 * Main Window
 */

package org.dellamorte.raum.susolver.swing

import org.dellamorte.raum.susolver.supuzzle.*
#import org.dellamorte.raum.susolver.swing.*
import org.dellamorte.raum.mirah.awtextra.AbsoluteConstraints
import org.dellamorte.raum.mirah.awtextra.AbsoluteLayout

import java.util.Arrays
import java.util.ArrayList
import java.nio.ByteBuffer
import java.nio.channels.FileChannel
import java.nio.charset.Charset
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.BufferedOutputStream
import java.io.IOException
import java.io.OutputStream
import java.io.PrintStream

import java.awt.*
import java.awt.event.*
import javax.swing.*

/**
 *
 * @author Raum
 */
class SuWindow
#	class CloseAct implements WindowListener
#		def initialize():void; end
#		def windowActivated(e:WindowEvent); end
#		def windowClosed(e:WindowEvent); end
#		def windowClosing(e:WindowEvent); SuWindow.saveEntry(); end
#		def windowDeactivated(e:WindowEvent); end
#		def windowDeiconified(e:WindowEvent); end
#		def windowIconified(e:WindowEvent); end
#		def windowOpened(e:WindowEvent); end
#	end
	class ConsoleStream < OutputStream
		def initialize(textArea:JTextArea):void
			@txt = textArea
		end
		
		$Override
		def write(b:int):void #throws IOException
			@txt.append(String.valueOf(char(b)))
			@txt.setCaretPosition(@txt.getDocument().getLength())
		end
	end
	
	def self.createAndShowGui()
		@@mainWin = JFrame.new("SuSolver by Raum Dellamorte")
		@@entryPanel = SuEntryPuzzle.new()
		@@solvePanel = SuSolvePuzzle.new()
		@@nextStep = JButton.new()
		@@solve = JButton.new()
		@@resetEntry = JButton.new()
		@@resetSolve = JButton.new()
		@@guessMode = JCheckBox.new()
		@@displayScroll = JScrollPane.new()
		@@displayTxt = JTextArea.new()
		@@mainMenu = JMenuBar.new()
		@@fileMenu = JMenu.new()
		@@saveDefault = JMenuItem.new()
		@@loadDefault = JMenuItem.new()
		@@saveBtn =  JMenuItem.new()
		@@saveAsBtn = JMenuItem.new()
		@@loadBtn = JMenuItem.new()
		@@exitBtn = JMenuItem.new()
		
		@@displayTxt.setFont(Font.new("Courier New", Font.PLAIN, 14))
		@@standardOut = System.out()
		@@printStream = PrintStream.new(ConsoleStream.new(@@displayTxt))
		System.setOut(@@printStream)
		System.setErr(@@printStream)
		
		introLbl = JLabel.new()
		nextStepLbl = JLabel.new()
		solveLbl = JLabel.new()
		
		@@mainWin.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)
		
		introLbl.setFont(java::awt::Font.new("Times New Roman", 1, 18)) # NOI18N
		introLbl.setHorizontalAlignment(javax::swing::SwingConstants.CENTER)
		introLbl.setText("Enter Sudoku puzzle values in the box to the left.  Solution will be on the right.") # NOI18N
		
		@@nextStep.setText("Next Step -->")
		@@nextStep.addActionListener do |e:ActionEvent|
			SuWindow.nextStepClicked(e)
		end
		@@solve.setText("Solve!")
		@@solve.addActionListener do |e:ActionEvent|
			SuWindow.solveClicked(e)
		end
		@@guessMode.setFont(java::awt::Font.new("Times New Roman", 0, 10)) # NOI18N
		@@guessMode.setText("Allow Guess Mode (For Extremely Difficult Puzzles)")
		
		@@resetEntry.setText("Reset Puzzle Entry")
		@@resetEntry.addActionListener do |e:ActionEvent|
			SuWindow.resetEntryClicked(e)
		end
		
		@@resetSolve.setText("Reset Solution")
		@@resetSolve.addActionListener do |e:ActionEvent|
			SuWindow.resetSolveClicked(e)
		end
		
		@@displayScroll.setHorizontalScrollBarPolicy(javax::swing::ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER)
		@@displayScroll.setVerticalScrollBarPolicy(javax::swing::ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS)
		@@displayScroll.setAutoscrolls(true)
		
		@@displayTxt.setColumns(20)
		@@displayTxt.setRows(5)
		@@displayScroll.setViewportView(@@displayTxt)
		
		nextStepLbl.setFont(java::awt::Font.new("Times New Roman", 0, 12)) # NOI18N
		nextStepLbl.setText("\"Next Step\" solves one step at a time.")
		
		solveLbl.setFont(java::awt::Font.new("Times New Roman", 0, 12)) # NOI18N
		solveLbl.setText("\"Solve!\" performs all steps necessary to solve the puzzle.")
		
		@@fileMenu.setText("File");
		
		@@saveDefault.setText("Save to Default File");
		@@saveDefault.addActionListener do |e:ActionEvent|
			SuWindow.saveEntry()
		end
		@@fileMenu.add(@@saveDefault);
		
		@@loadDefault.setText("Load from Default File");
		@@loadDefault.addActionListener do |e:ActionEvent|
			SuWindow.loadEntry()
		end
		@@fileMenu.add(@@loadDefault)
		@@fileMenu.add(javax::swing::JPopupMenu.Separator.new())
		
		@@saveBtn.setText("Save")
		@@saveBtn.setEnabled(false)
		@@fileMenu.add(@@saveBtn)
		
		@@saveAsBtn.setText("Save As...")
		@@saveAsBtn.setEnabled(false)
		@@fileMenu.add(@@saveAsBtn)
		
		@@loadBtn.setText("Load")
		@@loadBtn.setEnabled(false)
		@@fileMenu.add(@@loadBtn)
		@@fileMenu.add(javax::swing::JPopupMenu.Separator.new())
		
		@@exitBtn.setText("Exit")
		@@exitBtn.setEnabled(false)
		@@fileMenu.add(@@exitBtn)
		
		@@mainMenu.add(@@fileMenu)
		
		@@mainWin.setJMenuBar(@@mainMenu)
		
		overlay = JLayeredPane.new()
		overlay.setMinimumSize(java::awt::Dimension.new(338, 338))
		overlay.setMaximumSize(java::awt::Dimension.new(338, 338))
		overlay.setPreferredSize(java::awt::Dimension.new(338, 338))
		overlay.setLayout(javax::swing::OverlayLayout.new(overlay))
		
		rowColMask = JPanel.new()
		rowColMask.setFocusable(false)
		rowColMask.setAlignmentX(float(0.5))
		rowColMask.setAlignmentY(float(0.5))
		rowColMask.setMinimumSize(java::awt::Dimension.new(338, 338))
		rowColMask.setMaximumSize(java::awt::Dimension.new(338, 338))
		rowColMask.setOpaque(false)
		rowColMask.setPreferredSize(java::awt::Dimension.new(338, 338))
		rowColMask.setRequestFocusEnabled(false)
		rowColMask.setVerifyInputWhenFocusTarget(false)
		rowColMask.setLayout(AbsoluteLayout.new())
		
		rowLbls = JLabel[9]
		9.times do |i|
			l = JLabel.new()
			l.setBackground(java::awt::Color.new(0, 0, 0))
			l.setFont(java::awt::Font.new("Courier New", 1, 12))
			l.setForeground(java::awt::Color.new(153, 255, 255))
			l.setHorizontalAlignment(javax::swing::SwingConstants.CENTER)
			l.setText("" + char(String(:A).charAt(0) + i))
			l.setMaximumSize(java::awt::Dimension.new(10, 30))
			l.setMinimumSize(java::awt::Dimension.new(10, 30))
			l.setPreferredSize(java::awt::Dimension.new(10, 30))
			rowLbls[i] = l
		end
		rowColMask.add(rowLbls[0], AbsoluteConstraints.new(0, 11, -1, -1))
		rowColMask.add(rowLbls[1], AbsoluteConstraints.new(0, 47, -1, -1))
		rowColMask.add(rowLbls[2], AbsoluteConstraints.new(0, 83, -1, -1))
		rowColMask.add(rowLbls[3], AbsoluteConstraints.new(0, 119, -1, -1))
		rowColMask.add(rowLbls[4], AbsoluteConstraints.new(0, 155, -1, -1))
		rowColMask.add(rowLbls[5], AbsoluteConstraints.new(0, 191, -1, -1))
		rowColMask.add(rowLbls[6], AbsoluteConstraints.new(0, 227, -1, -1))
		rowColMask.add(rowLbls[7], AbsoluteConstraints.new(0, 263, -1, -1))
		rowColMask.add(rowLbls[8], AbsoluteConstraints.new(0, 299, -1, -1))
		
		colLbls = JLabel[9]
		9.times do |i|
			l = JLabel.new()
			l.setBackground(java::awt::Color.new(0, 0, 0))
			l.setFont(java::awt::Font.new("Courier New", 1, 12))
			l.setForeground(java::awt::Color.new(153, 255, 255))
			l.setHorizontalAlignment(javax::swing::SwingConstants.CENTER)
			l.setText("" + (1 + i))
			l.setMaximumSize(java::awt::Dimension.new(30, 10))
			l.setMinimumSize(java::awt::Dimension.new(30, 10))
			l.setPreferredSize(java::awt::Dimension.new(30, 10))
			colLbls[i] = l
		end
		rowColMask.add(colLbls[0], AbsoluteConstraints.new(10, 2, -1, -1))
		rowColMask.add(colLbls[1], AbsoluteConstraints.new(46, 2, -1, -1))
		rowColMask.add(colLbls[2], AbsoluteConstraints.new(80, 2, -1, -1))
		rowColMask.add(colLbls[3], AbsoluteConstraints.new(118, 2, -1, -1))
		rowColMask.add(colLbls[4], AbsoluteConstraints.new(154, 2, -1, -1))
		rowColMask.add(colLbls[5], AbsoluteConstraints.new(190, 2, -1, -1))
		rowColMask.add(colLbls[6], AbsoluteConstraints.new(226, 2, -1, -1))
		rowColMask.add(colLbls[7], AbsoluteConstraints.new(262, 2, -1, -1))
		rowColMask.add(colLbls[8], AbsoluteConstraints.new(298, 2, -1, -1))
		
		overlay.add(rowColMask)
		overlay.add(solvePanel)
		
		layout = GroupLayout.new(@@mainWin.getContentPane())
		@@mainWin.getContentPane().setLayout(layout)
		layout.setHorizontalGroup(
			layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
			.addGroup(layout.createSequentialGroup()
				.addContainerGap()
				.addGroup(layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
					.addComponent(@@displayScroll)
					.addComponent(introLbl, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGroup(layout.createSequentialGroup()
						.addGroup(layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
							.addGroup(layout.createSequentialGroup()
								.addComponent(@@entryPanel, javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
								.addGap(0, 2, Short.MAX_VALUE))
							.addGroup(layout.createSequentialGroup()
								.addComponent(@@resetEntry)
								.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED, javax::swing::GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
								.addComponent(nextStepLbl))
							.addGroup(layout.createSequentialGroup()
								.addGap(0, 0, Short.MAX_VALUE)
								.addComponent(solveLbl)))
						.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
						.addGroup(layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
							.addGroup(layout.createSequentialGroup()
								.addComponent(@@solve)
								.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
								.addComponent(@@guessMode))
							.addGroup(layout.createParallelGroup(javax::swing::GroupLayout.Alignment.TRAILING, false)
								.addGroup(layout.createSequentialGroup()
									.addComponent(@@nextStep)
									.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED, javax::swing::GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
									.addComponent(@@resetSolve))
								.addComponent(overlay, javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)))))
				.addContainerGap())
		)
		layout.setVerticalGroup(
			layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
			.addGroup(layout.createSequentialGroup()
				.addContainerGap()
				.addComponent(introLbl, javax::swing::GroupLayout.PREFERRED_SIZE, 35, javax::swing::GroupLayout.PREFERRED_SIZE)
				.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
				.addGroup(layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
					.addComponent(@@entryPanel, 340, 340, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(overlay, 340, 340, javax::swing::GroupLayout.PREFERRED_SIZE))
				.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
				.addGroup(layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
					.addGroup(layout.createParallelGroup(javax::swing::GroupLayout.Alignment.BASELINE)
						.addComponent(@@nextStep)
						.addComponent(nextStepLbl))
					.addComponent(@@resetEntry)
					.addComponent(@@resetSolve))
				.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
				.addGroup(layout.createParallelGroup(javax::swing::GroupLayout.Alignment.BASELINE)
					.addComponent(@@solve)
					.addComponent(@@guessMode)
					.addComponent(solveLbl))
				.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
				.addComponent(@@displayScroll, javax::swing::GroupLayout.DEFAULT_SIZE, 155, Short.MAX_VALUE)
				.addContainerGap())
		)
		
		#@@refresh = javax::swing::Timer.new(500, TimeAct.new())
		
		#@@mainWin.addWindowListener(CloseAct.new())
		
		@@mainWin.pack()
		@@mainWin.setVisible(true)
	end
	
	def self.main(args:String[]):void
		SwingUtilities.invokeLater do
			SuWindow.createAndShowGui()
		end
		begin
			SuWindow.loadEntry() if SuWindow.canLoadEntryBool()
		rescue
			
		end
	end
	
	def self.nextStepClicked(e:ActionEvent):void
		@@solvePanel.import(@entryPanel.export()) unless @@solvePanel.importedBool()
		@@solvePanel.nextStep()
		SuWindow.updateSolvePanel()
	end
	
	def self.solveClicked(e:ActionEvent):void
		@@solvePanel.reset()
		@@solvePanel.import(@entryPanel.export())
		@@solvePanel.solve()
		SuWindow.updateSolvePanel()
	end
	
	def self.resetEntryClicked(e:ActionEvent):void
		@@entryPanel.reset()
		@@solvePanel.setImported(false)
		@@mainWin.revalidate()
		@@mainWin.repaint()
	end
	
	def self.resetSolveClicked(e:ActionEvent):void
		@@solvePanel.reset()
		@@displayTxt.getDocument().remove(0, @@displayTxt.getDocument().getLength())
		@@mainWin.revalidate()
		@@mainWin.repaint()
	end
	
	def self.updateSolvePanel():void
		@@solvePanel.updateCells()
		@@mainWin.revalidate()
		@@mainWin.repaint()
	end
	
	def self.saveEntry(file = "savedSudoku.txt"):void
		sustr = ""
		cnt = 0
		sup = @@entryPanel.export()
		sup.each {|n:int| 
			cnt = cnt + 1
			tmp = "" + n
			if (cnt < sup.length)
				tmp = tmp + " " if ((cnt % 3) != 0)
				tmp = tmp + "  " if (((cnt % 3) == 0) and ((cnt % 9) != 0))
				tmp = tmp + "\n" if (((cnt % 9) == 0) and ((cnt % 27) != 0))
				tmp = tmp + "\n\n" if ((cnt % 27) == 0)
			end
			sustr = sustr + tmp
		}
		sustr = sustr.replaceAll("[^0-9 \n]","")
		begin
			fo = FileOutputStream.new(file)
			bfo = BufferedOutputStream.new(fo, sustr.length + 1)
			begin
				bfo.write(sustr.getBytes(Charset.forName("ASCII")))
			rescue
				puts "failed to write string to file"
			end
			bfo.flush()
			fo.close()
		rescue
			puts "stream or buffer creation failure"
		end
	end
	
	def self.loadEntry():void
		ia = int[81]
		chan = FileInputStream.new("savedSudoku.txt").getChannel()
		buf = ByteBuffer.allocate(1024)
		buf.clear()
		ri = chan.read(buf)
		buf.flip()
		i = 0
		nstr = ""
		while buf.hasRemaining()
			ch = char(buf.get())
			if String("" + ch) =~ /\d/
				nstr = nstr + ch
			else
				if nstr.length > 0
					n = int(Integer.parseInt(nstr))
					ia[i] = n
					i = i + 1
					nstr = ""
				end
			end
		end
		buf.clear()
		chan.close()
		@@entryPanel.import(ia)
	end
	
	def self.canLoadEntryBool():boolean
		fl = File.new("savedSudoku.txt")
		return (fl.exists() and !fl.isDirectory())
	end
	
end

