SuSolver
========

A Sudoku Solver written in Mirah for the JVM.

Solves with logic but has a brute force option.

Current State
-------------

The backend is functional if incomplete.  It can be used to create whatever kind of frontend and solves most sudoku puzzles.

The Swing frontend is also functional and definitely incomplete.  At some point I'll include a screenshot.

The CodenameOne project, made possible by Steve Hannah's NetBeans plugin for Mirah (https://github.com/shannah/mirah-nbm) is partially functional.  The puzzle entry grid works in the simulator.  It is not connected to the backend yet.  I have to figure out how to make the solver with each cell having 9 small slots for pencil marks and one full size number to replace the pencil marks.  I used buttons for the entry grid, but the solver needs no input itself so no need to make the grid out of buttons.  It should have a "Solve!" button to do the whole puzzle, a "Next Step" button to solve one step at a time, a "Reset" button to start over, and a button to go back to the entry grid.  Maybe other things...

Current ruby scripts for running, compiling and creating jars outside of NetBeans only have Windows in mind.  Will fix eventually.
