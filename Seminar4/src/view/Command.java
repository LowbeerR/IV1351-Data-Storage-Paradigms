package view;

/**
 * Defines all commands that can be performed by a user of the chat application.
 */
public enum Command {
    /**
     * Lists all instruments.
     */
    LISTINSTRUMENTS,
    /**
     * Begin new rent.
     */
    RENT,
    /**
     * To terminate an ongoing rent.
     */
    TERMINATE,
    /**
     * Lists all commands.
     */
    HELP,
    /**
     * Leave the chat application.
     */
    QUIT,
    /**
     * None of the valid commands above was specified.
     */
    ILLEGAL_COMMAND
}