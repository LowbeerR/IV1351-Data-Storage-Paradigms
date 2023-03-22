package startup;

import controller.*;
import view.*;
import integration.*;

public class Main {
    public static void main(String[] args) {
        try {
            new BlockingInterpreter(new Controller()).handleCmds();
        } catch(RentalDBException bdbe) {
            System.out.println("Could not connect to SoundGood db.");
            bdbe.printStackTrace();
        }
    }
}

