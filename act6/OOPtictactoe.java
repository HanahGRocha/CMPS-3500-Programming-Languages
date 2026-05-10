/*
 * NAME: Hanah Rocha
 * ORGN: CSUB CMPS 3500
 * ASGN: Activity 6
 * DATE: 11/14/25
 * */

// A simple program to demonstrate
// Tic-Tac-Toe Game.


import java.util.*;

//Game of tic tac toe with Main entry point
public class OOPtictactoe {
    public static void main(String[] args){
        Board board = new Board(3);
        Player pX = new ConsolePlayer('X');    
        Player pO = new ConsolePlayer('O');
        new Game(board, pX, pO).run();    
    }
}


//Player class 
abstract class Player {
    private final char mark;
    Player(char mark) { 
        this.mark = mark; 
    }
    public char getMark() { 
        return mark; 
    }
    public abstract int getMove(Board board);
}

//Player
class ConsolePlayer extends Player {
    // Share a single Scanner for both players
    private static final Scanner IN = new Scanner(System.in);

    ConsolePlayer(char mark) { super(mark); }

    @Override
    public int getMove(Board board) {
        while (true) {
            String s = IN.nextLine().trim();
            try {
                int n = Integer.parseInt(s);
                if (n < 1 || n > 9) {
                    System.out.println("Invalid input; re-enter slot number:");
                    continue;
                }
                return n;
            } catch (NumberFormatException e) {
                System.out.println("Invalid input; re-enter slot number:");
            }
        }
    }
}


//Board Class
class Board {
    private final int size;
    private final char[] cells; // '1'.. or 'X' or 'O'

    Board(int size) {
        if (size < 3) throw new IllegalArgumentException("size must be >= 3");
        this.size = size;
        this.cells = new char[size * size];
        for (int i = 0; i < cells.length; i++) cells[i] = (char) ('1' + i);
    }

    public boolean applyMove(int slot, char mark) {
        if (slot < 1 || slot > cells.length) return false;
        int idx = slot - 1;
        if (cells[idx] == 'X' || cells[idx] == 'O') {
            System.out.println("Slot already taken; re-enter slot number:");
            return false;
        }
        cells[idx] = mark;
        return true;
    }

    public boolean isFull() {
        for (char c : cells) if (c != 'X' && c != 'O') return false;
        return true;
    }

    public Character checkWinner() {
        // rows
        for (int r = 0; r < size; r++) {
            char c0 = cells[r * size];
            if (c0 == 'X' || c0 == 'O') {
                boolean ok = true;
                for (int c = 1; c < size; c++) if (cells[r * size + c] != c0) { ok = false; break; }
                if (ok) return c0;
            }
        }
        // cols
        for (int c = 0; c < size; c++) {
            char c0 = cells[c];
            if (c0 == 'X' || c0 == 'O') {
                boolean ok = true;
                for (int r = 1; r < size; r++) if (cells[r * size + c] != c0) { ok = false; break; }
                if (ok) return c0;
            }
        }
        // diag (\)
        char c0 = cells[0];
        if (c0 == 'X' || c0 == 'O') {
            boolean ok = true;
            for (int i = 1; i < size; i++) if (cells[i * size + i] != c0) { ok = false; break; }
            if (ok) return c0;
        }
        // diag (/)
        c0 = cells[size - 1];
        if (c0 == 'X' || c0 == 'O') {
            boolean ok = true;
            for (int i = 1; i < size; i++) if (cells[i * size + (size - 1 - i)] != c0) { ok = false; break; }
            if (ok) return c0;
        }
        return null;
    }

    public void print() {
        System.out.println("|---|---|---|");
        System.out.println("| " + cells[0] + " | " + cells[1] + " | " + cells[2] + " |");
        System.out.println("|-----------|");
        System.out.println("| " + cells[3] + " | " + cells[4] + " | " + cells[5] + " |");
        System.out.println("|-----------|");
        System.out.println("| " + cells[6] + " | " + cells[7] + " | " + cells[8] + " |");
        System.out.println("|---|---|---|");
    }
}



//Game Class
class Game{
    private final Board board;
    private final Player pX;
    private final Player pO;

    Game(Board board, Player pX, Player pO){
        this.board = board;
        this.pX = pX;
        this.pO = pO;
    }
    public void run() {
        System.out.println("Welcome to 3x3 Tic Tac Toe.");
        board.print();

        Player current = pX; // X goes first
        System.out.println("X will play first. Enter a slot number to place X in:");

        while (true) {
            int slot = current.getMove(board);
            if (!board.applyMove(slot, current.getMark())) {
                System.out.println("Invalid input; re-enter slot number:");
                continue;
            }

            board.print();

            Character winner = board.checkWinner();
            if (winner != null) {
                System.out.println("Congratulations! " + winner + "'s have won! Thanks for playing.");
                return;
            }

            if (board.isFull()) {
                System.out.println("It's a draw! Thanks for playing.");
                return;
            }

            // switch turns and prompt
            current = (current == pX) ? pO : pX;
            if (current.getMark() == 'X') {
                System.out.println("X's turn; enter a slot number to place X in:");
            } else {
                System.out.println("O's turn; enter a slot number to place O in:");
            }
        }
    }
}


