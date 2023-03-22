package view;

import controller.*;
import integration.RentalDBException;
import model.InstrumentDTO;

import java.util.*;
/**
 * Reads and interprets user commands. This command interpreter is blocking, the user
 * interface does not react to user input while a command is being executed.
 */
public class BlockingInterpreter {
    private static final String PROMPT = "> ";
    private final Scanner console = new Scanner(System.in);
    private final Controller ctrl;
    private boolean keepReceivingCmds = false;

    /**
     * Creates a new instance that will use the specified controller for all operations.
     *
     * @param ctrl The controller used by this instance.
     */
    public BlockingInterpreter(Controller ctrl) {
        this.ctrl = ctrl;
    }

    /**
     * Stops the commend interpreter.
     */
    public void stop() {
        keepReceivingCmds = false;
    }

    /**
     * Interprets and performs user commands. This method will not return until the
     * UI has been stopped. The UI is stopped either when the user gives the
     * "quit" command, or when the method <code>stop()</code> is called.
     */
    public void handleCmds() {
        keepReceivingCmds = true;
        while (keepReceivingCmds) {
            try {
                CmdLine cmdLine = new CmdLine(readNextLine());
                switch (cmdLine.getCmd()) {
                    case HELP:
                        for (Command command : Command.values()) {
                            if (command == Command.ILLEGAL_COMMAND) {
                                continue;
                            }
                            System.out.println(command.toString().toLowerCase());
                        }
                        break;
                    case QUIT:
                        keepReceivingCmds = false;
                        break;
                    case LISTINSTRUMENTS:
                        List<? extends InstrumentDTO> instruments = null;
                        if(cmdLine.getParameter(0).equals("")) {
                            instruments = ctrl.allinstruments();
                            for(InstrumentDTO instrument : instruments){
                                System.out.println(("id: " + instrument.getID() + " price: " + instrument.getBrand()+ ", " + "instrument type: " + instrument.getPrice()));
                        }}
                        else{
                            instruments = ctrl.instruments(cmdLine.getParameter(0));
                        for(InstrumentDTO instrument : instruments){
                            System.out.println(("id: " + instrument.getID() + " brand: " + instrument.getBrand()+ ", " + "price: " + instrument.getPrice()));
                        }}
                        break;
                    case RENT:
                        if(cmdLine.getParameter(0).equals("") || cmdLine.getParameter(1).equals("")) {
                            throw new RentalDBException("wrong input");
                        }
                        else {
                            ctrl.rent(Integer.parseInt(cmdLine.getParameter(0)), Integer.parseInt(cmdLine.getParameter(1)));
                            break;
                        }
                    case TERMINATE:
                        if(cmdLine.getParameter(0).equals("") || cmdLine.getParameter(1).equals("")) {
                            throw new RentalDBException("wrong input");
                        }
                        else{
                            ctrl.terminate(Integer.parseInt(cmdLine.getParameter(0)), Integer.parseInt(cmdLine.getParameter(1)));
                            break;
                        }

                    default:
                        System.out.println("illegal command");
                }
            } catch (Exception e) {
                System.out.println("Operation failed");
                System.out.println(e.getMessage());
                e.printStackTrace();
            }
        }
    }

    private String readNextLine() {
        System.out.print(PROMPT);
        return console.nextLine();
    }
}
