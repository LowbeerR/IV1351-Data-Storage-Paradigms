package integration;

public class RentalDBException extends Exception {
    public RentalDBException (String reason){
        super(reason);
    }
    public RentalDBException (String reason, Throwable rootCause){
        super(reason, rootCause);
    }
}
