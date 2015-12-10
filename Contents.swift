//: Playground - noun: a place where people can play

// iOS Swift Programming FINAL PROJECT
// Janet Weber   DUE 12/8/2015
// MySimon

// Description:

// First Sprint/Scrum: generating the pattern sequence

// Second Sprint/Scrum: Displaying the sequence in game style
//   i.e. first element, then first and second, then first
//   second third, and so on.  And can we clear the console??

// Third Sprint/Scrum: Add the simulated playing of the game.  Use a
//   random number to determine the number of matches the simulated
//   player will obtain in this round.

// Fourth Sprint/Scrum: Organize code (classes/objects).  Figure out if 
//    reading/writing to a file will be of value.

// Fifth Sprint/Scrum: Add the ability to play multiple rounds and increase
//    levels.  There are 10 levels, player starts at 1.  Play 3 rounds and if
//    player meets threshold of matches, he moves up.  Player needs 15 matches
//    initially - that's an average of 5 per round.  If he meets the threshold,
//    he moves up one level and his threshold is increased by 3 to 18 or an 
//    average of 6 per round.  Otherwise, he repeats the level with 3 more rounds
//    to try to meet the threshold.

// Final Sprint/Scrum: Add capability for additional character sets (but have
//    computer randomly select one for now). Reogranize and clean up code.

import UIKit

let count = 25                                       // 25 unless debugging

// available character sets - randomly chosen by computer for now
let charSet4: [[Character]] = [["r", "b", "y", "g"], ["a", "s", "d", "f"],
                               ["j", "k", "l", ";"], ["1", "2", "3", "4"],
                               ["a", "b", "c", "d", "e", "f", "g", "h"]]


class SimonGame {
    var chSet : [Character]
    var sequence : String
    var level : Int
    var levelThreshold : Int
    var matchesThisLevel : Int
    
    init() {
        chSet = charSet4[1]
        sequence = ""
        level = 1;
        levelThreshold = 6  // Should be 15 for real.  Other settings (like 6) for debugging.
        matchesThisLevel = 0
    }
    
    // *****************************************
    // Set up Simon game: Takes as input the a flag variable indicating if
    //    this is the very first round or not.  0 - not, 1 - yes.  If very
    //    first round, get character set and display it. Always display headings.
    // ****************************************
    func setup(Num : Int) {
        var outline : String                        // holds output string being constructed
        var randNum, i : Int                        // loop variable i, and random number
        
        if (Num == 1){                              // if very first round (1) then
            randNum = Int(arc4random_uniform(5))    //    computer picks character set
            self.chSet = charSet4[randNum]          //    and assigns it to property
            
            outline = "Character Set => "           // Compose string that will display
            for (i=0; i<chSet.count; i++) {         //      character set
                outline = outline + " " + String(self.chSet[i])
            }
            println(outline)                        // Print the composed string.
            println()
        }
        
        println("\nSimon\t\tPlayer")                // Display headings for simulation
    } // end of function setup()
    
    // *****************************************
    // play one round:
    //
    // Display the generated sequence in game style: first char, then first
    //   and second char, then first second third char, and so on. After
    //   each gamestyle display, wait for user input (in this case - no input,
    //   just have user match sequence correctly until predetermined (randomly
    //   generated) number of matches from above has been reached.
    //
    // ****************************************
    func play() -> Int {
        var numMatches : Int
        
        //numMatches = 3                 // for debugging
        self.generateSequence()          // generate the sequence to match from game character set
        numMatches = self.getNumMatches()// used to randomly simulate when player quits
        
        var j : Int                            // loop variable
        var repSeq = ""                        // declare and/or initialize variables
        var userGuess = ""                     // holds user (computer) "guess"
        var currentRepVal: Int                 // tracks how many chars to repeat from sequence
        
        let genCharSeq = Array(self.sequence) // convert string to character array
        currentRepVal = 0;                    // initialize currentRepVal
        while ((currentRepVal < genCharSeq.count) && // display pattern to be repeated so far
            (currentRepVal <= numMatches)){
                for (j=0; j<currentRepVal+1; j++){
                    println(genCharSeq[j])
                    repSeq.append(genCharSeq[j])     // compose string of the pattern so far
                    //        myGame.clearConsole()
                    //        sleep(2)
                }
                
                // Simulation: As long as the predetermined number of characters to
                //   match has not been reached, set the user's guess to be correct.
                userGuess = repSeq
                if (userGuess == repSeq) {              // guess matches sequence
                    //sleep(3)
                    print("\tMatch it => ")
                    if (currentRepVal <= numMatches-1) {  // AND haven't reached pre-
                        println("\t\(repSeq)\tCorrect!")// determined # matches
                        println()                           // so print "correct" user guess
                        sleep(1)                            // and message then
                        repSeq = ""                         // re-init string var
                    } else {
                        println("\t SORRY NO MATCH!\n")// Pre-det # matches reached.
                    }
                }
                currentRepVal++
                //println("currentRepVal => \(currentRepVal)")
        }
        
        if (currentRepVal >= genCharSeq.count) {  // Round complete, display match msg.
            println("AWESOME! Entire \(genCharSeq.count) character sequence MATCHED\n")
        } else {
            println("You matched \(numMatches) characters! Onto next round.\n")
            currentRepVal += -1                   // decrement as it contains one more than
        }                                         //     we've actually repeated or matched.
        
        //println("returning currentRepVal => \(currentRepVal)") // for debugging
        return(currentRepVal)                               // return number of matches this round
    } // end of play() method
    
    // *****************************************************
    // Every 3rd round see if match threshold has been reached.
    //     If so, increment level and threshold and display.
    //     Otherwise, repeat level.
    // *****************************************************
    func manageLevel (round : Int) -> Void {
        if (round%3 == 0) {                 // only do this every 3rd round - display num of
            println("Matches this level => \(self.matchesThisLevel)") // matches & threshold
            println("Threshold => \(self.levelThreshold)")
            if (self.matchesThisLevel >= self.levelThreshold) { // threshold MET so
                self.level++                                    //   increment level
                self.levelThreshold += 3                        //   increment threshold
                if (self.level <= 10) {                         //   if level under max (10)
                    println("Next Level - Level \(self.level) attained!")// display new level
                }
            } else {                                            // threshold NOT met so
                println("Repeat Level \(self.level)")                   // display repeat level
            }
            self.matchesThisLevel = 0;                      // re-init match counter
        }
    } // end of method manageLevel()
    
    // ***************************************************
    // Determine if simulation is over (randomized).  1 in 6 chance of being true
    // *************************************************
    func quit() -> Bool {
        var randNum : Int
        var done : Bool
        
        randNum = Int(arc4random_uniform(6))  // generate random num betw 0 & 5
        switch (randNum) {                    // switch on the random num
        case 0,1,3,4,5 : done = false         // only 2 sets flag to false
        default: done = true
        }
        if (done) {                           // if flag false, display output
            println("\nComputer has decided it's time to Quit!")
        }
        return(done)                          // return flag
        //return(true)                        // for debugging
    } // end of quit() method
    
    // ***********************************************************
    // Generate a random number (0-length of array) "count" times. 
    // Use that random number as index into char set and append char 
    // at that index to generated sequence string.
    // **************************************************************
    func generateSequence() -> Void {
        var j : Int                         // loop variable
        var randNum : Int                   // random number betw 0 and count of self.chSet
        var len : UInt32                    // holds count of elements in self.chSet
        
        self.sequence = ""                  // initialize sequence (redundant - also in init)
        len = UInt32(self.chSet.count)      // get count of elements in character set
        
        for (j=0; j<count; j++) {                   // count (25) times
            randNum = Int(arc4random_uniform(len))  //    generate random number
            self.sequence += String(chSet[randNum]) //    append char at that index to sequence
        }
        
        // self.sequence = "rgbyrgby"                           // for debugging
        // println ("Generated sequence => \(self.sequence)")
     } // end of function generateSequence()
    
    
    // *********************************************************
    // Generate the number of characters that the user will match in
    //      this simulated game.  Matching a relatively few number of
    //      characters as well as a relatively high number of characters
    //      happens with lower probability (chances are you'll match
    //      at least 5, but not more than 15).  Tried to build that
    //      into this function.
    // *********************************************************
    func getNumMatches() -> Int {
        var x : Int                                 // holds random number betw 0 & 9
        x = Int(arc4random_uniform(9))
        
        switch x {                                  // switch on random number 0-9
        case 0: return(Int(arc4random_uniform(5)) + 1)  // 1-5 1/10 chance to match this many
        case 1: return(Int(arc4random_uniform(2)) + 6)  // 6-7 1/10 chance to match this many
        case 2: return(Int(arc4random_uniform(2)) + 8)  // 8-9 1/10 chance to match this many
        case 3,4,5,6,7,8:
            return(Int(arc4random_uniform(6)) + 10)     // 10-15 6/10 chance for this many
        case 9: return(Int(arc4random_uniform(10)) + 16)// 16-24 1/10 chance to match this many
        default: return(Int(arc4random_uniform(5)))     //  include default for completeness
        }
    } // end of function getNumMatches()
    
    
    // **************************************************
    // Clear the console (NOT REALLY!).  For this to work at all, you must
    // set the assistant editor to be viewed at the bottom and reduce the size
    // to about 10 characters in height.  Then you need to keep your finger on
    // the scroll button to keep the display moving down with the output.
    // (Probably should display this to the console at game start)
    //
    // NOT USING FOR THIS SIMULATION - calls to this are commented out.
    // *************************************************
    func clearConsole() -> Void {
        var k : Int
        for (k=0; k<12; k++) {
            println()
        }
    } // end of function clearConsole()

} // end of mySimon class


// *******************************************
// Main Program
// *******************************************
var playing = true                          // flag for quitting
var gameStart = 1                           // flag for first time
var roundCount = 0                          // tracks total number of round.

var myGame = SimonGame()                    // instantiate game

while (playing) {
    myGame.setup(gameStart)                 // setup game
    myGame.matchesThisLevel += myGame.play()// play one round incrementing matchesThisLevel
    roundCount++                            //  increment the round count
    myGame.manageLevel(roundCount)          //  call method to manage the levels
    
    if (myGame.level > 10) {                //  Check if we've maxed the levels
        println("HIGHEST level completed!") //       YES - do so we are done
        playing = false;
    } else {                                //       NO - call method to see if
        if (myGame.quit() == true) {        //       user (computer) is done playing
            playing = false                 //       and set boolean accordingly
        }
    }
    gameStart = 0                           // Not first time anymore 
}

// Done playing so print out some game stats
println("\nCompleted \(roundCount) total rounds.")
if (myGame.level > 10) {
    println("Level 10 COMPLETED!")
} else {
    println("Level \(myGame.level) attained!\n")
}
println("GameOver! Play Again Soon!");
 
